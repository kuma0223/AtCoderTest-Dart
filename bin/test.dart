import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'main.dart';

void main(List<String> arguments) async {
  var file = arguments.first;
  var count = 1;
  await for(var ca in testCase(file)){
    print("----------");
    print("case $count");
    var sw = Stopwatch();
    sw.start();
    var ans = await process(Reader(ca));
    sw.stop();
    print(ans);
    print("${sw.elapsedMilliseconds}ms");
    count++;
  }
}

Stream<Stream> testCase(String path) async*{
    var input = File(path).openRead().transform(utf8.decoder).transform(LineSplitter());
    StreamController<String> ctrl;

    await for(var s in input){
      if(s.trim() != ""){
        ctrl ??= StreamController();
        ctrl.add(s);
      }else if(ctrl != null){
        yield ctrl.stream;
        ctrl.close();
        ctrl = null;
      }
    }
    if(ctrl!=null) yield ctrl.stream;
}
