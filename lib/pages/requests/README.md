# Módulo de Solicitudes (Requests) - Odewa Backoffice

## Estructura de la Solicitud

El modelo de solicitud coincide con la API de Odewa:

### Respuesta del API

```json
{
  "data": [
    {
      "id": "f3a940e7-6dbd-4eb1-87e0-a0c1a5ca092d",
      "createdAt": "2025-08-23T22:33:47.378Z",
      "updatedAt": "2025-08-23T22:33:47.378Z",
      "deletedAt": null,
      "createdById": null,
      "updatedById": null,
      "deletedById": null,
      "isActive": true,
      "amount": "500.00",
      "date": "2025-08-23",
      "status": "pending",
      "clientId": "135ef900-e221-4266-92b8-390264df426d",
      "client": {
        "id": "135ef900-e221-4266-92b8-390264df426d",
        "firstName": "Federico",
        "lastName": "Tourn",
        "email": "fedetourn2001@gmail.com",
        "document": "52577647",
        "phone": "",
        "address": "",
        "city": "",
        "bank": "Itauu",
        "currency": "Pesos",
        "accountNumber": "2950760",
        "branch": "4",
        "beneficiary": "Federico Tourn",
        "monthlyBalance": 100000
      }
    }
  ],
  "meta": {
    "page": "1",
    "limit": "10",
    "total": 5,
    "totalPages": 1
  }
}
```

## Campos de la Solicitud

- **id**: Identificador único de la solicitud
- **amount**: Monto de la solicitud (string)
- **date**: Fecha de la solicitud (formato YYYY-MM-DD)
- **status**: Estado de la solicitud (pending, approved, rejected, completed)
- **clientId**: ID del cliente asociado
- **client**: Objeto con información completa del cliente
- **isActive**: Estado activo/inactivo de la solicitud
- **createdAt**: Fecha de creación
- **updatedAt**: Fecha de última actualización

## Estados de Solicitud

### Flujo de Estados

```
pending → approved → completed
     ↓
  rejected
```

- **pending**: Pendiente (naranja) - Estado inicial
- **approved**: Aprobada (verde) - Solo desde pending
- **rejected**: Rechazada (rojo) - Solo desde pending
- **completed**: Completada (teal) - Solo desde approved

### Reglas de Transición

- **pending** → **approved** o **rejected**
- **approved** → **completed**
- **rejected** → No puede cambiar (estado final)
- **completed** → No puede cambiar (estado final)

## Funcionalidades

### 1. Vista Principal (RequestsView)

- **Lista Paginada**: Vista de todas las solicitudes con paginación
- **Filtros Avanzados**: Búsqueda por texto y filtro por estado
- **Acciones Rápidas**: Ver detalle, editar, cambiar estado, activar/desactivar
- **Información Resumida**: Monto, fecha, estado y cliente

### 2. Vista Detallada (RequestDetailView)

- **Información Completa**: Todos los datos de la solicitud
- **Datos del Cliente**: Información completa del cliente asociado
- **Cambio de Estado**: Interfaz para cambiar el estado según las reglas
- **Flujo Visual**: Diagrama del flujo de estados disponible

### 3. Crear Solicitud

- Formulario con campos: monto, fecha e ID del cliente
- Validación de campos obligatorios
- Validación de monto como número válido

### 4. Editar Solicitud

- Modificación de monto y fecha
- No se puede cambiar el cliente asociado

### 5. Cambiar Estado

- **Validación de Transiciones**: Solo permite cambios válidos según el flujo
- **Botones Dinámicos**: Muestra solo los estados disponibles
- **Confirmación Visual**: Indica claramente qué cambios son posibles

### 6. Activar/Desactivar Solicitud

- Toggle de estado activo/inactivo
- Botón dinámico según el estado actual

## Permisos Requeridos

