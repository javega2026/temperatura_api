
import 'package:flutter/material.dart';
import 'package:meteoflutter/screens/burcar_pantalla.dart';




void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meteorologico App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const TemperaturaPantalla(),
       home: const BuscarPantalla(),
    );
  }
}


//https://api.openweathermap.org/data/2.5/weather?q=Malaga,es&units=metric&appid=ce8b44e192207db912650d732dacde59



//https://open-meteo.com/
//https://api.open-meteo.com/v1/forecast?latitude=36.7202&longitude=-4.4203&daily=temperature_2m_max,temperature_2m_min&past_days=7&timezone=Europe/Berlin