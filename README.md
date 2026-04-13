# BTG Pactual — Gestión de Fondos (FPV/FIC)

Aplicación web interactiva y responsiva construida en **Flutter** que permite a un usuario gestionar fondos de inversión BTG Pactual: visualizar fondos disponibles, suscribirse, cancelar participaciones y consultar el historial de transacciones.

---

## Requisitos previos

| Herramienta | Versión mínima |
|---|---|
| Flutter SDK | 3.35.7 (ver `.fvmrc`) |
| Dart SDK | ^3.9.2 |
| FVM *(recomendado)* | cualquiera |
| Navegador | Chrome (para web) |

### Instalar FVM (opcional pero recomendado)

```bash
dart pub global activate fvm
fvm install        # instala la versión definida en .fvmrc
```

---

## Configuración inicial

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd admin-front-end

# 2. Instalar dependencias
flutter pub get
# o con FVM:
fvm flutter pub get
```

---

## Ejecución

### Web (recomendado para este prototipo)

```bash
flutter run -d chrome --target=lib/main_development.dart
```

Con FVM:

```bash
fvm flutter run -d chrome --target=lib/main_development.dart
```

### Listar dispositivos disponibles

```bash
flutter devices
```

### Ejecutar en un dispositivo específico

```bash
flutter run -d <device-id> --target=lib/main_development.dart
```

---

## Credenciales de acceso (modo mock)

> No se requiere backend. El login acepta **cualquier correo y contraseña válidos** (mínimo 8 caracteres).

| Campo | Ejemplo |
|---|---|
| Correo | `usuario@correo.com` |
| Contraseña | `cualquier valor ≥ 8 caracteres` |

---

## Funcionalidades implementadas

### Módulo de Fondos BTG

| # | Funcionalidad | Descripción |
|---|---|---|
| 1 | **Visualizar fondos** | Lista los 5 fondos disponibles con nombre, categoría (FPV/FIC) y monto mínimo |
| 2 | **Suscribirse** | Descuenta el monto del saldo; requiere cumplir el mínimo del fondo |
| 3 | **Cancelar participación** | Reintegra el monto suscrito al saldo disponible |
| 4 | **Historial de transacciones** | Registro cronológico de suscripciones y cancelaciones |
| 5 | **Método de notificación** | Selección de Email o SMS al momento de suscribirse |
| 6 | **Mensajes de error** | Alertas inline si el saldo es insuficiente o el monto no cumple el mínimo |

### Fondos disponibles

| ID | Nombre | Monto mínimo | Categoría |
|---|---|---|---|
| 1 | FPV_BTG_PACTUAL_RECAUDADORA | COP $75.000 | FPV |
| 2 | FPV_BTG_PACTUAL_ECOPETROL | COP $125.000 | FPV |
| 3 | DEUDAPRIVADA | COP $50.000 | FIC |
| 4 | FDO-ACCIONES | COP $250.000 | FIC |
| 5 | FPV_BTG_PACTUAL_DINAMICA | COP $100.000 | FPV |

**Saldo inicial del usuario:** COP $500.000

> El estado es en memoria: al recargar la aplicación, el saldo se reinicia a $500.000.

---

## Arquitectura del proyecto

```
lib/src/features/funds/
├── domain/
│   ├── models/
│   │   ├── fund_model.dart          # Modelo de fondo
│   │   └── transaction_model.dart   # Modelo de transacción + enums
│   └── repositories/
│       └── funds_repository.dart    # Contrato (interfaz)
├── data/
│   └── repositories/
│       └── mock_funds_repository_impl.dart  # Lógica mock en memoria
└── presentation/
    ├── state/
    │   ├── funds_cubit.dart         # Lógica de negocio
    │   └── funds_state.dart         # Estado de la pantalla
    ├── widgets/
    │   ├── funds_balance_card.dart  # Tarjeta de saldo
    │   ├── fund_card.dart           # Tarjeta de fondo (responsive)
    │   ├── subscribe_dialog.dart    # Diálogo de suscripción
    │   ├── cancel_dialog.dart       # Diálogo de cancelación
    │   └── transactions_history_view.dart
    └── funds_screen.dart            # Pantalla principal con tabs
```

**Patrones utilizados:**
- **BLoC / Cubit** para manejo de estado
- **Repository pattern** con implementación mock
- **GoRouter** para navegación (Navigator 2.0)
- **Responsive design** con breakpoints: Mobile < 800px | Tablet 800–1100px | Desktop ≥ 1100px

---

## Comandos útiles

```bash
# Analizar el código
flutter analyze

# Ejecutar tests
flutter test

# Build web
flutter build web --target=lib/main_development.dart
```

---

## Estructura de flavors

El proyecto maneja tres entornos:

| Flavor | Archivo de entrada |
|---|---|
| `development` | `lib/main_development.dart` |
| `staging` | `lib/main_stating.dart` |
| `production` | `lib/main_production.dart` |
