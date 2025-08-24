# Configuración de Codemagic para Flutter Linux Deploy

## 🔧 **Variables de Entorno Requeridas**

### **Grupo:** `linux-deploy-group`

| Variable       | Valor                   | Descripción              |
| -------------- | ----------------------- | ------------------------ |
| `SSH_USER`     | `octadev`               | Usuario SSH del servidor |
| `SSH_PASSWORD` | `Kj2e4fbh`              | Contraseña SSH           |
| `SERVER_IP`    | `10.200.29.141`         | IP del servidor          |
| `SERVER_PATH`  | `/home/octadev/web-app` | Ruta de despliegue       |

## 📋 **Pasos para Configurar en Codemagic:**

1. **Ve a tu proyecto en Codemagic**
2. **Selecciona "Environment variables"**
3. **Crea el grupo:** `linux-deploy-group`
4. **Agrega las 4 variables requeridas** con los valores de arriba
5. **Guarda la configuración**

## 🚀 **Workflow Actualizado**

El workflow `flutter-linux-deploy` ahora:

- ✅ **Detecta automáticamente** si es macOS o Linux
- ✅ **Instala las herramientas SSH** correctas para cada sistema
- ✅ **Usa rsync o scp** según disponibilidad
- ✅ **Verifica el despliegue** post-instalación
- ✅ **Muestra la URL** de acceso final

## 🎯 **Resultado Esperado:**

Después de ejecutar el workflow:

- ✅ Aplicación desplegada en `/home/octadev/web-app/`
- ✅ Accesible en `http://10.200.29.141/cambilex`
- ✅ Permisos configurados correctamente
- ✅ Notificación de éxito con URL de acceso

## 🔍 **Solución al Error Anterior:**

El error `apt-get: command not found` se debía a que Codemagic estaba ejecutando en macOS.
Ahora el workflow detecta automáticamente el sistema operativo y usa los comandos correctos.

---

_Configuración lista para usar en Codemagic_
