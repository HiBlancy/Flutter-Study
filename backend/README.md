# DueGlow - Backend (NestJS)

Backend REST API de DueGlow para autenticación, gestión de usuarios, productos cosméticos, rutinas y estadísticas mensuales/anuales.

![NestJS](https://img.shields.io/badge/NestJS-11.x-E0234E?logo=nestjs)
![Node](https://img.shields.io/badge/Node.js-20%2B-339933?logo=node.js)
![MongoDB](https://img.shields.io/badge/MongoDB-Mongoose-47A248?logo=mongodb)
![Estado](https://img.shields.io/badge/Estado-En%20desarrollo-yellow)

---

## Tabla de contenidos

- [Descripción](#descripción)
- [Stack técnico](#stack-técnico)
- [Estructura del backend](#estructura-del-backend)
- [Requisitos](#requisitos)
- [Configuración local](#configuración-local)
- [Variables de entorno](#variables-de-entorno)
- [Scripts útiles](#scripts-útiles)
- [Endpoints principales](#endpoints-principales)

---

## Descripción

Este servicio expone una API REST construida con NestJS y MongoDB para dar soporte a la app Flutter de DueGlow.

Responsabilidades principales:

- Registro, login y perfil de usuario (incluyendo imagen de perfil).
- CRUD de productos con estados/listas y cálculo de caducidad.
- CRUD de rutinas y asociación de productos a cada rutina.
- Estadísticas de uso y procesos de limpieza para históricos mensuales.
- Subida y eliminación de imágenes en Cloudinary.

---

## Stack técnico

- `NestJS 11`
- `Node.js` (recomendado `20+`)
- `MongoDB + Mongoose`
- `JWT` para autenticación
- `Cloudinary` para almacenamiento de imágenes
- `@nestjs/schedule` para tareas programadas

---

## Estructura del backend

```text
src/
├── app.module.ts
├── users/         # autenticación, perfil y gestión de usuarios
├── product/       # productos, listas y estadísticas
├── routines/      # rutinas y productos de rutina
├── cloudinary/    # integración de almacenamiento de imágenes
├── monthly-stats/ # limpieza y gestión de históricos
└── services/      # servicios compartidos (ej. compresión de imagen)
```

---

## Requisitos

- Node.js `20` o superior
- npm
- Instancia MongoDB (local o Atlas)
- Cuenta Cloudinary (si se usan imagenes)

---

## Configuración local

1) Instalar dependencias

```bash
npm install
```

2) Crear archivo `.env` en esta carpeta (`backend/`)

```env
URL=mongodb://localhost:27017/dueglow
PORT=3000
JWT_SECRET=tu_secreto_jwt
CLOUDINARY_CLOUD_NAME=tu_cloud_name
CLOUDINARY_API_KEY=tu_api_key
CLOUDINARY_API_SECRET=tu_api_secret
```

3) Levantar el servidor en desarrollo

```bash
npm run start:dev
```

API disponible en `http://localhost:3000`.
Swagger disponible en `http://localhost:3000/api/docs`.

---

## Variables de entorno

| Variable | Obligatoria | Descripción |
|---|---|---|
| `URL` | Si | Conexión de MongoDB usada por Mongoose |
| `PORT` | No | Puerto HTTP de la API (por defecto `3000`) |
| `JWT_SECRET` | Si | Secreto para firma/validación de tokens |
| `CLOUDINARY_CLOUD_NAME` | Si (imágenes) | Cloud name de Cloudinary |
| `CLOUDINARY_API_KEY` | Si (imágenes) | API key de Cloudinary |
| `CLOUDINARY_API_SECRET` | Si (imágenes) | API secret de Cloudinary |

---

## Scripts útiles

```bash
# Desarrollo (watch)
npm run start:dev

# Build de producción
npm run build

# Ejecutar en produccion (requiere dist generado)
npm run start:prod

# Lint (autofix)
npm run lint

# Tests
npm run test
npm run test:e2e
npm run test:cov
```

---

## Endpoints principales

Prefijos por modulo:

- `/users` -> registro, login, perfil y gestión de cuenta
- `/products` -> CRUD de productos, movimientos de lista, imágenes y stats
- `/routines` -> CRUD de rutinas y gestion de productos asociados

Algunos ejemplos:

- `POST /users/register`
- `POST /users/login`
- `GET /users/me`
- `GET /products`
- `GET /products/stats/summary`
- `GET /products/stats/monthly-history`
- `POST /routines`
- `PATCH /routines/:id/reorder`

---

Para contexto global del proyecto, revisa el README de la raiz: [`../README.md`](../README.md).
