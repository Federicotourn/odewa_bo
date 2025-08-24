# 🚀 Odewa Backoffice

**Sistema de gestión empresarial moderno y eficiente**

[![Flutter](https://img.shields.io/badge/Flutter-3.16.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.2.0-blue.svg)](https://dart.dev/)
[![GetX](https://img.shields.io/badge/GetX-4.6.5-green.svg)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 📋 Descripción

Odewa Backoffice es una aplicación web moderna desarrollada en Flutter que proporciona una interfaz completa para la gestión de usuarios, empresas, clientes y solicitudes. Diseñada con un enfoque en la experiencia del usuario y la eficiencia operativa.

## ✨ Características Principales

### 🔐 **Autenticación y Seguridad**
- Sistema de login robusto con JWT
- Gestión de permisos granular
- Middleware de autenticación
- Control de sesiones seguro

### 👥 **Gestión de Usuarios**
- CRUD completo de usuarios
- Roles y permisos personalizables
- Estados activo/inactivo
- Búsqueda y filtrado avanzado

### 🏢 **Gestión de Empresas**
- Registro de empresas con datos completos
- Fechas de facturación
- Conteo de empleados
- Estados de actividad

### 👤 **Gestión de Clientes**
- Información personal completa
- Datos bancarios y financieros
- Historial de transacciones
- Estados de cuenta

### 📋 **Gestión de Solicitudes**
- Flujo de estados inteligente (Pendiente → Aprobado → Completado)
- Estados alternativos (Rechazado)
- Validación de transiciones
- Vista detallada completa

## 🛠️ Tecnologías Utilizadas

- **Frontend**: Flutter Web
- **Estado**: GetX (State Management)
- **Navegación**: GetX Routing
- **HTTP**: Dio/HTTP Package
- **Almacenamiento**: GetStorage
- **UI**: Material Design 3
- **Responsive**: Mobile-first approach

## 🚀 Instalación y Configuración

### **Prerrequisitos**
- Flutter SDK 3.16.0 o superior
- Dart 3.2.0 o superior
- Node.js 18+ (para el backend)

### **1. Clonar el repositorio**
```bash
git clone https://github.com/Federicotourn/odewa_bo.git
cd odewa_bo
```

### **2. Instalar dependencias**
```bash
flutter pub get
```

### **3. Configurar variables de entorno**
```bash
# Editar lib/constants/urls.dart
# Cambiar la URL base según tu entorno
static String baseUrl = 'http://localhost:3000/api';
```

### **4. Ejecutar la aplicación**
```bash
flutter run -d chrome
```

## 📱 Módulos Disponibles

### **Dashboard**
- Vista general del sistema
- Métricas y estadísticas
- Acceso rápido a funciones principales

### **Usuarios**
- Gestión completa de usuarios del sistema
- Asignación de roles y permisos
- Estados de actividad

### **Empresas**
- Registro y gestión de empresas
- Información corporativa
- Estados de facturación

### **Clientes**
- Base de datos de clientes
- Información personal y financiera
- Historial de transacciones

### **Solicitudes**
- Sistema de solicitudes con flujo de estados
- Aprobación y rechazo
- Seguimiento completo del proceso

## 🔧 Configuración del Backend

### **Endpoints Principales**
- `POST /api/auth/login` - Autenticación
- `GET /api/backoffice/users` - Gestión de usuarios
- `GET /api/backoffice/clients` - Gestión de clientes
- `GET /api/backoffice/requests` - Gestión de solicitudes
- `GET /api/companies` - Gestión de empresas

### **Autenticación**
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@odewa.com", "password": "password"}'
```

## 🎨 Características de UI/UX

### **Diseño Moderno**
- Material Design 3
- Gradientes y sombras sutiles
- Paleta de colores consistente
- Iconografía moderna

### **Responsive Design**
- Adaptable a todos los dispositivos
- Mobile-first approach
- Breakpoints optimizados
- Navegación intuitiva

### **Componentes Reutilizables**
- Botones modernos con efectos
- Cards informativos
- Modales elegantes
- Formularios validados

## 📊 Estructura del Proyecto

```
lib/
├── constants/          # Constantes y URLs
├── controllers/        # Controladores GetX
├── models/            # Modelos de datos
├── pages/             # Vistas de la aplicación
│   ├── authentication/ # Autenticación
│   ├── companies/     # Gestión de empresas
│   ├── clients/       # Gestión de clientes
│   ├── overview/      # Dashboard
│   ├── requests/      # Gestión de solicitudes
│   └── users/         # Gestión de usuarios
├── routing/           # Configuración de rutas
├── services/          # Servicios de API
├── widgets/           # Widgets reutilizables
└── main.dart          # Punto de entrada
```

## 🔐 Permisos del Sistema

### **Niveles de Acceso**
- **SUPER_ADMIN**: Acceso completo al sistema
- **ADMIN**: Gestión de usuarios y contenido
- **USER**: Acceso básico a funcionalidades
- **CLIENT**: Acceso limitado a información personal

### **Permisos Específicos**
- `USER_CREATE`, `USER_READ`, `USER_UPDATE`, `USER_DELETE`
- `COMPANY_CREATE`, `COMPANY_READ`, `COMPANY_UPDATE`, `COMPANY_DELETE`
- `CLIENT_CREATE`, `CLIENT_READ`, `CLIENT_UPDATE`, `CLIENT_DELETE`
- `REQUEST_CREATE`, `REQUEST_READ`, `REQUEST_UPDATE`, `REQUEST_DELETE`

## 🚀 Despliegue

### **Desarrollo Local**
```bash
flutter run -d chrome --web-port 8080
```

### **Producción**
```bash
flutter build web
# Servir la carpeta build/web
```

### **Docker (Opcional)**
```dockerfile
FROM nginx:alpine
COPY build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 Autor

**Federico Tourn**
- GitHub: [@Federicotourn](https://github.com/Federicotourn)
- Email: fedetourn2001@gmail.com

## 🙏 Agradecimientos

- Flutter Team por el framework increíble
- GetX por la gestión de estado eficiente
- Material Design por la guía de diseño
- Comunidad Flutter por el apoyo continuo

## 📞 Soporte

Si tienes alguna pregunta o necesitas ayuda:

- 📧 Email: fedetourn2001@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/Federicotourn/odewa_bo/issues)
- 📖 Wiki: [Documentación](https://github.com/Federicotourn/odewa_bo/wiki)

---

⭐ **¡No olvides darle una estrella al proyecto si te gusta!** ⭐
