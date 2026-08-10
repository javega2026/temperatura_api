import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Importamos tu modelo que está en la carpeta models
import '../../models/formulario_modelo.dart';

class FormularioPantalla extends StatefulWidget {
  const FormularioPantalla({super.key});

  @override
  State<FormularioPantalla> createState() => _FormularioPantallaState();
}

class _FormularioPantallaState extends State<FormularioPantalla> {
  // 1. Controladores para las cajas de texto (vigilantes de lo que escribe el usuario)
  final _nombreController = TextEditingController();
  final _medidaController = TextEditingController();

  // 2. Variable para el menú desplegable de cantidad (con sus opciones fijas)
  int _cantidadSeleccionada = 10;
  final List<int> _opcionesCantidad = [10, 20, 30, 40, 50];

  @override
  void dispose() {
    // Importante liberar los controladores cuando la pantalla se destruya
    _nombreController.dispose();
    _medidaController.dispose();
    super.dispose();
  }

  // Método para limpiar el formulario (Botón Reset)
  void _limpiarFormulario() {
    _nombreController.clear();
    _medidaController.clear();
    setState(() {
      _cantidadSeleccionada = 10; // Volvemos al valor inicial
    });
  }

  // Método para procesar, validar y guardar en Firebase (Botón Aceptar)
  void _guardarDatos() async {
    // Validamos que no estén vacíos
    if (_nombreController.text.isEmpty || _medidaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Conversión segura de tipos (String a double para la medida)
      double medidaDouble = double.parse(_medidaController.text);

      // 3. Instanciamos tu clase modelo con los datos seguros
      FormularioModelo nuevoRegistro = FormularioModelo(
        nombre: _nombreController.text,
        cantidad: _cantidadSeleccionada,
        medida: medidaDouble,
        fecha: DateTime.now().toString(),
      );

      // 4. Enviamos a Firebase usando el método toMap() de tu modelo
      await FirebaseFirestore.instance
          .collection('pruebas')
          .add(nuevoRegistro.toMap());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Guardado correctamente desde el formulario!'),
            backgroundColor: Colors.green,
          ),
        );
        _limpiarFormulario(); // Limpiamos tras guardar con éxito
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en el formato de los datos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 5. Diálogo flotante con la cruz de cierre y ancho fijo
  void _mostrarDialogoEdicion(String idDocumento, Map<String, dynamic> datosActuales) {
    final nombreEditController = TextEditingController(text: datosActuales['nombre']);
    final medidaEditController = TextEditingController(text: datosActuales['medida'].toString());
    int cantidadEditSeleccionada = datosActuales['cantidad'] ?? 10;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              // Título con el botón de cerrar (la X)
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Modificar o Borrar'),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              // Aquí hemos envuelto el contenido en un SizedBox para controlar el ancho
              content: SizedBox(
                width: 400, // <--- Este es el ancho que hará que la ventana se vea más amplia
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nombreEditController,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Cantidad:'),
                          DropdownButton<int>(
                            value: cantidadEditSeleccionada,
                            items: _opcionesCantidad.map((int valor) {
                              return DropdownMenuItem<int>(
                                value: valor,
                                child: Text(valor.toString()),
                              );
                            }).toList(),
                            onChanged: (int? nuevoValor) {
                              if (nuevoValor != null) {
                                setStateDialog(() {
                                  cantidadEditSeleccionada = nuevoValor;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: medidaEditController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Medida'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  icon: const Icon(Icons.delete),
                  label: const Text('Borrar'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('pruebas')
                        .doc(idDocumento)
                        .delete();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  onPressed: () async {
                    try {
                      double nuevaMedida = double.parse(medidaEditController.text);
                      await FirebaseFirestore.instance
                          .collection('pruebas')
                          .doc(idDocumento)
                          .update({
                            'nombre': nombreEditController.text,
                            'cantidad': cantidadEditSeleccionada,
                            'medida': nuevaMedida,
                          });
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      // Error en formato numérico
                    }
                  },
                  child: const Text('Actualizar'),
                ),
              ],
            );
          },
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario y Tarjetas Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- SECCIÓN DEL FORMULARIO ---
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre o Descripción',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Selecciona Cantidad:',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<int>(
                  value: _cantidadSeleccionada,
                  items: _opcionesCantidad.map((int valor) {
                    return DropdownMenuItem<int>(
                      value: valor,
                      child: Text(valor.toString()),
                    );
                  }).toList(),
                  onChanged: (int? nuevoValor) {
                    setState(() {
                      if (nuevoValor != null) {
                        _cantidadSeleccionada = nuevoValor;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _medidaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Medida (ej: 22.5)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.show_chart),
              ),
            ),
            const SizedBox(height: 20),

            // Botones de Aceptar y Reset
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    onPressed: _limpiarFormulario,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Aceptar'),
                    onPressed: _guardarDatos,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Registros en tiempo real:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),

            // --- SECCIÓN DE LAS TARJETAS EN TIEMPO REAL ---
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pruebas')
                    .orderBy('fecha', descending: true) // Ordenado del más reciente al antiguo
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No hay registros todavía"));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final String idDocumento = docs[index].id; // <--- AQUÍ CAPTURAMOS EL ID NATIVO DEL DOCUMENTO
                      
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: InkWell(
                          // Al hacer clic en la tarjeta, abrimos el diálogo pasando su ID y sus datos
                          onTap: () => _mostrarDialogoEdicion(idDocumento, data),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nombre: ${data['nombre'] ?? 'Sin nombre'}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Cantidad: ${data['cantidad']} | Medida: ${data['medida']}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data['fecha'] != null ? data['fecha'].toString().substring(11, 19) : '',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.edit, size: 16, color: Colors.blue), // Pequeño aviso visual de que se puede editar
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}