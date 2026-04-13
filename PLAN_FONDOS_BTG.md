# Plan de implementación: Manejo de Fondos BTG (FPV/FIC)

## Contexto del negocio

Módulo para que un usuario visualice fondos disponibles, se suscriba, cancele su participación
y consulte el historial de transacciones. No requiere backend — toda la lógica es local/mock.

- **Saldo inicial del usuario:** COP $500.000
- **Sin autenticación adicional** (ya existe en el proyecto)

### Fondos disponibles

| ID | Nombre                          | Monto mínimo | Categoría |
|----|---------------------------------|-------------|-----------|
| 1  | FPV_BTG_PACTUAL_RECAUDADORA     | COP $75.000  | FPV       |
| 2  | FPV_BTG_PACTUAL_ECOPETROL       | COP $125.000 | FPV       |
| 3  | DEUDAPRIVADA                    | COP $50.000  | FIC       |
| 4  | FDO-ACCIONES                    | COP $250.000 | FIC       |
| 5  | FPV_BTG_PACTUAL_DINAMICA        | COP $100.000 | FPV       |

---

## Estructura de archivos a crear

```
lib/src/features/funds/
├── domain/
│   ├── models/
│   │   ├── fund_model.dart
│   │   └── transaction_model.dart
│   └── repositories/
│       └── funds_repository.dart
├── data/
│   └── repositories/
│       └── mock_funds_repository_impl.dart
└── presentation/
    ├── funds_screen.dart
    ├── state/
    │   └── funds_cubit.dart
    │   └── funds_state.dart
    └── widgets/
        ├── funds_balance_card.dart
        ├── fund_card.dart
        ├── funds_list_view.dart
        ├── subscribe_dialog.dart
        ├── cancel_dialog.dart
        └── transactions_history_view.dart
```

---

## Paso 1 — Modelos de dominio

### `fund_model.dart`
```dart
class FundModel {
  final String id;
  final String name;
  final double minAmount;     // monto mínimo de suscripción
  final String category;      // 'FPV' | 'FIC'
  final bool isSubscribed;    // si el usuario tiene posición activa
  final double? subscribedAmount; // monto suscrito (null si no está suscrito)
}
```

### `transaction_model.dart`
```dart
enum TransactionType { subscription, cancellation }
enum NotificationMethod { email, sms }

class TransactionModel {
  final String id;
  final String fundId;
  final String fundName;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final NotificationMethod? notificationMethod; // solo en suscripciones
}
```

---

## Paso 2 — Repositorio (interfaz + mock)

### `funds_repository.dart` (interfaz)
```dart
abstract class FundsRepository {
  Future<List<FundModel>> getFunds();
  Future<void> subscribeFund({
    required String fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  });
  Future<void> cancelFund(String fundId);
  Future<List<TransactionModel>> getTransactions();
  Future<double> getUserBalance();
}
```

### `mock_funds_repository_impl.dart`
- Estado en memoria (listas y balance como variables de instancia)
- `subscribeFund`: descuenta del balance, marca fondo como suscrito, agrega transacción
- `cancelFund`: devuelve el monto al balance, desmarca fondo, agrega transacción de cancelación
- Errores lanzados si:
  - Saldo insuficiente para el monto mínimo
  - El usuario ya está suscrito a ese fondo
  - El usuario no está suscrito (al intentar cancelar)
- Delay simulado: `await Future.delayed(Duration(milliseconds: 500))`

---

## Paso 3 — State management (Cubit)

### `FundsCubit` con `FundsState`

**Estado:**
```dart
class FundsState {
  final double balance;
  final List<FundModel> funds;
  final List<TransactionModel> transactions;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
}
```

**Métodos del Cubit:**
- `loadData()` — carga fondos, balance e historial
- `subscribe(fundId, amount, notificationMethod)` — suscribirse a un fondo
- `cancel(fundId)` — cancelar participación
- `clearMessages()` — limpiar mensajes de éxito/error

**Reglas de negocio en el Cubit:**
- Verificar que `balance >= fund.minAmount` antes de llamar al repositorio
- Si el saldo es insuficiente → emitir `errorMessage` sin llamar al repositorio
- Si la operación es exitosa → recargar datos y emitir `successMessage`

---

## Paso 4 — Pantalla principal (`funds_screen.dart`)

Estructura en dos pestañas (TabBar o navegación interna):

### Tab 1: "Fondos disponibles"
- `FundsBalanceCard` — muestra el saldo actual del usuario formateado en COP
- `FundsListView` — lista de `FundCard`

### Tab 2: "Historial"
- `TransactionsHistoryView` — lista cronológica de transacciones

**Flujo de suscripción:**
1. Usuario toca "Suscribirse" en un `FundCard`
2. Se abre `SubscribeDialog` (usa `showCustomDialog` existente) con:
   - Nombre del fondo y monto mínimo
   - Selector de método de notificación (email / SMS) — RadioButton
   - Campo de monto (prellenado con el mínimo, editable)
   - Botón "Confirmar"
