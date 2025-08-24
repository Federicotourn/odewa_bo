# Módulo de Empresas - Odewa Backoffice

## Estructura de la Empresa

El modelo de empresa coincide con la API de Odewa:

### Crear Empresa

```json
{
  "name": "Empresa Test S.A.",
  "billingDate": "2024-01-15",
  "employeeCount": 50
}
```

### Respuesta del API

```json
{
  "data": [
    {
      "id": "9132ec0a-c161-4d5c-9c2c-6ed790fcca52",
      "createdAt": "2025-08-23T23:51:46.007Z",
      "updatedAt": "2025-08-23T23:51:46.007Z",
      "deletedAt": null,
      "createdById": null,
      "updatedById": null,
      "deletedById": null,
      "isActive": true,
      "name": "Empresa Test S.A.",
      "billingDate": "2024-01-15",
      "employeeCount": 50
    }
  ],
  "meta": {
    "page": "1",
    "limit": "10",
    "total": 1,
    "totalPages": 1
  }
}
```

## Campos de la Empresa

- **id**: Identificador único de la empresa
- **name**: Nombre de la empresa
- **billingDate**: Fecha de facturación (formato YYYY-MM-DD)
- **employeeCount**: Número de empleados
- **isActive**: Estado activo/inactivo de la empresa
- **createdAt**: Fecha de creación
- **updatedAt**: Fecha de última actualización

## Funcionalidades

### 1. Crear Empresa

- Formulario con campos: nombre, fecha de facturación y número de empleados
- Validación de campos obligatorios
- Envío a la API con el formato correcto

### 2. Editar Empresa

- Modificación de nombre, fecha de facturación y número de empleados
- Validación de campos obligatorios

### 3. Eliminar Empresa

- Confirmación antes de eliminar
- Eliminación lógica (soft delete)

### 4. Activar/Desactivar Empresa

- Cambio de estado activo/inactivo
- Botón toggle que cambia según el estado actual

### 5. Lista de Empresas

- Vista paginada de empresas
- Filtros por estado (activa/inactiva)
- Búsqueda por nombre
- Controles de paginación

## Permisos Requeridos

- **COMPANY_CREATE**: Crear nuevas empresas
- **COMPANY_READ**: Ver lista de empresas
- **COMPANY_UPDATE**: Editar empresas y cambiar estado
- **COMPANY_DELETE**: Eliminar empresas

## Uso de la API

### Endpoint Base

```
GET /companies
POST /companies
PATCH /companies/{id}
POST /companies/{id}/activate
POST /companies/{id}/deactivate
```

### Crear Empresa

```dart
final request = CreateCompanyRequest(
  name: 'Empresa Test S.A.',
  billingDate: '2024-01-15',
  employeeCount: 50,
);
final (success, company, message) = await companyService.createCompany(request);
```

### Actualizar Empresa

```dart
final request = UpdateCompanyRequest(
  name: 'Nuevo Nombre',
  billingDate: '2024-02-15',
  employeeCount: 75,
);
final (success, company, message) = await companyService.updateCompany(id, request);
```

### Cambiar Estado

```dart
// Activar empresa
final (success, message) = await companyService.activateCompany(id);

// Desactivar empresa
final (success, message) = await companyService.deactivateCompany(id);
```

## Características de la UI

- **Diseño Moderno**: Cards con gradientes y sombras
- **Responsivo**: Adaptable a diferentes tamaños de pantalla
- **Colores Temáticos**: Paleta de colores indigo/púrpura
- **Iconografía**: Iconos descriptivos para cada acción
- **Validación en Tiempo Real**: Mensajes de error claros
- **Paginación**: Navegación entre páginas de resultados
- **Filtros**: Búsqueda y filtrado por estado

## Componentes Reutilizables

- `_ModernActionButton`: Botones de acción principales
- `_InfoCard`: Tarjetas de información
- `_CompactActionButton`: Botones de acción compactos
- `_ModernTextField`: Campos de texto modernos
- `_ModernOutlinedButton`: Botones con borde
- `_ModernElevatedButton`: Botones elevados
