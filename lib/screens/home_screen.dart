import 'package:animation_login_samples/all_controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return GetBuilder<HomeController>(
        init: HomeController(),
        initState: (_) {},
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("ToDo Example"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                AlertDialog alertDailog = AlertDialog(

                  title: const Text("TODO"),
                    content: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText:"Enter Item",
                        ),
                      ),
                    ),
                  actions: [
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if(controller.text.trim().isNotEmpty){
                              _.addPost(controller.text.trim());
                                  Navigator.pop(context);
                              controller.clear();
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Items can't be empty")));
                            }



                          },
                          child: const Text("Add Item")),
                    )
                  ],
                );

                showDialog(

                  builder: (context) => SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 2,
                      child: alertDailog),
                  context: context,
                  barrierDismissible: false,
                );
                // showModalBottomSheet(
                //     context: context,
                //     builder: (context) => Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Column(
                //           children: [
                //             TextField(
                //               controller: controller,
                //             ),
                //             ElevatedButton(
                //                 onPressed: () => {
                //                       _.addPost(controller.text.trim()),
                //                       Navigator.pop(context),
                //
                //                   controller.clear()
                //                     },
                //                 child: const Text("Save"))
                //           ],
                //         )));
              },
              child: const Text("To Do"),
            ),
            body: ListView.builder(
                itemCount: _.toDoList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => Dismissible(
                      key: ValueKey<String>(_.toDoList[index].id),
                      onDismissed: (direction) => _.deletePost(
                          _.toDoList[index].id,
                      ),
                      background: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          )
                        ],
                      ),
                      child: _.toDoList.isNotEmpty
                          ? Card(
                              elevation: 5,
                              margin: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                trailing: Checkbox(
                                  onChanged: (value) =>
                                      _.updatePost(_.toDoList[index].id, value),
                                  value: _.toDoList[index].isDone,
                                ),
                                title: Text(_.toDoList[index].task!),
                              ),
                            )
                          : const Text(
                              "No Tasks",
                            ),
                    )),
          );
        });
  }
}
