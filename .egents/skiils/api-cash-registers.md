# API Cajas Registradoras

Base URL: `/v1/admin/cash-registers`

Todas las rutas requieren **autenticación** (`Bearer token`) y usuario activo.

---

## Flujo principal

```
Crear caja  -->  Abrir caja  -->  (operar ventas)  -->  Iniciar cierre  -->  Confirmar cierre
   POST /         POST /:id/open                       POST /:id/init-close   POST /:id/close
```

### Estados de una apertura

| Estado    | Descripción                              |
|-----------|------------------------------------------|
| `open`    | Caja operativa, acepta ventas            |
| `closing` | En proceso de cierre, bloqueada          |
| `closed`  | Cerrada, ciclo completado                |

---

## 1. CRUD de Cajas Registradoras

### 1.1 Listar cajas

```
GET /v1/admin/cash-registers
```

**Query params:**

| Param        | Tipo   | Requerido | Descripción                    |
|--------------|--------|-----------|--------------------------------|
| `company_id` | UUID   | Si        | ID de la empresa               |
| `branch_id`  | UUID   | No        | Filtrar por sucursal           |
| `search`     | string | No        | Buscar por nombre              |
| `page`       | number | No        | Pagina (default: 1)            |
| `limit`      | number | No        | Items por pagina (default: 500, max: 1000) |

**Response 200:**

```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "company_id": "uuid",
      "branch_id": "uuid",
      "name": "Caja 1",
      "number": 1,
      "is_active": true,
      "created_at": "2026-03-15T14:30:00.000Z",
      "branch": {
        "id": "uuid",
        "name": "Sucursal Centro"
      }
    }
  ],
  "meta": {
    "total": 3,
    "page": 1,
    "totalPages": 1,
    "limit": 500
  }
}
```

---

### 1.2 Crear caja

```
POST /v1/admin/cash-registers?company_id={uuid}
```

**Body:**

```json
{
  "company_id": "uuid",
  "branch_id": "uuid",
  "name": "Caja 1"
}
```

> El campo `number` se asigna automaticamente (max + 1 dentro de la sucursal).

**Response 201:**

```json
{
  "success": true,
  "message": "Caja registradora creada correctamente",
  "data": {
    "id": "uuid",
    "company_id": "uuid",
    "branch_id": "uuid",
    "name": "Caja 1",
    "number": 1,
    "is_active": true,
    "created_at": "2026-03-15T14:30:00.000Z"
  }
}
```

**Errores:**

| Status | Cuando                                                    |
|--------|-----------------------------------------------------------|
| 400    | Faltan campos obligatorios                                |
| 400    | Se alcanzo el limite de cajas por sucursal (`max_cash_registers_per_branch`) |
| 403    | Sin acceso a la empresa                                   |
| 404    | Sucursal no encontrada o no pertenece a la empresa        |

---

### 1.3 Actualizar caja

```
PUT /v1/admin/cash-registers/:id?company_id={uuid}
```

**Body (todos opcionales):**

```json
{
  "name": "Caja Principal",
  "is_active": false
}
```

**Response 200:**

```json
{
  "success": true,
  "message": "Caja registradora actualizada correctamente",
  "data": { /* caja actualizada */ }
}
```

---

### 1.4 Eliminar caja (soft delete)

```
DELETE /v1/admin/cash-registers/:id?company_id={uuid}
```

**Response 200:**

```json
{
  "success": true,
  "message": "Caja registradora eliminada correctamente"
}
```

**Errores:**

| Status | Cuando                                            |
|--------|---------------------------------------------------|
| 400    | La caja tiene aperturas abiertas                  |
| 404    | Caja no encontrada                                |

---

## 2. Apertura de Caja

### 2.1 Abrir caja

```
POST /v1/admin/cash-registers/:id/open?company_id={uuid}
```

**Body:**

```json
{
  "initial_amount": 100000,
  "expected_amount": 100000,
  "actual_amount": 98000,
  "notes": "Faltaron $2.000 del turno anterior",
  "denominations": [
    {
      "denomination_value": 50000,
      "denomination_label": "Billete $50.000",
      "quantity": 1
    },
    {
      "denomination_value": 20000,
      "denomination_label": "Billete $20.000",
      "quantity": 2
    },
    {
      "denomination_value": 5000,
      "denomination_label": "Billete $5.000",
      "quantity": 1
    },
    {
      "denomination_value": 1000,
      "denomination_label": "Moneda $1.000",
      "quantity": 3
    }
  ]
}
```

