import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<TodoItem>? _itemList;
  String? _error;

  void getTodo() async {
    try {
      setState(() {
        _error = null;
      });

      // await Future.delayed(const Duration(seconds: 3), () {});

      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/todos');
      debugPrint(response.data.toString());
      // parse
      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => TodoItem.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }

    // final response =
    //     await _dio.get('https://jsonplaceholder.typicode.com/todos'); //call api
    // debugPrint(response.data.toString());
    // //parse
    // List list = jsonDecode(response.data);
    // _itemList = list.map((item) => TodoItem.fromJson(item)).toList();
    // setState(() {});
    //before Todo is return
    // for (var elm in _itemList) {
    //   debugPrint(elm.title);
    // };
  }

  @override //do it one time
  void initState() {
    super.initState();
    getTodo();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getTodo();
            },
            child: const Text('RETRY'),
          )
        ],
      );
    } else if (_itemList == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(
          itemCount: _itemList!.length,
          itemBuilder: (context, index) {
            var todoItem = _itemList![index];
            return Card(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(todoItem.title),
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                    'Album ID: ' + todoItem.userId.toString()),
                                color: Color.fromARGB(255, 255, 204, 245),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(25),
                                // ),
                              ),
                              Container(
                                child:
                                    Text('Album ID: ' + todoItem.id.toString()),
                                color: Color.fromARGB(255, 181, 245, 255),
                                margin: EdgeInsets.all(10),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ])));
          });
    }

    return Scaffold(body: body);
    // return Scaffold(
    //     body: _itemList == null
    //         ? const Center(
    //             child: CircularProgressIndicator(),
    //           )
    //         : ListView.builder(
    //             itemCount: _itemList!.length,
    //             itemBuilder: (context, index) {
    //               var todoItem = _itemList![index];
    //               return Text(todoItem.title);
    //             }));

    // if (_itemList == null) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    // return ListView.builder(
    //     itemCount: _itemList!.length,
    //     itemBuilder: (context, index) {
    //       var todoItem = _itemList![index];
    //       return Text(todoItem.title);
    //     });
  }
}
