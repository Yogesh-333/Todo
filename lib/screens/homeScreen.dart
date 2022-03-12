import 'package:flutter/material.dart';
import 'package:galla_todo/data_models/todoModel.dart';

import 'package:galla_todo/widgets/todoWidget.dart';
import 'package:sizer/sizer.dart';
import '../utils/apiCalls.dart';

List<TodoModel> todoList = [];
List<TodoModel> completedList = [];
ValueNotifier<bool> listUpdated = ValueNotifier(false);

class HomeScreen extends StatefulWidget {
  final List<TodoModel> todoListRecieved;
  final List<TodoModel> completeListRecieved;
  const HomeScreen(
      {Key? key,
      required this.todoListRecieved,
      required this.completeListRecieved})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiCall apiCall = ApiCall();

  TextEditingController inputController = TextEditingController();
  bool isSending = false;
  @override
  void initState() {
    // TODO: implement initState
    todoList = widget.todoListRecieved;
    completedList = widget.completeListRecieved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(18.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ADD ITEM",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
                ),
                Divider(
                  thickness: 3,
                  height: 2.h,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: inputController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // hintText: 'Enter a search term',
                        ),
                      ),
                    ),
                    isSending
                        ? Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: const CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : TextButton(
                            onPressed: () async {
                              setState(() {
                                isSending = true;
                              });
                              if (inputController.text != "") {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus &&
                                    currentFocus.focusedChild != null) {
                                  currentFocus.focusedChild?.unfocus();
                                }
                                var pageId = await apiCall
                                    .insertTodo(inputController.text);
                                if (mounted && pageId != "fail") {
                                  setState(() {
                                    todoList.add(TodoModel(pageId, 'active',
                                        inputController.text));
                                    inputController.clear();
                                    isSending = false;
                                  });
                                  final snackBar = SnackBar(
                                    content: const Text('New Task Added'),
                                    action: SnackBarAction(
                                      label: 'Success',
                                      onPressed: () {
                                        // Some code to undo the change.
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  setState(() {
                                    isSending = false;
                                  });
                                  final snackBar = SnackBar(
                                    content: const Text('Please try again'),
                                    action: SnackBarAction(
                                      label: 'Failed',
                                      onPressed: () {
                                        // Some code to undo the change.
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "TODO",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
                ),
                Divider(
                  thickness: 3,
                  height: 2.h,
                  color: Colors.black,
                ),
                SingleChildScrollView(
                  //scrollDirection: Axis.vertical,
                  child: SizedBox(
                      height: 30.h,
                      width: 90.w,
                      child: ValueListenableBuilder<bool>(
                          builder: (_, bool value, __) {
                            return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                shrinkWrap: true,
                                //padding: const EdgeInsets.all(8),
                                itemCount: todoList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: TodoWidget(
                                        content: todoList[index].todo,
                                        status: todoList[index].status,
                                        pageId: todoList[index].pageId,
                                        index: index),
                                  );
                                });
                          },
                          valueListenable: listUpdated)),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "COMPLETED",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
                ),
                Divider(
                  thickness: 3,
                  height: 2.h,
                  color: Colors.black,
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: 30.h,
                    width: 90.w,
                      child: ValueListenableBuilder<bool>(
                          builder: (_, bool value, __) {
                            return ListView.separated(
                                separatorBuilder: (context, index) =>
                                const Divider(
                                  color: Colors.black,
                                ),
                                shrinkWrap: true,
                                //padding: const EdgeInsets.all(8),
                                itemCount: completedList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                    EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: TodoWidget(
                                        content: completedList[index].todo,
                                        status: completedList[index].status,
                                        pageId: completedList[index].pageId,
                                        index: index),
                                  );
                                });
                          },
                          valueListenable: listUpdated)),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
