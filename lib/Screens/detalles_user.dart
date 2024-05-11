import 'package:flutter/material.dart';
import 'package:flutter_seminario/Models/UserModel.dart';
import 'package:flutter_seminario/Resources/pallete.dart';
import 'package:flutter_seminario/Widgets/button_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter_seminario/Services/UserService.dart';

late UserService userService;


class UserDetailsPage extends StatefulWidget {

  final User user;
  final VoidCallback onUpdate; // Agregar este parámetro

  const UserDetailsPage(this.user, {Key? key, required this.onUpdate}) : super(key: key);
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  bool editing = false;

  final UpdateScreenController controller = Get.put(UpdateScreenController());

  @override
  void initState() {
    super.initState();
    userService = UserService();
    super.initState();

    // Inicializa los controladores de texto con los valores del usuario
    controller.nombreController.text = widget.user.first_name;
    controller.apellidoController.text = widget.user.last_name;
    controller.generoController.text = widget.user.gender;
    controller.rolController.text = widget.user.role;
    controller.contrasenaController.text = widget.user.password;
    controller.mailController.text = widget.user.email;
    controller.telController.text = widget.user.phone_number;
    controller.cumpleController.text = widget.user.birth_date;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: editing
            ? SingleChildScrollView(
                // Utiliza SingleChildScrollView para permitir el desplazamiento
                child: _buildEditView(context),
              )
            : _buildDetailsView(context),
      ),
    );
  }

  Widget _buildDetailsView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${widget.user.first_name} ${widget.user.last_name}'),
        Text('Email: ${widget.user.email}'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              editing = true;
            });
          },
          child: Text('Editar'),
        ),
      ],
    );
  }

  Widget _buildEditView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        ParamTextBox(controller: controller.nombreController, text: 'Nombre'),
        const SizedBox(height: 15),
        ParamTextBox(
            controller: controller.apellidoController, text: 'Apellido'),
        const SizedBox(height: 15),
        ParamTextBox(controller: controller.generoController, text: 'Género'),
        const SizedBox(height: 15),
        ParamTextBox(controller: controller.rolController, text: 'Rol'),
        const SizedBox(height: 15),
        ParamTextBox(
            controller: controller.contrasenaController, text: 'Contraseña'),
        const SizedBox(height: 15),
        ParamTextBox(controller: controller.mailController, text: 'E-Mail'),
        Visibility(
          visible: controller.invalid,
          child: const Text(
            'Invalid',
            style: TextStyle(color: Pallete.salmonColor, fontSize: 15),
          ),
        ),
        const SizedBox(height: 15),
        ParamTextBox(controller: controller.telController, text: 'Teléfono'),
        const SizedBox(height: 15),
        ParamTextBox(
            controller: controller.cumpleController, text: 'Cumpleaños'),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => controller.selectDate(context),
          child: Text('Seleccionar Fecha de Nacimiento'),
        ),
        const SizedBox(height: 15),
        // Mostrar la fecha seleccionada
        const SizedBox(height: 15),
         SignInButton(
          onPressed: () {
            // Llama a updateUser y después ejecuta acciones una vez que se complete
            controller.updateUser(widget.user);
            widget.onUpdate(); 
          },
          text: 'Update',
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class ParamTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String text;

  const ParamTextBox({required this.controller, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: text),
    );
  }
}

class UpdateScreenController extends GetxController {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController rolController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController cumpleController = TextEditingController();

  bool invalid = false;
  bool parameters = false;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      cumpleController.text = pickedDate
          .toString(); // Actualizar el controlador de texto con la fecha seleccionada
    }
  }

  void updateUser(User updatedUser) {
    if (nombreController.text.isEmpty ||
        apellidoController.text.isEmpty ||
        generoController.text.isEmpty ||
        rolController.text.isEmpty ||
        contrasenaController.text.isEmpty ||
        mailController.text.isEmpty ||
        telController.text.isEmpty ||
        cumpleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Campos vacios',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      if (GetUtils.isEmail(mailController.text) == true) {
        User user = User(
          id: updatedUser.id,
          first_name: nombreController.text,
          last_name: apellidoController.text,
          gender: generoController.text,
          role: rolController.text,
          password: contrasenaController.text,
          email: mailController.text,
          phone_number: telController.text,
          birth_date: cumpleController.text,
        );
        userService.updateUser(user).then((statusCode) {
          // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
          print('Usuario editado exitosamente');
          Get.snackbar(
            '¡Usuario editado!',
            'Usuario editado correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
        }).catchError((error) {
          // Manejar errores de solicitud HTTP
          Get.snackbar(
            'Error',
            '',
            snackPosition: SnackPosition.BOTTOM,
          );
          print('Error al enviar usuario al backend: $error');
        });
      } else {
        Get.snackbar(
          'Error',
          'e-mail no valido',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }


}
