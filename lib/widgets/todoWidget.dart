import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../data_models/todoModel.dart';
import '../screens/homeScreen.dart';
import '../utils/apiCalls.dart';

class TodoWidget extends StatefulWidget {
  final int index;
  final String content;
  final String status;
  final String pageId;
  const TodoWidget(
      {Key? key,
      required this.content,
      required this.status,
      required this.pageId,
      required this.index})
      : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  TextEditingController contentController = TextEditingController();
  String textValue = "";
  bool editEnable = false;
  ApiCall apiCall = ApiCall();
  // HomeScreen homeScreen=HomeScreen(todoListRecieved: [], completeListRecieved: []);
  bool isSending = false;
  bool isCheckbox = false;
  bool isDelete = false;

  @override
  void initState() {
    // TODO: implement initState

    textValue = widget.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isCheckbox
            ? Padding(
                padding: EdgeInsets.all(15.sp),
                child: const CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : Checkbox(
                value: widget.status == "completed",
                onChanged: (value) async {
                  setState(() {
                    isCheckbox = true;
                  });
                  var status = value! ? 'completed' : 'active';
                  var pageId = await apiCall.updateTodo(
                      widget.pageId, widget.content, status);
                  if (pageId != "fail") {
                    if (value == true) {
                      setState(() {
                        todoList.removeAt(widget.index);
                        completedList
                            .add(TodoModel(pageId, status, widget.content));
                        isCheckbox = false;
                        listUpdated.value = !listUpdated.value;
                      });
                    }
                    if (value == false) {
                      setState(() {
                        completedList.removeAt(widget.index);
                        todoList.add(TodoModel(pageId, status, widget.content));
                        isCheckbox = false;
                        listUpdated.value = !listUpdated.value;
                      });
                    }
                    final snackBar = SnackBar(
                      content: Text('Task ' + status),
                      action: SnackBarAction(
                        label: 'Success',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    setState(() {
                      isCheckbox = false;
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
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }),
        editEnable
            ? Flexible(
                child: TextFormField(
                enabled: editEnable,
                controller: contentController,
                style: widget.status == "completed"
                    ? TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
                decoration: InputDecoration(
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                    ),
                    enabled: editEnable
                    // hintText: 'Enter a search term',
                    ),
              ))
            : Flexible(

              child: Text(textValue,
                  style: widget.status == "completed"
                      ? TextStyle(overflow: TextOverflow.clip,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 15.sp)
                      : TextStyle(fontSize: 15.sp,overflow: TextOverflow.clip,)),
            ),
        editEnable
            ? SizedBox()
            :isSending?SizedBox(width: 10.w,): SizedBox(
                width: 15.w,
              ),
        isSending
            ? Padding(
                padding: EdgeInsets.all(15.sp),
                child: const CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : editEnable
                ? TextButton(
                    onPressed: () async {
                      setState(() {
                        isSending = true;
                      });
                      if (contentController.text != "") {
                        editEnable = !editEnable;
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          currentFocus.focusedChild?.unfocus();
                        }
                        var pageId = await apiCall.updateTodo(widget.pageId,
                            contentController.text, widget.status);
                        var value = widget.status == "completed";
                        if (mounted && pageId != "fail") {
                          textValue=contentController.text;
                          if (value != true) {
                            setState(() {
                              todoList[widget.index] = TodoModel(pageId,
                                  widget.status, textValue);
                              isSending = false;
                              listUpdated.value = !listUpdated.value;
                            });
                          }
                          if (value != false) {
                            setState(() {
                              textValue=contentController.text;
                              completedList[widget.index] = TodoModel(pageId,
                                  widget.status,textValue);
                              isSending = false;
                              listUpdated.value = !listUpdated.value;
                            });
                          }

                          final snackBar = SnackBar(
                            content: const Text('Task updated'),
                            action: SnackBarAction(
                              label: 'Success',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        editEnable = !editEnable;
                        contentController.text = textValue;
                      });
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
        isDelete
            ? Padding(
                padding: EdgeInsets.all(15.sp),
                child: const CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : TextButton(
                onPressed: () async {
                  setState(() {
                    isDelete = true;
                  });
                  var value = widget.status == "completed";
                  var pageId = await apiCall.deleteTodo(widget.pageId);
                  if (pageId != "fail") {
                    if (value != true) {
                      setState(() {
                        todoList.removeAt(widget.index);
                        listUpdated.value = !listUpdated.value;
                        isDelete = false;
                      });
                    }
                    if (value != false) {
                      setState(() {
                        completedList.removeAt(widget.index);
                        listUpdated.value = !listUpdated.value;
                        isDelete = false;
                      });
                    }
                    final snackBar = SnackBar(
                      content: const Text('Task Deleted'),
                      action: SnackBarAction(
                        label: 'Success',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    setState(() {
                      isDelete = false;
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
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500),
                ),
              )
      ],
    );
  }
}
