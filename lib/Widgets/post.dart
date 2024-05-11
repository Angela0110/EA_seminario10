import 'package:flutter/material.dart';
import 'package:flutter_seminario/Models/UserModel.dart';
import 'package:flutter_seminario/Screens/detalles_user.dart';
import 'package:get/get.dart';


class PostWidget extends StatelessWidget {
  final User user;
  final VoidCallback onUpdate; // Agregar un callback para la actualización

  const PostWidget({Key? key, required this.user, required this.onUpdate}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        title: Text(user.first_name),
        onTap: () {
          Get.to(() => UserDetailsPage(user, onUpdate: onUpdate)); // Pasar la función de actualización a UserDetailsPage
        },
      ),
    );
  }
}
