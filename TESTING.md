# Testing — BTG Pactual Gestión de Fondos

Documentación de la estrategia de pruebas, cobertura actual y pruebas pendientes para el módulo de fondos BTG.

---

## Comandos

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar solo los tests del módulo de fondos
flutter test test/features/funds/

# Generar archivo de cobertura (lcov)
flutter test --coverage

# Generar reporte HTML de cobertura (requiere lcov instalado)
genhtml coverage/lcov.info --output-directory coverage/html
open coverage/html/index.html
```

Con FVM:

```bash
fvm flutter test --coverage
```

---

## Cobertura actual

Resultado del último `flutter test --coverage` sobre los tests implementados:

| Archivo | Líneas cubiertas | Total | Cobertura |
|---|---|---|---|
| `presentation/state/funds_cubit.dart` | 43 | 43 | **100 %** |
| `presentation/state/funds_state.dart` | 21 | 21 | **100 %** |
| `domain/models/fund_model.dart` | 8 | 10 | 80 % |
| `domain/models/transaction_model.dart` | 1 | 2 | 50 % |
| **Total** | **73** | **76** | **96.1 %** |

### Líneas no cubiertas

| Archivo | Línea | Motivo |
|---|---|---|
| `fund_model.dart` | 31–32 | Rama `copyWith` cuando `subscribedAmount` se pasa como `null` explícito (patrón sentinel) |
| `transaction_model.dart` | 6 | Getter `NotificationMethodX.label` para el valor `sms` |

---

## Tests implementados

### `FundsCubit` — `test/features/funds/funds_cubit_test.dart`

Herramientas: `bloc_test`, `mocktail`.  
El repositorio se mockea con `MockFundsRepository extends Mock implements FundsRepository`.

#### `loadData`

| # | Nombre del test | Verifica |
|---|---|---|
| 1 | emite `[isLoading:true]` luego saldo $500.000 y 5 fondos sin suscribir | Estado inicial correcto tras carga exitosa |
| 2 | cuando el repositorio lanza excepción emite `errorMessage` | Manejo de error en carga inicial |

#### `subscribe`

| # | Nombre del test | Verifica |
|---|---|---|
| 3 | con saldo suficiente: descuenta saldo, fondo suscrito, `successMessage` no nulo | Flujo exitoso completo |
| 4 | saldo insuficiente: emite `errorMessage` y no modifica el saldo | Protección de saldo |
| 5 | fondo ya suscrito: emite `errorMessage` "Ya está suscrito" | Evitar suscripciones duplicadas |
| 6 | monto menor al mínimo: emite `errorMessage` del repositorio | Validación de monto mínimo |

#### `cancel`

| # | Nombre del test | Verifica |
|---|---|---|
| 7 | fondo suscrito: reintegra el monto y desmarca el fondo | Reintegro de saldo correcto |
| 8 | fondo no suscrito: emite `errorMessage` "No está suscrito" | Protección contra cancelación inválida |

#### `clearMessages`

| # | Nombre del test | Verifica |
|---|---|---|
| 9 | limpia `errorMessage` y `successMessage` del estado | Limpieza de mensajes de UI |

---

## Tests pendientes

### 1. `MockFundsRepositoryImpl` — reglas de negocio

> **Prioridad: alta.** Las validaciones de negocio viven aquí. Testearlas directamente
> garantiza que la lógica es correcta independientemente del cubit.

Ubicación propuesta: `test/features/funds/mock_funds_repository_impl_test.dart`

| Caso | Método | Qué valida |
|---|---|---|
| Suscripción exitosa descuenta saldo | `subscribeFund` | `_balance -= amount` |
| Saldo disponible < mínimo del fondo | `subscribeFund` | Lanza excepción con mensaje de saldo |
| Monto ingresado < mínimo del fondo | `subscribeFund` | Lanza excepción con mensaje de mínimo |
| Monto ingresado > saldo disponible | `subscribeFund` | Lanza "Saldo insuficiente para el monto" |
| Suscripción duplicada al mismo fondo | `subscribeFund` | Lanza "Ya está suscrito a este fondo" |
| Fondo inexistente | `subscribeFund` / `cancelFund` | Lanza "Fondo no encontrado" |
| Cancelación exitosa reintegra saldo | `cancelFund` | `_balance += subscribedAmount` |
| Cancelar fondo no suscrito | `cancelFund` | Lanza "No está suscrito a este fondo" |
| Transacciones se registran en orden | `getTransactions` | La lista devuelve las transacciones en orden inverso |
| Estado inicial | `getUserBalance` / `getFunds` | Saldo $500.000, 5 fondos, ninguno suscrito |

### 2. `FundModel` y `FundsState` — modelos

> **Prioridad: media.** Validan el patrón sentinel en `copyWith` y la igualdad
> por valor de `FundsState` (Equatable).

Ubicación propuesta: `test/features/funds/models/`

#### `FundModel`

| Caso | Qué valida |
|---|---|
| `copyWith` sin argumentos devuelve mismos valores | Inmutabilidad |
| `copyWith(subscribedAmount: null)` limpia el campo | Patrón sentinel — rama no cubierta actualmente |
| `copyWith(isSubscribed: true, subscribedAmount: 50000)` actualiza ambos campos | Suscripción |

#### `FundsState`

| Caso | Qué valida |
|---|---|
| Dos instancias con mismos valores son iguales (`==`) | `Equatable.props` |
| `copyWith(errorMessage: null)` limpia el campo | Patrón sentinel |
| `copyWith(successMessage: null)` limpia el campo | Patrón sentinel |
| `copyWith()` sin argumentos no muta ningún campo | Inmutabilidad |

#### `NotificationMethod`

| Caso | Qué valida |
|---|---|
| `NotificationMethod.email.label` devuelve `'Email'` | Getter `label` |
| `NotificationMethod.sms.label` devuelve `'SMS'` | Getter `label` — línea no cubierta actualmente |

### 3. Widget tests — componentes de UI

> **Prioridad: media-baja.** Complementan los tests de lógica verificando
> que la UI reacciona correctamente al estado del cubit.

Ubicación propuesta: `test/features/funds/widgets/`

#### `FundCard`

| Caso | Qué valida |
|---|---|
| Fondo no suscrito muestra botón "Suscribirse" | Render condicional |
| Fondo suscrito muestra botón "Cancelar" y chip "Suscrito" | Render condicional |
| Botón "Suscribirse" llama `onSubscribe` | Callback correcto |
| Botón "Cancelar" llama `onCancel` | Callback correcto |
| Layout mobile (< 800 px) usa columna vertical | Diseño responsivo |
| Layout desktop (≥ 800 px) usa fila horizontal | Diseño responsivo |

#### `FundsBalanceCard`

| Caso | Qué valida |
|---|---|
| Muestra el saldo formateado como `COP $ 500.000` | Formato COP |
| Actualiza cuando el saldo cambia | Reactividad |

#### `SubscribeDialog`

| Caso | Qué valida |
|---|---|
| Monto inicial igual al mínimo del fondo | Valor por defecto |
| Monto < mínimo bloquea el submit y muestra error de validación | Validación del formulario |
| `errorMessage` en estado muestra `_ErrorBanner` inline | Error inline |
| Botón "Confirmar suscripción" llama a `cubit.subscribe()` con los valores del form | Submit correcto |

#### `CancelDialog`

| Caso | Qué valida |
|---|---|
| Muestra el monto a reintegrar formateado | Información de confirmación |
| `errorMessage` en estado muestra el banner de error | Error inline |
| Botón "Confirmar" llama a `cubit.cancel(fundId)` | Acción correcta |
| Botón "No cancelar" cierra el diálogo sin llamar al cubit | Cancelación sin efecto |

#### `FundsScreen`

| Caso | Qué valida |
|---|---|
| Renderiza tab "Fondos disponibles" por defecto | Estado inicial de tabs |
| Tap en "Historial" muestra `TransactionsHistoryView` | Navegación entre tabs |
| Lista vacía de transacciones muestra mensaje apropiado | Estado vacío |

---

## Estructura de archivos de test

```
test/
└── features/
    └── funds/
        ├── funds_cubit_test.dart           ✅ implementado
        ├── mock_funds_repository_impl_test.dart   ⬜ pendiente
        ├── models/
        │   ├── fund_model_test.dart        ⬜ pendiente
        │   ├── funds_state_test.dart       ⬜ pendiente
        │   └── transaction_model_test.dart ⬜ pendiente
        └── widgets/
            ├── fund_card_test.dart         ⬜ pendiente
            ├── funds_balance_card_test.dart ⬜ pendiente
            ├── subscribe_dialog_test.dart  ⬜ pendiente
            ├── cancel_dialog_test.dart     ⬜ pendiente
            └── funds_screen_test.dart      ⬜ pendiente
```

---

## Dependencias de test

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7   # helpers para testear Cubits/Blocs
  mocktail: ^1.0.4    # mocks sin generación de código
```
