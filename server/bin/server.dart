import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:args/args.dart';
import 'package:shelf/shelf_io.dart' as io;
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:parkingbrake_server/server.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:shelf_static/shelf_static.dart';
import 'package:parkingbrake_server/shared.dart';

Future<void> main(List<String> args) async {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen(logToConsole);

  var parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080')
    ..addOption('data-dir', abbr: 'd')
    ..addOption('web-dir', abbr: 'w', defaultsTo: 'web')
    ..addOption('input-dir', abbr: 'i', defaultsTo: "input")
    ..addOption('trash-dir', abbr: 'c', defaultsTo: "trash")
    ..addOption('output-dir', abbr: 'o', defaultsTo: "output")
    ..addOption('ffprobe', defaultsTo: 'ffprobe')
    ..addOption('handbrake-cli', defaultsTo: 'HandBrakeCLI');

  var result = parser.parse(args);

  var port = int.tryParse(result['port']);

  if (port == null) {
    stdout.writeln(
        'Could not parse port value "${result['port']}" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  String dataDir = result["data-dir"];
  if (dataDir.isEmpty) {
    stdout.writeln('data-dir is required');
    exitCode = 64;
    return;
  }

  String inputDir = result["input-dir"];
  if (inputDir.isEmpty) {
    stdout.writeln('input-dir is required');
    exitCode = 64;
    return;
  } 
  if (path.isRelative(inputDir)) {
    inputDir = path.join(dataDir, inputDir);
  }

  String trashDir = result["trash-dir"];
  if (trashDir.isEmpty) {
    stdout.writeln('trash-dir is required');
    exitCode = 64;
    return;
  }
  if (path.isRelative(trashDir)) {
    trashDir = path.join(dataDir, trashDir);
  }

  String outputDir = result["output-dir"];
  if (outputDir.isEmpty) {
    stdout.writeln('output-dir is required');
    exitCode = 64;
    return;
  }
  if (path.isRelative(outputDir)) {
    outputDir = path.join(dataDir, outputDir);
  }

  String webDir = result["web-dir"];
  if (webDir.isEmpty) {
    stdout.writeln('web-dir is required');
    exitCode = 64;
    return;
  }

  //String url = 'ws://localhost:$port';
  String ffprobe = result["ffprobe"];
  String handbrake = result["handbrake-cli"];

  File globalSettingsFile = File(path.join(dataDir,settingsFileName));
  Map<String,dynamic> globalSettings = <String,dynamic>{};
  if(globalSettingsFile.existsSync()) {
    String text = globalSettingsFile.readAsStringSync();
    globalSettings = jsonDecode(text);
  }

  QueueService service =
      QueueService(inputDir, outputDir, trashDir, ffprobe, handbrake, globalSettings);
  await service.init();

  var socketHandler = webSocketHandler((webSocket, subProtocol) {
    var server = json_rpc.Server(webSocket.cast<String>());

    server.registerMethod("get_queue", () {
      try {
        return service.entries;
      } catch (e) {
        throw json_rpc.RpcException(1, e.toString());
      }
    });

    server.registerMethod("clear_complete", () {
      service.clearComplete();
    });

    server.registerMethod("get_enums", () {
      try {
        return {"encoders": getEncoders()};
      } catch (e) {
        throw json_rpc.RpcException(1, e.toString());
      }
    });

    server.registerMethod("set_encoding_settings", (params) {
      try {
        //String data = params.getString("data");
        //Map json = jsonDecode(data);
        //EncodingSettings encodingSettings = EncodingSettings.fromJson(json);
      } catch (e) {
        throw json_rpc.RpcException(1, e.toString());
      }
    });

    server.listen();
  });

  print("Hosting site files from $webDir");
  var staticHandler =
      createStaticHandler(webDir, defaultDocument: "index.html");

  FutureOr<Response> handler(Request request) {
    if (request.headers.containsKey("sec-websocket-version")) {
      return socketHandler(request);
    } else {
      return staticHandler(request);
    }
  }

  var shelfServer = await io.serve(handler, InternetAddress.anyIPv6, port);
  print('Serving at http://${shelfServer.address.host}:${shelfServer.port}');

}
