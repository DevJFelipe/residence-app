# Residence App

App Flutter para gestión de condominios residenciales. Conectada a un backend FastAPI ([residence-back](https://github.com/luigy-mach/residence-back)).

## Funcionalidades

### Rol Administrador
- **Dashboard** — Estadísticas generales del condominio (ocupación, pagos pendientes, PQRS abiertas)
- **Residentes** — CRUD de residentes y propiedades, asignación de unidades
- **Facturación** — Listado de facturas, filtros por estado de pago, detalle de cobros
- **PQRS** — Gestión completa: ver lista, filtrar por estado, cambiar estado/prioridad, agregar resolución, comentarios
- **Visitantes** — Registro de entrada/salida, confirmación de visitantes pre-registrados por residentes
- **Amenidades** — Gestión de áreas comunes y reservas
- **Más** — Acceso a módulos adicionales (visitantes, información del condominio, anuncios, notificaciones)

### Rol Residente
- **Inicio** — Resumen personal: pagos pendientes, reservas próximas, PQRS abiertas, notificaciones, acciones rápidas
- **Áreas comunes** — Ver amenidades disponibles y hacer reservas
- **Mis Reservas** — Historial y estado de reservas
- **Visitantes** — Pre-registrar visitantes, ver estado (pendiente/activo/salió), marcar salida
- **Perfil** — Información personal, unidad, cambio de contraseña, acceso a Mis PQRS
- **PQRS** — Crear peticiones/quejas/reclamos/sugerencias, ver estado y resolución

### Autenticación
- Login con email + contraseña (verificación PIN por email)
- Registro de nuevos usuarios
- Recuperación de contraseña
- Persistencia de sesión (JWT almacenado en SharedPreferences)
- Routing automático según rol (admin vs residente)

## Requisitos

- Flutter 3.41.6 (gestionado con [FVM](https://fvm.app/))
- Backend [residence-back](https://github.com/luigy-mach/residence-back) corriendo en `http://localhost:8000`

## Instalación

```bash
# Clonar
git clone <repo-url>
cd residence-app

# Instalar dependencias (usa FVM)
fvm flutter pub get

# Ejecutar
fvm flutter run

# Análisis de código
fvm flutter analyze

# Tests
fvm flutter test
```

## Arquitectura

```
lib/
├── core/              # Infraestructura (ApiClient, SessionManager, Router, Theme)
├── models/            # Modelos de datos (fromJson/toJson manual)
├── services/          # Servicios de negocio (AuthService, PqrsService, etc.)
├── providers/         # Riverpod providers (módulo visitantes)
├── data/              # Datasources y repositorios (visitantes)
├── screens/           # Pantallas principales
│   ├── admin_shell.dart    # Shell admin: Dashboard, Residentes, Facturación, PQRS, Más
│   ├── user_shell.dart     # Shell residente: Inicio, Áreas, Reservas, Visitantes, Perfil
│   ├── dashboard/          # Dashboard admin
│   ├── visitors/           # Visitantes admin (registro, log, pendientes)
│   ├── billing/            # Facturación
│   ├── residents/          # Gestión de residentes
│   ├── amenities/          # Amenidades y reservas
│   ├── login/              # Login, registro, forgot password
│   └── profile/            # Cambio de contraseña
├── ui/screens/        # Pantallas UI adicionales
│   ├── admin/
│   │   ├── pqrs/           # PQRS admin (lista + detalle con acciones)
│   │   └── more/           # Menú "Más"
│   └── user/
│       ├── home/           # Home residente
│       ├── visitors/       # Visitantes residente
│       ├── pqrs/           # PQRS residente
│       └── profile/        # Perfil residente
├── theme/             # AppColors, AppTextStyles (Public Sans)
└── main.dart          # Entry point, SessionGate (routing por sesión)
```

## Stack Técnico

- **Flutter** 3.41.6 con FVM
- **HTTP**: Dio con interceptor Bearer token
- **Estado**: setState (mayoría), Riverpod (visitantes)
- **Navegación**: Imperative Navigator.push (no named routes)
- **Fuentes**: Google Fonts (Public Sans)
- **Iconos**: SVG via flutter_svg
- **Sesión**: SharedPreferences

## Configuración Backend

La app se conecta a `http://localhost:8000` por defecto. Para apuntar a producción u otro servidor, editar el `baseUrl` en `lib/core/api_client.dart`.

**Backend en producción:** `http://3.227.231.47`
- Swagger UI: http://3.227.231.47/docs
- ReDoc: http://3.227.231.47/redoc

Asegurarse de ejecutar los seeds del backend antes de usar la app:
```bash
psql -U <usuario> -d <database> -f 001_seed_dev.sql
```
