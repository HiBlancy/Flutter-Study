# ✦ DueGlow Frontend (Flutter)

Aplicación móvil de DueGlow para gestionar productos de belleza, rutinas y resúmenes de uso (Project Pan), conectada al backend en NestJS.

> README del monorepo: [ver documentación general](../README.md)  
> Backend API: [ver README del backend](../backend/README.md)

## 📋 Tabla de contenidos

- [Tecnologías y versiones](#-tecnologías-y-versiones)
- [Requisitos previos](#-requisitos-previos)
- [Instalación y ejecución](#-instalación-y-ejecución)
- [Configuración de API](#-configuración-de-api)
- [Build de producción](#-build-de-producción)
- [Estructura del proyecto](#-estructura-del-proyecto)

## 🛠 Tecnologías y versiones

| Dependencia | Versión |
|---|---|
| Flutter SDK | `3.27.4` (estable) |
| Dart SDK | `^3.11.3` |
| `provider` (estado) | `^6.1.1` |
| `http` (cliente API) | `^1.2.0` |
| `mobile_scanner` | `^5.0.0` |
| `flutter_secure_storage` | `^10.0.0` |
| `image_picker` | `^1.0.4` |
| `image` + `mime` | `^4.5.4` + `^1.0.4` |
| `shared_preferences` | `^2.5.5` |
| `logger` | `^2.0.2+1` |
| `google_fonts` | `^6.2.1` |
| `intl` + `flutter_localizations` | `^0.20.2` |

## ✅ Requisitos previos

- Flutter instalado y operativo (`flutter doctor` sin errores críticos).
- Emulador Android/iOS o dispositivo físico con depuración activada.
- Backend disponible (local o desplegado) para autenticación y datos.

## 🚀 Instalación y ejecución

Si estás en la raíz del repo:

```bash
cd dueglow_app
```

Instala dependencias y ejecuta:

```bash
flutter pub get
flutter run
```

Comandos útiles:

```bash
flutter devices
flutter analyze
```

## 🔌 Configuración de API

Actualmente la URL base se define en `lib/services/api_config.dart`:

- Actualmente está conectada al backend desplegado en Render, la primera llamada genera error porque despierta al setvidor (esperar 1 min aprox) y ya se puede utilizar.
- `_baseUrlWeb` para Flutter Web (por defecto `http://localhost:3000`)
- `_baseUrlMobile` para Android/iOS (por defecto IP local)

Para conectar con otro entorno (por ejemplo Local), cambia esos valores en `ApiConfig`.

> Nota: este frontend no está usando `.env` para `API_URL` en su estado actual; la configuración activa está hardcodeada en `api_config.dart`.

## 📦 Build de producción

APK Android:

```bash
flutter build apk --release
```

Salida:

`build/app/outputs/flutter-apk/app-release.apk`

Android App Bundle (Google Play):

```bash
flutter build appbundle
```

## 🧩 Estructura del proyecto

```text
lib/
├── constants/          # Constantes de la aplicación
├── l10n/               # Internacionalización
├── models/             # Modelos de dominio
├── providers/          # Gestión de estado (Provider)
├── screens/            # Pantallas de la app
├── services/           # API, auth, productos, rutinas, imágenes
├── widgets/            # Componentes reutilizables
├── themes.dart         # Tema, colores y tipografía
└── main.dart           # Punto de entrada
```

