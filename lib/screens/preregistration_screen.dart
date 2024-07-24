import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_screen.dart';

class PreRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Inicializa ScreenUtil para manejar diferentes tamaños de pantalla
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true, splitScreenMode: true);

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo con opacidad oscura
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/image/start/start.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Contenido sobre la imagen de fondo
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w), // Utiliza ScreenUtil para padding
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Espacio para el logo
                    Transform.translate(
                      offset: Offset(0, -60.h), // Ajusta el offset con ScreenUtil
                      child: Center(
                        child: Image.asset(
                          'lib/assets/image/logo/logo-color.png',
                          height: 300.h, // Ajusta el tamaño del logo con ScreenUtil
                        ),
                      ),
                    ),

                    // Ajustar el espacio entre el logo y el texto
                    Transform.translate(
                      offset: Offset(0, 50.h), // Ajusta este valor con ScreenUtil
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.87, // Ajusta el ancho según sea necesario
                        child: Text(
                          'Elige tu siguiente aventura',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 60.sp, // Ajusta el tamaño del texto con ScreenUtil
                            height: 1.1, // Ajusta este valor para cambiar el espaciado entre líneas
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h), // Añade un espacio entre el texto y el botón
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navegar a la pantalla de login
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Registrarse', // Cambia el texto del botón a Registrarse
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontSize: 20.sp, // Ajusta el tamaño del texto con ScreenUtil
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 23, 111, 241),
                          padding: EdgeInsets.symmetric(horizontal: 140.w, vertical: 16.h), // Ajusta el padding con ScreenUtil
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
