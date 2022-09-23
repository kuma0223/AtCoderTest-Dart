import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;

void main(List<String> arguments) async {
    var input = stdin.transform(utf8.decoder).transform(LineSplitter());
    var reader = Reader(input);
    var ans = await process(reader);
    if(ans != null) print(ans);
    reader.exit();
}

dynamic process(Reader input) async {
  var txa = await input.nextInt();
  var tya = await input.nextInt();
  var txb = await input.nextInt();
  var tyb = await input.nextInt();
  var t = await input.nextInt();
  var v = await input.nextInt();
  var n = await input.nextInt();
  
  var xx = List.filled(n, 0);
  var yy = List.filled(n, 0);
  for(int i=0; i<n; i++){
    var x = await input.nextInt();
    var y = await input.nextInt();
    xx[i] = x;
    yy[i] = y;
  }

  double diff(int x1, int y1, int x2, int y2){
    return Math.sqrt( (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) );
  }

  for(int i=0; i<n; i++){
    var sum = diff(txa, tya, xx[i], yy[i])
      + diff(xx[i], yy[i], txb, tyb);
    if(sum <= (v * t)){
      return "YES";
    }
  }
  return "NO";
}

class Reader{
  var queue = Queue<String>();
  var completers = Queue<Completer<String>>();
  StreamSubscription subscription;

  Reader(Stream<String> stream){
    subscription = stream.listen((x) {
      queue.addAll(x.split(" "));
      check();
    });
  }

  void check(){
    while(completers.isNotEmpty && queue.isNotEmpty){
      completers.removeFirst().complete(queue.removeFirst());
    }
  }

  Future<String> next(){
    var co = Completer<String>();
    completers.add(co);
    check();
    return co.future;
  }

  Future<int> nextInt() async{
    return int.parse(await next());
  }

  Stream<String> take(int count) async*{
    for(int i=0; i<count; i++){
        yield await next();
    }
  }

  void exit(){
    subscription.cancel();
  }
}

int char(String s){
  return s.codeUnitAt(0);
}