- **REQUEST_CREATE**: Crear nuevas solicitudes
- **REQUEST_READ**: Ver lista de solicitudes y detalles
- **REQUEST_UPDATE**: Editar solicitudes y cambiar estado
- **REQUEST_DELETE**: Eliminar solicitudes

## Uso de la API

### Endpoint Base

```
GET /backoffice/requests
POST /backoffice/requests
PATCH /backoffice/requests/{id}
PATCH /backoffice/requests/{id}/status
POST /backoffice/requests/{id}/activate
POST /backoffice/requests/{id}/deactivate
```

### Cambiar Estado

```bash
curl --location --request PATCH 'http://localhost:3000/api/backoffice/requests/{id}/status' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data '{
  "status": "approved"
}'
```

### Crear Solicitud

```dart
final request = CreateRequestRequest(
  amount: '500.00',
  date: '2025-08-23',
  clientId: '135ef900-e221-4266-92b8-390264df426d',
);
final (success, newRequest, message) = await requestService.createRequest(request);
```

### Actualizar Solicitud

```dart
final request = UpdateRequestRequest(
  amount: '750.00',
  date: '2025-08-24',
);
final (success, updatedRequest, message) = await requestService.updateRequest(id, request);
```

### Cambiar Estado

```dart
final (success, updatedRequest, message) = await requestService.updateRequestStatus(id, 'approved');
```

## Navegación

### Desde la Vista Principal

- **Ver Detalle**: Botón "Ver Detalle" en cada card de solicitud
- **Editar**: Botón "Editar" para modificar la solicitud
- **Cambiar Estado**: Botón "Cambiar Estado" para modificar el estado

### En la Vista Detallada

- **Volver**: Botón de retorno en el AppBar
- **Actualizar**: Botón de refresh para recargar datos
- **Cambiar Estado**: Sección dedicada con botones de estado disponibles

## Características de la UI

### Vista Principal

- **Diseño Moderno**: Cards con gradientes y sombras
- **Colores Temáticos**: Paleta de colores teal/cyan
- **Iconografía**: Iconos descriptivos para cada acción
- **Filtros Integrados**: Búsqueda y filtrado en tiempo real

### Vista Detallada

- **Layout Responsivo**: Adaptable a diferentes tamaños de pantalla
- **Secciones Organizadas**: Información agrupada lógicamente
- **Flujo Visual**: Diagrama del flujo de estados
- **Botones de Estado**: Solo muestra opciones válidas

## Componentes Reutilizables

- `_ModernActionButton`: Botones de acción principales
- `_InfoCard`: Tarjetas de información
- `_CompactActionButton`: Botones de acción compactos
- `_ModernTextField`: Campos de texto modernos
- `_StatusChangeButton`: Botones para cambiar estado
- `_StatusFlowStep`: Pasos del flujo de estados

## Integración con Clientes

- **Relación 1:N**: Una solicitud pertenece a un cliente
- **Información Completa**: Muestra todos los datos del cliente
- **Búsqueda por Cliente**: Filtrado por nombre del cliente
- **Validación de Cliente**: Verificación de existencia del cliente

## Paginación y Rendimiento

- **Paginación Inteligente**: Navegación entre páginas
- **Límites Configurables**: 10, 25, 50, 100 registros por página
- **Carga Lazy**: Solo carga los datos necesarios
- **Filtrado Eficiente**: Aplicación de filtros en tiempo real

## Casos de Uso

### Flujo Típico de Aprobación

1. **Crear Solicitud**: Estado inicial "pending"
2. **Revisar Detalles**: Usar vista detallada para evaluación
3. **Aprobar o Rechazar**: Cambiar a "approved" o "rejected"
4. **Completar**: Si es aprobada, cambiar a "completed"

### Gestión de Estados

- **pending**: Solicitudes nuevas que requieren revisión
- **approved**: Solicitudes aprobadas en proceso
- **completed**: Solicitudes finalizadas exitosamente
- **rejected**: Solicitudes rechazadas (estado final)
