# 🌊 MeteoFlutter

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

Aplicación web y móvil desarrollada en **Flutter** para la consulta meteorológica en tiempo real y la gestión/reporte geolocalizado de medusas en playas.

---

## 📌 Características Principales

* 🌤️ **Consulta Climática:** Predicciones meteorológicas actualizadas por localidad y datos históricos.
* 🪼 **Reporte de Medusas:** Formulario dinámico con selección de playa, especies de medusas y nivel de presencia (`1-5`, `6-15`, `>15`).
* 📊 **Contador en Tiempo Real:** Visualización instantánea del número total de reportes registrados mediante Firestore Streams.
* 🗺️ **Geolocalización:** Integración con mapas interactivos para la ubicación exacta de los avistamientos.
* 🔒 **Rutas de Administración:** Acceso directo oculto por URL para gestión de la plataforma.

---

## 🛠️ Tecnologías y APIs Utilizadas

| Servicio / Herramienta | Uso / Descripción |
| :--- | :--- |
| **OpenWeatherMap API** | Datos meteorológicos actuales en tiempo real. |
| **Open-Meteo API** | Histórico meteorológico y predicciones diarias. |
| **Firebase Firestore** | Base de datos NoSQL para reportes y catálogo de medusas. |
| **Firebase Analytics** | Seguimiento de eventos y métricas de uso de la app. |
| **OpenStreetMap** | Visualización de cartografía y coordenadas costeras. |


## OpenStreetMap
---

## 🚀 Inicio Rápido

### Prerrequisitos
* Tener instalado el SDK de **Flutter**.
* Configurar el archivo `.env` en la raíz del proyecto con tus claves de API.

### Ejecución en Desarrollo (Web)

Para arrancar el proyecto en Google Chrome, ejecuta en tu terminal:

```bash
flutter run -d chrome