# Day 3 – async/await & Future 
1. Synchronous vs Asynchronous (≈10 mins)
Review: Dart runs single-threaded using an Event Loop, but can still handle asynchronous tasks (network calls, I/O, timers...) thanks to its non-blocking mechanism
The problem with synchronous code running heavy tasks: the UI freezes/lags (especially critical in Flutter since the UI thread and logic thread are not separated like in native Android)
Introduce the microtask queue and event queue concepts at a basic level (not too deep — just enough to understand why await doesn't block the UI)

2. Future — An object representing a value available in the future (≈20 mins)
What is a Future: an object representing a result that will be available in the future (either success or error), similar to a Promise (JS) or a basic Deferred concept (Kotlin coroutines)
Future states: uncompleted → completed with value / completed with error
Creating a Future:

```dart
Plain Text
  Future<String> fetchUserName() async {    
    await Future.delayed(Duration(seconds: 2));    
    return "Finn Vu";  
  }
```

.then() and .catchError() — the callback-style way of handling a Future (the older approach), compared with async/await (the modern, more readable approach)
Future.wait() — runs multiple Futures in parallel and waits for all to complete, used when calling several APIs at once

3. async/await — Syntax that makes asynchronous code more readable (≈20 mins)
Rule: a function marked async always returns a Future, even if it internally returns a plain value
await can only be used inside an async function, and is used to "wait" for a Future to complete without blocking the thread
Error handling with async/await:
```dart
Plain Text
  Future<void> loadData() async {    
    try {      
      final data = await fetchUserName();      
      print(data);    
    } catch (e) {      
      print("Error: $e");    
    } finally {      
      print("Done");    
    }  
}
```

Direct comparison: the same code snippet written with .then() vs async/await, so learners can clearly see the readability benefit
Common mistake: forgetting await, causing the code to use the Future's value before it has completed (a silent bug that is hard to debug)

4. Applying it in real Flutter development (≈10 mins)
Real example: calling an API inside initState() or inside a button's onPressed — why initState() itself cannot be marked async directly (solution: call a separate async function from within initState)
Preview for Unit 8 (API Integration): async/await will be the required foundation when working with Dio/http
Emphasize: proper async handling helps avoid "loading spinner never stops" or "crash on API call" issues — very common problems among Junior developers


# Day 4 – Stream 
1. What is a Stream? (≈15 mins)
A Stream is a sequence of asynchronous events over time — unlike a Future (which completes once with a single value), a Stream can emit zero, one, or many values over its lifetime, plus an optional error or a "done" signal
Real-world analogy: a Future is like ordering food and waiting for one delivery; a Stream is like a live chat feed — multiple messages arriving over time
Two types of Streams:
Single-subscription Stream — can only be listened to once (default for most Streams, e.g., a file read operation)
Broadcast Stream — can have multiple listeners at the same time (e.g., a shared event bus, button click stream)

Common Flutter/Dart sources of Streams: StreamController, Stream.periodic(), real-time data (WebSocket, Firebase snapshots, sensor data)

2. Listening to a Stream (≈15 mins)
Basic listening:
```dart
  Stream<int> countStream() async* {    
    for (int i = 1; i <= 5; i++) {      
      await Future.delayed(Duration(seconds: 1));      
      yield i;   
    }
  }   
  countStream().listen((data) => print('Received: $data'),    
    onError: (err) => print('Error: $err'),    
    onDone: () => print('Stream closed'),  
  );
```

Explain async* and yield — the Stream equivalent of async/return for Futures
StreamSubscription — how to store it, and why it's important to call .cancel() (avoid memory leaks, especially in dispose() of a StatefulWidget)

3. StreamBuilder — Connecting Streams to the UI (≈20 mins)
StreamBuilder is the most common way to consume a Stream directly in Flutter's widget tree
```dart
  StreamBuilder<int>(    
    stream: countStream(),    
    builder: (context, snapshot) {      
      if (snapshot.connectionState == ConnectionState.waiting) {        
        return CircularProgressIndicator();      
      }      
      if (snapshot.hasError) {        
        return Text('Error: ${snapshot.error}');      
      }      
      return Text('Count: ${snapshot.data}');    
    },  
  )
```

Explain AsyncSnapshot: connectionState, hasData, hasError, data
Common mistake: creating the Stream inside build() (causes it to restart on every rebuild) — best practice is to create it once (e.g., in initState or as a class field)

4. Stream vs Future — When to use which (≈10 mins)
Use Future when: you expect exactly one result (e.g., a single API call, a one-time database read)
Use Stream when: you expect a continuous flow of data (e.g., real-time updates, WebSocket, form field validation, search-as-you-type)
Preview: Streams are the underlying mechanism behind Bloc (Unit 5–6) — Bloc's Stream<State> is built on exactly this concept, so understanding Stream well here directly supports state management later


# Day 5: Async practice
Task: Implement a screen fetching mock data using Future/Stream.
Deliverable: Working Dart/Flutter snippet demonstrating async/await + StreamBuilder.
Evidence: Demo video/screenshot + code in Git.
Rubric: Correct async handling (40%), error handling (30%), code clarity (30%).

# Assignment Evidence:
![▶️ Watch demo video](./assets/demo_app_book_fetching.mov)