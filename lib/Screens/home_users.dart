import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_seminario/Models/UserModel.dart';
import 'package:flutter_seminario/Screens/home_page.dart';
import 'package:flutter_seminario/Widgets/post.dart';
import 'package:get/get.dart';
import 'package:flutter_seminario/Services/UserService.dart';

late UserService userService;

class UserListPage extends StatefulWidget {
  UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late List<User> lista_users;

  bool isLoading = true; // Nuevo estado para indicar si se están cargando los datos

  @override
  void initState() {
    super.initState();
    userService = UserService();
    getData();
  }

  void getData() async {
    try {
      lista_users = await userService.getData();
      setState(() {
        isLoading = false; // Cambiar el estado de carga cuando los datos están disponibles
      });
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }

  // Función para actualizar la lista de usuarios
  void updateUserList() async {
    setState(() {
      isLoading = true; // Volver a mostrar el indicador de carga mientras se actualiza la lista
    });
    getData(); // Vuelve a cargar los datos de la lista de usuarios
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Muestra un indicador de carga mientras se cargan los datos
      return Center(child: CircularProgressIndicator());
    } else {
      // Muestra la lista de usuarios cuando los datos están disponibles
      return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Users List')),
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.turn_left,
                color: Colors.black,
              ),
              onPressed: () {
                Get.to(HomePage());
              },
            ),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:
                PostWidget(
                  user: lista_users[index],
                  onUpdate: updateUserList, // Pasar la función de actualización como argumento
                ),
            );
          },
          itemCount: lista_users.length,
        ),
      );
    }
  }
}
