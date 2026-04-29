# ✦ DueGlow

> Aplicación móvil para el seguimiento de productos de belleza y autocuidado: gestión de caducidades, listas personalizadas, rutinas y resumen anual al estilo Spotify Wrapped.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![NestJS](https://img.shields.io/badge/NestJS-10.x-E0234E?logo=nestjs)
![MongoDB Atlas](https://img.shields.io/badge/MongoDB_Atlas-7.x-47A248?logo=mongodb)
![Cloudinary](https://img.shields.io/badge/Cloudinary-3448C5?logo=cloudinary)
![Render](https://img.shields.io/badge/Render-46E3B7?logo=render)
![Estado](https://img.shields.io/badge/Estado-En%20desarrollo-yellow)
![TFG](https://img.shields.io/badge/TFG-2024--2025-blue)

---

## 📋 Tabla de contenidos

- [Descripción](#-descripción)
- [Tecnologías](#-tecnologías)
- [Arquitectura](#-arquitectura)
- [Requisitos previos](#-requisitos-previos)
- [Instalación y configuración](#-instalación-y-configuración)
- [Ejecutar el proyecto](#-ejecutar-el-proyecto)
- [Usar el backend en la nube (Render)](#-usar-el-backend-en-la-nube-render)
- [Estructura del proyecto](#-estructura-del-proyecto)
- [Autor](#-autor)

---

## 📖 Descripción

DueGlow es una aplicación móvil orientada al mundo del autocuidado y la belleza que permite llevar un control completo de tus productos cosméticos: desde su fecha de caducidad hasta las listas de deseos, favoritos y productos ya usados. La app integra un escáner de código de barras que consulta una API externa de productos para añadirlos de forma automática, y permite también la búsqueda manual o la creación de productos personalizados.

Además de la gestión de productos, DueGlow incluye un módulo de rutinas donde el usuario puede crear y organizar sus pasos de skincare, maquillaje o haircare, con la posibilidad de hacerlas públicas para que otros usuarios las consulten. Cada mes y al final del año, la app genera un resumen visual de los productos usados (Project Pan), al estilo Spotify Wrapped.

**Funcionalidades principales:**
- 📦 Gestión de productos por categoría (skincare, bodycare, haircare, maquillaje)
- ⏰ Control de fechas de caducidad con alertas y notificaciones
- 📷 Escaneo de código de barras con integración a API de cosméticos
- 📋 Listas: tengo · quiero · ya usados
- ✨ Project Pan — resumen mensual y anual de productos terminados
- 🧴 Módulo de rutinas con pasos
- 🔒 Sin red social — solo se pueden ver las rutinas públicas de otros usuarios

---

## 🛠 Tecnologías

| Capa | Tecnología | Versión exacta usada |
|------|-----------|----------------------|
| **Frontend (Flutter)** | SDK Dart | `^3.11.3` |
| | Flutter Framework | `3.27.4` (estable) |
| | Provider (estado) | `^6.1.1` |
| | HTTP client | `^1.2.0` |
| | Escáner de barras | `mobile_scanner ^5.0.0` |
| | Almacenamiento seguro | `flutter_secure_storage ^10.0.0` |
| | Imágenes (picker) | `image_picker ^1.0.4` |
| | Procesamiento de imágenes | `image ^4.5.4`, `mime ^1.0.4` |
| | Logging | `logger ^2.0.2+1` |
| **Backend (NestJS)** | NestJS core | `^11.0.1` |
| | Node.js (entorno) | `22.10.7` (tipos) |
| | MongoDB ODM | `mongoose ^9.3.3` |
| | Mongoose para Nest | `@nestjs/mongoose ^11.0.4` |
| | Autenticación | `@nestjs/jwt ^11.0.2`, `passport-jwt ^4.0.1` |
| | Cloudinary SDK | `cloudinary ^2.9.0` |
| | Validación DTO | `class-validator ^0.15.1`, `class-transformer ^0.5.1` |
| | Programación tareas | `@nestjs/schedule ^6.1.3` |
| | Procesamiento imágenes | `sharp ^0.34.5` |
| | Variables entorno | `@nestjs/config ^4.0.3` |
| **Bases de datos** | MongoDB Atlas | Cluster compartido (compatible Mongoose 9) |
| **Almacenamiento** | Cloudinary | API v1.29+ |
| **Despliegue backend** | Render | Plataforma (despliegue continuo) |

> ⚠️ **Compatibilidad**: Este proyecto ha sido desarrollado con las versiones exactas listadas arriba. Si usas versiones más recientes, puede funcionar igual, pero se recomienda seguir las versiones del `pubspec.yaml` y `package.json` para evitar errores.

---

## 🏗 Arquitectura

El proyecto sigue una arquitectura **cliente-servidor** desacoplada:

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENTE (Flutter)                     │
│                                                         │
│   UI Layer ──► State Management ──► Repository Layer    │
│                                          │              │
└──────────────────────────────────────────┼──────────────┘
                                           │ HTTP / REST
                                           ▼
┌─────────────────────────────────────────────────────────┐
│                   BACKEND (NestJS)                      │
│                                                         │
│   Controllers ──► Services ──► Repositories (Mongoose)  │
│                                          │              │
└──────────────────────────────────────────┼──────────────┘
                                           │ Mongoose ODM
                                           ▼
┌─────────────────────────────────────────────────────────┐
│                  BASE DE DATOS (MongoDB)                 │
│                                                         │
│   Collections: [users] [items] [...]                    │
│   Visualización: MongoDB Compass (cualquier equipo)     │
└─────────────────────────────────────────────────────────┘
```

> Para más detalle ver [`/docs/arquitectura.md`](./docs/arquitectura.md)

---

## ✅ Requisitos previos

Para ejecutar el proyecto **completamente en local** necesitas:

- **Flutter SDK** (compatible con Dart `^3.11.3`) – [Instalar Flutter](https://flutter.dev/docs/get-started/install)
- **Node.js** versión `20.x` o superior (se recomienda `22.10.7`)
- **npm**
- **MongoDB Compass** (opcional, para visualizar datos)
- Un emulador Android/iOS o dispositivo físico con depuración USB

Si solo quieres probar la app **sin montar el backend local**, puedes conectar el frontend al backend ya desplegado en Render (ver sección más abajo). En ese caso solo necesitas Flutter.

---

## 🚀 Instalación y configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/[tu-usuario]/[nombre-repo].git
cd [nombre-repo]
```

### 2. Configurar el Backend (NestJS)

```bash
# Entrar en la carpeta del backend
cd backend

# Instalar dependencias
npm install

# Copiar el archivo de variables de entorno
cp .env.example .env

# Editar .env con tus valores (ver sección Variables de entorno)
nano .env

# Ejecutar en modo desarrollo
npm run start:dev
```

El servidor arrancará en `http://localhost:3000`

### 3. Configurar la App (Flutter)

```bash
# Volver a la raíz y entrar en la app
cd ../app

# Obtener dependencias de Flutter
flutter pub get

# Asegúrate de que tienes un emulador corriendo o un dispositivo conectado
flutter devices

# Ejecutar la app
flutter run
```

### 4. Conectar MongoDB Compass

Abre MongoDB Compass e introduce tu cadena de conexión:
```
mongodb://localhost:27017/[nombre-base-de-datos]
```
O si usas Atlas:
```
mongodb+srv://[usuario]:[password]@cluster.mongodb.net/[nombre-bd]
```

---

## 📱 Uso

[Describe aquí cómo usar la aplicación paso a paso. Puedes añadir capturas de pantalla.]

```
1. Abre la app en tu dispositivo
2. Regístrate o inicia sesión
3. [Paso 3...]
4. [Paso 4...]
```

---

## 📁 Estructura del proyecto

```
dueglow/
│
├── app/                                # Proyecto Flutter (cliente móvil)
│   ├── lib/
│   │   ├── core/                       # Configuración global, temas, constantes
│   │   │   ├── constants/              # URLs de API, colores, strings
│   │   │   ├── theme/                  # Tema visual de DueGlow
│   │   │   └── network/                # Cliente HTTP (Dio)
│   │   ├── data/                       # Modelos, repositorios, datasources
│   │   │   ├── models/                 # Product, Routine, User, ProjectPan...
│   │   │   └── repositories/
│   │   └── presentation/               # Pantallas y widgets
│   │       ├── home/
│   │       ├── products/               # Listado, detalle, añadir producto
│   │       ├── scanner/                # Escáner de código de barras
│   │       ├── routines/               # Crear y ver rutinas
│   │       ├── lists/                  # Tengo · Quiero · Favoritos · Usados
│   │       ├── project_pan/            # Resumen mensual y anual
│   │       └── profile/
│   ├── test/
│   └── pubspec.yaml
│
├── backend/                            # Proyecto NestJS (API)
│   ├── src/
│   │   ├── auth/                       # Registro, login, JWT
│   │   ├── users/                      # Gestión de usuarios
│   │   ├── products/                   # CRUD de productos del usuario
│   │   ├── categories/                 # Skincare, haircare, maquillaje...
│   │   ├── lists/                      # Tengo · Quiero · Favoritos · Usados
│   │   ├── routines/                   # Rutinas y pasos
│   │   ├── project-pan/                # Resumen de productos terminados
│   │   ├── barcode/                    # Integración con API externa de cosméticos
│   │   ├── notifications/              # Alertas de caducidad
│   │   ├── common/                     # Guards, interceptors, filtros
│   │   └── main.ts
│   └── package.json
│
├── docs/                               # Documentación extendida
│   ├── arquitectura.md
│   ├── api.md
│   ├── decisiones-tecnicas.md
│   └── guia-desarrollo.md
│
└── README.md
```

---

## 🔐 Variables de entorno

### Backend (`backend/.env`)

```env
# Base de datos
MONGODB_URI=mongodb://localhost:27017/[nombre-bd]

# Servidor
PORT=3000
NODE_ENV=development

# JWT (si usas autenticación con tokens)
JWT_SECRET=tu_secreto_aqui
JWT_EXPIRES_IN=7d

# [Otras variables que necesites]
```

> ⚠️ **Nunca subas el archivo `.env` a Git.** Asegúrate de que está en `.gitignore`.

---

## 👤 Autor

**[Tu nombre]**

- 📧 Email: [ievarituma9877@gmail.com]
- 🐙 GitHub: [@HiBlancy](https://github.com/HiBlancy)
- 🎓 Centro: Digitech Valencia (Progresa)
- 📚 TFG — Curso 2024 - 2026

---

## 📄 Licencia

Este proyecto ha sido desarrollado como Trabajo de Fin de Grado y su uso está restringido a fines académicos. Ver [`LICENSE`](./LICENSE) para más información.
