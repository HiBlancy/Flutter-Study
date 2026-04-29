# DueGlow - Aplicación Flutter

Aplicación móvil para la gestión de productos de belleza, escaneo de códigos de barras, rutinas y resúmenes anuales (Project Pan).

## Versiones usadas

| Dependencia | Versión |
|-------------|---------|
| Flutter SDK | `3.27.4` (estable) |
| Dart SDK | `^3.11.3` |
| provider (estado) | `^6.1.1` |
| http (cliente API) | `^1.2.0` |
| mobile_scanner | `^5.0.0` |
| flutter_secure_storage | `^10.0.0` |
| image_picker | `^1.0.4` |
| image (procesamiento) | `^4.5.4` |
| shared_preferences | `^2.5.5` |
| logger | `^2.0.2+1` |
| google_fonts | `^6.2.1` |
| intl (internacionalización) | `^0.20.2` |

## Requisitos previos

- Flutter instalado (`flutter doctor` sin errores)
- Emulador Android/iOS o dispositivo físico con depuración USB
- **Backend** funcionando (local o en Render) – ver [README general](../README.md)

## Configuración

### 1. Clonar el repositorio (si no está clonado desde la raíz)

```bash
git clone https://github.com/tu-usuario/dueglow.git
cd dueglow
```

### 2. Ir a la carpeta de la app

```bash
cd app
```

### 3. Obtener dependencias

```bash
flutter pub get
```

### 4. Configurar la URL del backend
La app necesita saber a qué backend conectarse. Elige una opción:

Opción A: Backend local (desarrollo)
Crea un archivo .env en la raíz de app/ con:

```bash
API_URL=http://localhost:3000
```

>⚠️ Asegúrate de que el backend NestJS esté corriendo en http://localhost:3000.

Opción B: Backend desplegado en Render

```bash
API_URL=https://dueglow-api.onrender.com   # cambia por tu URL real
```

### 5. Ejecutar la app
Con dispositivo conectado o emulador encendido:

```bash
flutter run
```

### Generar APK (Android)

```bash
flutter build apk --release
```

El APK se generará en:
build/app/outputs/flutter-apk/app-release.apk

Para generar un AAB (Google Play):

```bash
flutter build appbundle
```

### 🧩 Estructura del proyecto (carpeta lib/)

```
lib/
├── constants/                       #
│   └── app_constants/               #
├── l10n/                            #
│   ├── models/                      
│   └── repositories/
├── models/   
│   ├── beauty_product.dart
│   ├── product_list_type.dart    
│   ├── routine_model.dart
│   └── user.dart               
├── provides/                        # Proveedores
│   ├── locale_provider.dart
│   └── theme_provider.dart
├── screens/                         # Pantallas
│   ├── about_Screen.dart
│   ├── add_product_screen.dart
│   ├── add_routine_screen.dart
│   ├── edit_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── my_products_screen.dart
│   ├── product_screen.dart
│   ├── profile_screen.dart
│   ├── register_screen.dart
│   ├── routine_screen.dart
│   ├── scan_screen.dart
│   ├── search_screen.dart
│   └── settings_screen.dart
├── services/                        # Servicios
│   ├── api_config.dart              # Configuracion general de la Api      
│   ├── auth_services.dart           # Servicio de autentificacion 
│   ├── beauty_api_service.dart      #
│   ├── cleanup_service.dart
│   ├── image_service.dart
│   ├── product_service.dart
│   └── routine_Service.dart
├── widgets/                         # Widgets
│   ├── bottom_app_bar.dart
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── edit_product_dialog.dart
│   ├── main_toolbar.dart
│   ├── product_card.dart
│   └── warning_dialog.dart
├── themes.dart                      # Colores y tipografias de la app
└── main.dart                        # Punto de entrada
```

