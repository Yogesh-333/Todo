import 'package:flutter/material.dart';
import 'package:galla_todo/data_models/todoModel.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

import '../utils/apiCalls.dart';
import 'homeScreen.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  ApiCall apiCall = ApiCall();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/lottiefiles/tickLoad.json'),
      ),
    );
  }

  getData() async {
    List<TodoModel> value = await apiCall.fetchTodo();
    if (value != null) {

      Get.off(HomeScreen(
        todoListRecieved: value.where((e) => e.status!="completed").toList(),
        completeListRecieved: value.where((e) => e.status=="completed").toList(),
      ));
    }
  }
}