| Campo             | Tipo     | Requerido | Descripcion                             |
|-------------------|----------|-----------|-----------------------------------------|
| `initial_amount`  | number   | Si        | Fondo de caja                           |
| `expected_amount` | number   | No        | Monto esperado (arqueo)                 |
| `actual_amount`   | number   | No        | Monto real contado                      |
| `notes`           | string   | No        | Notas de apertura                       |
| `denominations`   | array    | No        | Desglose por billetes/monedas           |

> La `difference_amount` se calcula automaticamente: `actual_amount - expected_amount`

**Response 201:**

```json
{
  "success": true,
  "message": "Caja abierta correctamente",
  "data": {
    "id": "uuid",
    "cash_register_id": "uuid",
    "company_id": "uuid",
    "branch_id": "uuid",
    "user_id": "uuid",
    "opening_date": "2026-03-15",
    "opening_time": "08:00:00",
    "initial_amount": 100000,
    "expected_amount": 100000,
    "actual_amount": 98000,
    "difference_amount": -2000,
    "notes": "Faltaron $2.000 del turno anterior",
    "status": "open",
    "created_at": "2026-03-15T08:00:00.000Z",
    "denominations": [
      {
        "id": "uuid",
        "opening_id": "uuid",
        "denomination_value": 50000,
        "denomination_label": "Billete $50.000",
        "quantity": 1,
        "subtotal": 50000
      }
    ]
  }
}
```

**Errores:**

| Status | Cuando                                                       |
|--------|--------------------------------------------------------------|
| 400    | La caja ya tiene una apertura activa o en cierre             |
| 400    | Limite de cajas abiertas simultaneamente por sucursal        |
| 404    | Caja no encontrada o inactiva                                |

---

### 2.2 Historial de aperturas

```
GET /v1/admin/cash-registers/:id/openings?company_id={uuid}
```

**Query params:**

| Param        | Tipo   | Requerido | Descripcion              |
|--------------|--------|-----------|--------------------------|
| `company_id` | UUID   | Si        | ID de la empresa         |
| `start_date` | date   | No        | Filtro desde (YYYY-MM-DD)|
| `end_date`   | date   | No        | Filtro hasta (YYYY-MM-DD)|
| `status`     | string | No        | Filtrar: `open`, `closing`, `closed` |
| `page`       | number | No        | Pagina                   |
| `limit`      | number | No        | Items por pagina (max: 100) |

**Response 200:**

```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "cash_register_id": "uuid",
      "company_id": "uuid",
      "branch_id": "uuid",
      "user_id": "uuid",
      "opening_date": "2026-03-15",
      "opening_time": "08:00:00",
      "initial_amount": 100000,
      "expected_amount": 100000,
      "actual_amount": 98000,
      "difference_amount": -2000,
      "notes": null,
      "status": "closed",
      "created_at": "2026-03-15T08:00:00.000Z",
      "denominations": [],
      "user": {
        "id": "uuid",
        "email": "cajero@empresa.com"
      }
    }
  ],
  "meta": {
    "total": 15,
    "page": 1,
    "totalPages": 1,
    "limit": 20
  }
}
```

---

### 2.3 Detalle de una apertura

```
GET /v1/admin/cash-registers/openings/:openingId
```