3. `FundsCubit.subscribe(...)` es invocado
4. Si hay error → `SnackBar` con mensaje de error
5. Si es exitoso → `SnackBar` de confirmación, diálogo cierra

**Flujo de cancelación:**
1. Usuario toca "Cancelar" en un `FundCard` (solo visible si está suscrito)
2. Se abre `CancelDialog` con confirmación y monto a recuperar
3. `FundsCubit.cancel(...)` es invocado
4. Saldo se actualiza en pantalla

---

## Paso 5 — Widgets

### `FundsBalanceCard`
- Muestra: "Saldo disponible: $500.000"
- Formateado con `NumberFormat.currency(locale: 'es_CO', symbol: 'COP \$')`
- Se actualiza reactivamente con el Cubit

### `FundCard`
- Nombre del fondo
- Badge de categoría: FPV (azul) / FIC (verde)
- Monto mínimo formateado
- Estado: "Suscrito" (con chip verde) o botón "Suscribirse"
- Si suscrito: botón "Cancelar participación"

### `SubscribeDialog`
- Usa `showCustomDialog` del proyecto
- `CustomModalHeader` como header
- RadioListTile para email/SMS
- Muestra monto mínimo requerido
- Valida que el usuario tenga saldo suficiente antes de habilitar el botón

### `TransactionsHistoryView`
- `ListView` de items cronológicos (más reciente primero)
- Cada item muestra: ícono, nombre del fondo, tipo, monto, fecha
- Estado vacío si no hay transacciones

---

## Paso 6 — Navegación y rutas

### Archivos a modificar:

**`app_routes_private_.dart`** — agregar:
```dart
static const String fundsName = 'funds';
static const String fundsPath = '/funds';
```
Y agregar `fundsPath` a `privatePaths`.

**`private_routes.dart`** — agregar GoRoute dentro del ShellRoute:
```dart
GoRoute(
  name: AppRoutesPrivate.fundsName,
  path: AppRoutesPrivate.fundsPath,
  pageBuilder: (context, state) =>
      const NoTransitionPage(child: FundsScreen()),
),
```

**`app_title_helper.dart`** — agregar caso:
```dart
if (location.startsWith(AppRoutesPrivate.fundsPath)) return 'Fondos BTG';
```

**`dashboard_drawer.dart`** — agregar `DrawerListTile`:
```dart
DrawerListTile(
  title: 'Fondos',
  iconData: Icons.account_balance_outlined,
  isSelected: location == AppRoutesPrivate.fundsPath,
  press: () => _navigateTo(context, AppRoutesPrivate.fundsPath),
),
```

**`tablet_home_shell.dart`** — agregar destino al `_destinations`:
```dart
(
  path: AppRoutesPrivate.fundsPath,
  label: 'Fondos',
  icon: Icons.account_balance_outlined,
  selectedIcon: Icons.account_balance,
),
```

---

## Paso 7 — Extras valorados

### Navegación y ruteo
- Ya cubierto con GoRouter (Navigator 2.0) en Paso 6

### Widgets reutilizables
- `FundCard`, `FundsBalanceCard`, `TransactionItem` — reutilizables en cualquier contexto
- Usar `CustomButtonV2`, `CustomDialog`, `CustomModalHeader` ya existentes

### Pruebas unitarias
Archivo: `test/features/funds/funds_cubit_test.dart`

Casos a cubrir:
- `loadData()` → estado inicial con saldo $500.000 y 5 fondos
- `subscribe()` con saldo suficiente → saldo disminuye, fondo marcado como suscrito
- `subscribe()` con saldo insuficiente → `errorMessage` no nulo, saldo sin cambios
- `subscribe()` a fondo ya suscrito → error
- `cancel()` con fondo suscrito → saldo aumenta, fondo desmarcado
- `cancel()` con fondo no suscrito → error

---

## Orden de implementación

- [ ] 1. Crear `FundModel` y `TransactionModel`
- [ ] 2. Crear interfaz `FundsRepository`
- [ ] 3. Crear `MockFundsRepositoryImpl` con datos hardcodeados
- [ ] 4. Crear `FundsState` y `FundsCubit`
- [ ] 5. Crear widgets: `FundsBalanceCard`, `FundCard`, `SubscribeDialog`, `CancelDialog`, `TransactionsHistoryView`
- [ ] 6. Crear `FundsScreen` con tabs
- [ ] 7. Conectar rutas, drawer y navigation rail
- [ ] 8. Pruebas unitarias del Cubit

---

## Notas de implementación

- **Sin backend:** todo el estado vive en `MockFundsRepositoryImpl` (en memoria durante la sesión)
- **Persistencia:** no se requiere (al recargar la app el saldo vuelve a $500.000)
- **Formato de moneda:** usar `intl` package con `NumberFormat` para COP
- **`ModuleAccessGuard`:** NO usar (es para módulos dinámicos del servidor, no aplica aquí)
- **Patrón a seguir:** `roles_management` como referencia de estructura, pero simplificado con Cubit en lugar de DataBloc genérico (operaciones síncronas en memoria no necesitan el DataBloc con paginación)
