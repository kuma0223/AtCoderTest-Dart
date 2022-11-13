import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

void main(List<String> arguments) async {
    var input = stdin.transform(utf8.decoder).transform(LineSplitter());
    var reader = Reader(input);
    var ans = await process(reader);
    if(ans != null) print(ans);
    reader.exit();
}

dynamic process(Reader input) async {
  var n = await input.nextInt();
  var aa = await input.takeInt(n).toList();

  var win = true;
  var sum = aa[0];
  var hash = <int>{};
  hash.add(aa[0]);

  for(int i=1; i<n; i++){
    var a = aa[i];
    sum = sum ^ a;
    hash.add(a);
    if(sum == 0){
      win = false;
    }else if(win){
      if(hash.contains(sum)){
        win = true;
      }else{
        win = false;
      }
    }else{
      win = true;
    }
  }

  return win ? "Win" : "Lose";
}

//----------

class Reader{
  var queue = Queue<String>();
  var completers = Queue<Completer<String>>();
  StreamSubscription subscription;

  Reader(Stream<String> stream){
    subscription = stream.listen((x) {
      queue.addAll(x.split(" "));
      //queue.add(x);
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

  Stream<int> takeInt(int count) async*{
    yield* take(count).map(int.parse);
  }

  void exit(){
    subscription.cancel();
  }
}

int char(String s){
  return s.codeUnitAt(0);
}