**Response 200:**

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "cash_register_id": "uuid",
    "company_id": "uuid",
    "branch_id": "uuid",
    "user_id": "uuid",
    "opening_date": "2026-03-15",
    "opening_time": "08:00:00",
    "initial_amount": 100000,
    "expected_amount": 100000,
    "actual_amount": 98000,
    "difference_amount": -2000,
    "notes": null,
    "status": "closed",
    "denominations": [
      {
        "id": "uuid",
        "opening_id": "uuid",
        "denomination_value": 50000,
        "denomination_label": "Billete $50.000",
        "quantity": 1,
        "subtotal": 50000
      }
    ],
    "cashRegister": {
      "id": "uuid",
      "name": "Caja 1",
      "number": 1,
      "branch": {
        "id": "uuid",
        "name": "Sucursal Centro"
      }
    }
  }
}
```

---

## 3. Cierre de Caja (2 pasos)

### 3.1 Paso 1: Iniciar cierre

Marca la caja como "en cierre" (bloquea nuevas operaciones) y retorna un resumen del sistema con ventas por medio de pago.

```
POST /v1/admin/cash-registers/:id/init-close?company_id={uuid}
```

**Body:** ninguno

**Response 200:**

```json
{
  "success": true,
  "message": "Caja marcada en cierre. Proceda con el arqueo fisico.",
  "data": {
    "opening_id": "uuid",
    "cash_register_id": "uuid",
    "initial_amount": 100000,
    "opening_date": "2026-03-15",
    "opening_time": "08:00:00",
    "total_sales": 850000,
    "sales_by_payment_method": [
      {
        "payment_method_id": "uuid",
        "payment_method_name": "Efectivo",
        "total_amount": "650000.00",
        "count": "25"
      },
      {
        "payment_method_id": "uuid",
        "payment_method_name": "Tarjeta",
        "total_amount": "200000.00",
        "count": "10"
      }
    ],
    "status": "closing"
  }
}
```

**Errores:**

| Status | Cuando                                     |
|--------|--------------------------------------------|
| 404    | No hay apertura abierta para esta caja     |

---

### 3.2 Paso 2: Confirmar cierre

Registra el arqueo fisico, calcula diferencias y genera el comprobante de cierre.

```
POST /v1/admin/cash-registers/:id/close?company_id={uuid}
```

**Body:**

```json
{
  "actual_amount": 745000,
  "total_income": 0,
  "total_expenses": 15000,
  "next_shift_fund": 100000,
  "notes": "Se pago proveedor de pan $15.000",
  "denominations": [
    {
      "denomination_value": 100000,
      "denomination_label": "Billete $100.000",
      "quantity": 5
    },
    {
      "denomination_value": 50000,
      "denomination_label": "Billete $50.000",
      "quantity": 4
    },
    {
      "denomination_value": 20000,
      "denomination_label": "Billete $20.000",
      "quantity": 2
    },
    {
      "denomination_value": 5000,
      "denomination_label": "Billete $5.000",
      "quantity": 1
    }
  ]
}
```

| Campo              | Tipo   | Requerido | Descripcion                                |
|--------------------|--------|-----------|--------------------------------------------|
| `actual_amount`    | number | Si        | Efectivo real contado                      |
| `total_income`     | number | No        | Otros ingresos en efectivo del turno       |
| `total_expenses`   | number | No        | Egresos en efectivo del turno              |
| `next_shift_fund`  | number | No        | Fondo que queda para el siguiente turno    |
| `notes`            | string | No        | Notas del cierre                           |
| `denominations`    | array  | No        | Desglose de billetes/monedas               |

**Calculos automaticos del backend:**

```
theoretical_amount = initial_amount + ventas_efectivo + total_income - total_expenses
difference_amount  = actual_amount - theoretical_amount
amount_to_deposit  = actual_amount - next_shift_fund
difference_type    = "balanced" | "surplus" | "deficit"
```

**Response 201:**

```json
{
  "success": true,
  "message": "Caja cerrada correctamente",
  "data": {
    "id": "uuid",
    "opening_id": "uuid",
    "cash_register_id": "uuid",
    "company_id": "uuid",
    "branch_id": "uuid",
    "user_id": "uuid",
    "closing_date": "2026-03-15",
    "closing_time": "22:00:00",
    "initial_amount": 100000,
    "total_sales": 850000,
    "total_income": 0,
    "total_expenses": 15000,
    "theoretical_amount": 735000,
    "actual_amount": 745000,
    "difference_amount": 10000,
    "difference_type": "surplus",
    "next_shift_fund": 100000,
    "amount_to_deposit": 645000,
    "notes": "Se pago proveedor de pan $15.000",
    "created_at": "2026-03-15T22:00:00.000Z",
    "denominations": [
      {
        "id": "uuid",
        "closing_id": "uuid",
        "denomination_value": 100000,
        "denomination_label": "Billete $100.000",
        "quantity": 5,
        "subtotal": 500000
      }
    ]
  }
}
```

**Errores:**

| Status | Cuando                                                          |
|--------|-----------------------------------------------------------------|
| 404    | No hay caja en estado de cierre. Ejecutar `init-close` primero  |

---

### 3.3 Detalle de un cierre (comprobante)

```
GET /v1/admin/cash-registers/closings/:closingId
```

**Response 200:**

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "opening_id": "uuid",
    "cash_register_id": "uuid",
    "company_id": "uuid",
    "branch_id": "uuid",
    "user_id": "uuid",
    "closing_date": "2026-03-15",
    "closing_time": "22:00:00",
    "initial_amount": 100000,
    "total_sales": 850000,
    "total_income": 0,
    "total_expenses": 15000,
    "theoretical_amount": 735000,
    "actual_amount": 745000,
    "difference_amount": 10000,
    "difference_type": "surplus",
    "next_shift_fund": 100000,
    "amount_to_deposit": 645000,
    "notes": "Se pago proveedor de pan $15.000",
    "denominations": [
      {
        "id": "uuid",
        "closing_id": "uuid",
        "denomination_value": 100000,
        "denomination_label": "Billete $100.000",
        "quantity": 5,
        "subtotal": 500000
      }
    ],
    "opening": {
      "id": "uuid",
      "opening_date": "2026-03-15",
      "opening_time": "08:00:00",
      "initial_amount": 100000,
      "denominations": []
    },
    "cashRegister": {
      "id": "uuid",
      "name": "Caja 1",
      "number": 1,
      "branch": {
        "id": "uuid",
        "name": "Sucursal Centro"
      }
    },
    "user": {
      "id": "uuid",
      "email": "cajero@empresa.com"
    }
  }
}
```

