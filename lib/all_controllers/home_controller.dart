import 'package:amplify_api/amplify_api.dart';
import 'package:get/get.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../amplifyconfiguration.dart';
import '../models/ModelProvider.dart';

class HomeController extends GetxController {
  var toDoList = <Todos>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    // Add the following lines to your app initialization to add the DataStore plugin
    final datastorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);
    await Amplify.addPlugin(datastorePlugin);

    await Amplify.addPlugin(AmplifyAPI());

    try {
      await Amplify.configure(amplifyconfig);
      readData();
    } on AmplifyAlreadyConfiguredException {
      safePrint(
          'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
    }
  }

  Future<void> readData() async {
    try {
      toDoList = RxList(await Amplify.DataStore.query(Todos.classType));
      update();
    } catch (e) {
      print(e);
    }
  }

/*Add New Todo*/
  Future<void> addPost(String? task) async {
    try {
      Todos _newTodo = Todos(isDone: false, task: task!);

      await Amplify.DataStore.save(_newTodo);
      readData();
    } on Exception catch (e) {
      print("Error is save Post ==> ${e.toString()}");
    }
  }

  /*Update Todo*/
  Future<void> updatePost(String? id, bool? isDone) async {
    try {
      Todos _oldTodo = (await Amplify.DataStore.query(Todos.classType,
          where: Todos.ID.eq(id)))[0];

      Todos _newTodo =
      _oldTodo.copyWith(task: _oldTodo.task, isDone: isDone!);

      await Amplify.DataStore.save(_newTodo);
      readData();
    } on Exception catch (e) {
      print(e);
    }
  }
  // Future<void> updatePost(String? id, String? task, bool? isDone) async {
  //   try {
  //     Todos oldTodo = (await Amplify.DataStore.query(Todos.classType,
  //         where: Todos.ID.eq(id!)))[0];
  //     Todos _newTodo = oldTodo.copyWith(isDone: false,task: task);
  //
  //     await Amplify.DataStore.save(_newTodo);
  //     readData();
  //   } on Exception catch (e) {
  //     print("Error is Update Post ==> ${e.toString()}");
  //   }
  // }

  /*Delete TODO*/
  Future<void> deletePost(String? id) async {
    try {
      (await Amplify.DataStore.query(Todos.classType, where: Todos.ID.eq(id)))
          .forEach((element) async {
        await Amplify.DataStore.delete(element);
      });
    } catch (e) {
      print("Error is Delete Post ==> ${e.toString()}");
    }
    readData();
  }
}