---

## 4. Reporte Consolidado

Agrega datos de cierres en un rango de fechas para reportes semanales, quincenales o mensuales.

```
GET /v1/admin/cash-registers/report
```

**Query params:**

| Param              | Tipo | Requerido | Descripcion                    |
|--------------------|------|-----------|--------------------------------|
| `company_id`       | UUID | Si        | ID de la empresa               |
| `start_date`       | date | Si        | Fecha inicio (YYYY-MM-DD)      |
| `end_date`         | date | Si        | Fecha fin (YYYY-MM-DD)         |
| `branch_id`        | UUID | No        | Filtrar por sucursal           |
| `cash_register_id` | UUID | No        | Filtrar por caja especifica    |

**Response 200:**

```json
{
  "success": true,
  "data": {
    "period": {
      "start_date": "2026-03-01",
      "end_date": "2026-03-15",
      "company_id": "uuid",
      "branch_id": null,
      "cash_register_id": null
    },
    "summary": {
      "total_closings": 30,
      "total_sales": 25500000,
      "total_income": 150000,
      "total_expenses": 450000,
      "total_initial_amount": 3000000,
      "total_theoretical": 22050000,
      "total_actual": 22100000,
      "total_difference": 50000,
      "total_to_deposit": 19100000,
      "total_next_shift_fund": 3000000
    },
    "differences": {
      "balanced": 20,
      "surplus": 7,
      "deficit": 3
    },
    "by_cash_register": [
      {
        "cash_register_id": "uuid",
        "total_closings": "15",
        "sum_total_sales": "12750000.00",
        "sum_actual": "11050000.00",
        "sum_difference": "25000.00",
        "sum_to_deposit": "9550000.00",
        "cashRegister": {
          "name": "Caja 1",
          "number": 1,
          "branch": {
            "id": "uuid",
            "name": "Sucursal Centro"
          }
        }
      }
    ]
  }
}
```

---

## Errores comunes (todas las rutas)

| Status | Descripcion                        |
|--------|------------------------------------|
| 400    | Parametros faltantes o invalidos   |
| 403    | Sin acceso a la empresa            |
| 404    | Recurso no encontrado              |
| 500    | Error interno del servidor         |

Formato de error:

```json
{
  "success": false,
  "message": "Descripcion del error",
  "error": "Detalle tecnico (solo en 500)"
}
```
