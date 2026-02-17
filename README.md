# ApiGenericaFastApi_Crud - API REST Genérica CRUD Multi-Base de Datos

![Python Version](https://img.shields.io/badge/Python-3.11+-blue?logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-green?logo=fastapi)
![Database](https://img.shields.io/badge/DB-SQL_Server_%7C_Postgres_%7C_MySQL-brightgreen?logo=databricks)
![Architecture](https://img.shields.io/badge/Architecture-Clean_%26_SOLID-orange)
![License](https://img.shields.io/badge/License-Educativo-lightgrey)

API REST genérica para operaciones CRUD sobre cualquier tabla de base de datos. Soporta múltiples motores con una sola configuración.

---

## Características

- **CRUD Genérico**: Operaciones Create, Read, Update, Delete sobre cualquier tabla
- **Multi-Base de Datos**: SQL Server, SQL Server Express, LocalDB, PostgreSQL, MySQL, MariaDB
- **Swagger UI**: Documentación interactiva automática
- **Encriptación BCrypt**: Hash seguro de contraseñas
- **CORS Configurado**: Listo para consumir desde frontend
- **Async/Await**: Operaciones asíncronas para mejor rendimiento
- **Arquitectura Limpia**: Separación en 3 capas (Controller → Servicio → Repositorio)
- **Principios SOLID**: Diseño extensible y mantenible

---

## Arquitectura

┌──────────────────────────────────────┐
│     CONTROLLERS (Presentación)       │
│         entidades_controller         │
└──────────────────┬───────────────────┘
│
▼
┌──────────────────────────────────────┐
│       SERVICIOS (Negocio)            │
│   ServicioCrud + FábricaRepositorios │
└──────────────────┬───────────────────┘
│
▼
┌──────────────────────────────────────┐
│      REPOSITORIOS (Datos)            │
│  SQL Server │ PostgreSQL │ MySQL     │
│  (aioodbc)  │ (asyncpg)  │ (aiomysql)│
└──────────────────┬───────────────────┘
│
▼
┌──────────────────────────────────────┐
│          BASE DE DATOS               │
└──────────────────────────────────────┘



---

## Requisitos

| Requisito | Versión |
|-----------|---------|
| Python | 3.11 o superior |
| pip | Última versión |
| Git | Última versión |
| Visual Studio Code | Última versión (recomendado) |
| Base de datos | SQL Server, PostgreSQL, MySQL o MariaDB |

---

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/ccastro2050/ApiGenericaFastApi_Crud.git
cd ApiGenericaFastApi_Crud
2. Crear entorno virtual

python -m venv venv

# Windows (PowerShell)
.\venv\Scripts\activate

# Windows (Git Bash)
source venv/Scripts/activate

# Linux/Mac
source venv/bin/activate
3. Instalar dependencias

pip install -r requirements.txt
4. Configurar variables de entorno
Crear un archivo .env en la raíz (ver sección Configuración).

5. Ejecutar la API

# Desarrollo (con auto-reload)
uvicorn main:app --reload --port 8000

# O directamente
python main.py
6. Abrir documentación
Documentación	URL
Swagger UI	http://localhost:8000/swagger
ReDoc	http://localhost:8000/redoc
OpenAPI JSON	http://localhost:8000/swagger/v1/swagger.json
Configuración
Archivo .env

ENVIRONMENT=production
DEBUG=false

# Proveedor activo
DB_PROVIDER=postgres

# Cadenas de conexión
DB_SQLSERVER=Driver={ODBC Driver 17 for SQL Server};Server=MI_SERVIDOR;Database=mi_bd;Trusted_Connection=yes;TrustServerCertificate=yes;
DB_SQLSERVEREXPRESS=Driver={ODBC Driver 17 for SQL Server};Server=MI_SERVIDOR\SQLEXPRESS;Database=mi_bd;Trusted_Connection=yes;TrustServerCertificate=yes;
DB_LOCALDB=Driver={ODBC Driver 17 for SQL Server};Server=(localdb)\MSSQLLocalDB;Database=mi_bd;Trusted_Connection=yes;TrustServerCertificate=yes;
DB_POSTGRES=postgresql+asyncpg://usuario:password@localhost:5432/mi_bd
DB_MYSQL=Server=localhost;Port=3306;Database=mi_bd;User=root;Password=mi_password;CharSet=utf8mb4;
DB_MARIADB=Server=localhost;Port=3306;Database=mi_bd;User=root;Password=;
Cambiar de base de datos
Solo modificar DB_PROVIDER:

Valor	Base de datos
sqlserver	Microsoft SQL Server
sqlserverexpress	SQL Server Express
localdb	SQL Server LocalDB (desarrollo)
postgres	PostgreSQL
mysql	MySQL
mariadb	MariaDB
Bases de Datos Soportadas
Base de Datos	Driver Python	Puerto Default
SQL Server	aioodbc	1433
SQL Server Express	aioodbc	1433
SQL Server LocalDB	aioodbc	-
PostgreSQL	asyncpg	5432
MySQL	aiomysql	3306
MariaDB	aiomysql	3306
Endpoints
Método	Ruta	Descripción
GET	/api/{tabla}	Listar registros
GET	/api/{tabla}/{clave}/{valor}	Filtrar por clave
POST	/api/{tabla}	Crear registro
PUT	/api/{tabla}/{clave}/{valor}	Actualizar registro
DELETE	/api/{tabla}/{clave}/{valor}	Eliminar registro
POST	/api/{tabla}/verificar-contrasena	Verificar credenciales BCrypt
Parámetros opcionales (query string):

Parámetro	Endpoints	Descripción
esquema	Todos	Esquema de la BD (default: public/dbo)
limite	GET listar	Máximo de registros (default: 1000)
campos_encriptar	POST, PUT	Campos a hashear con BCrypt
Ejemplos de Uso
Listar productos

GET /api/producto?limite=50
Buscar por clave

GET /api/producto/codigo/PR004
Crear registro

POST /api/producto
Content-Type: application/json

{
    "codigo": "PR999",
    "nombre": "Laptop HP",
    "stock": 25,
    "valorunitario": 1500000
}
Actualizar registro

PUT /api/producto/codigo/PR999
Content-Type: application/json

{
    "nombre": "Laptop HP Actualizada",
    "stock": 30
}
Eliminar registro

DELETE /api/producto/codigo/PR999
Crear usuario con contraseña encriptada

POST /api/usuario?campos_encriptar=contrasena
Content-Type: application/json

{
    "email": "test@test.com",
    "contrasena": "123456",
    "nombre": "Test"
}
Verificar contraseña

POST /api/usuario/verificar-contrasena?campo_usuario=email&campo_contrasena=contrasena&valor_usuario=test@test.com&valor_contrasena=123456
Estructura del Proyecto

ApiGenericaFastApi_Crud/
├── main.py                                    ← Punto de entrada
├── config.py                                  ← Configuración desde .env
├── requirements.txt                           ← Dependencias
├── .env                                       ← Variables de entorno
├── .gitignore
│
├── .vscode/
│   ├── launch.json                            ← Debug con F5
│   └── settings.json                          ← Intérprete Python
│
├── controllers/
│   ├── __init__.py
│   └── entidades_controller.py                ← 6 endpoints CRUD
│
├── servicios/
│   ├── __init__.py
│   ├── servicio_crud.py                       ← Lógica de negocio
│   ├── fabrica_repositorios.py                ← Factory pattern
│   ├── abstracciones/
│   │   ├── __init__.py
│   │   ├── i_servicio_crud.py                 ← Protocol del servicio
│   │   └── i_proveedor_conexion.py            ← Protocol de conexión
│   ├── conexion/
│   │   ├── __init__.py
│   │   └── proveedor_conexion.py              ← Lee cadenas desde .env
│   └── utilidades/
│       ├── __init__.py
│       └── encriptacion_bcrypt.py             ← Hash y verificación BCrypt
│
└── repositorios/
    ├── __init__.py
    ├── abstracciones/
    │   ├── __init__.py
    │   └── i_repositorio_lectura_tabla.py     ← Protocol del repositorio
    ├── repositorio_lectura_postgresql.py       ← PostgreSQL
    ├── repositorio_lectura_sqlserver.py        ← SQL Server
    └── repositorio_lectura_mysql_mariadb.py    ← MySQL/MariaDB
Principios SOLID Aplicados
Principio	Aplicación
S - Single Responsibility	Controller, Servicio y Repositorio separados
O - Open/Closed	Nueva BD = nueva clase + 1 línea en fábrica
L - Liskov Substitution	Cambiar DB_PROVIDER en .env, todo sigue funcionando
I - Interface Segregation	Protocols pequeños y específicos
D - Dependency Inversion	Servicios reciben abstracciones, no clases concretas
Tecnologías Utilizadas
Tecnología	Versión	Propósito
Python	3.11+	Lenguaje principal
FastAPI	0.100+	Framework web async
Uvicorn	0.22+	Servidor ASGI
Pydantic	2.0+	Validación de datos
pydantic-settings	2.0+	Configuración desde .env
passlib + bcrypt	1.7+	Hash de contraseñas
SQLAlchemy	2.0+	Engine async para queries
asyncpg	0.28+	Driver PostgreSQL
aiomysql	0.2+	Driver MySQL/MariaDB
aioodbc	0.5+	Driver SQL Server
Solución de Problemas Comunes
Error de conexión a la base de datos
Síntoma: Connection refused o timeout

Solución:

Verificar que el servicio de la BD esté corriendo
Revisar que DB_PROVIDER coincida con una cadena configurada
Para SQL Server, asegurar tener ODBC Driver 17 instalado
ModuleNotFoundError
Síntoma: No module named 'fastapi'

Solución:


# Verificar que el entorno virtual esté activo
.\venv\Scripts\activate

# Reinstalar dependencias
pip install -r requirements.txt
Pylance no resuelve imports
Síntoma: Import "fastapi" could not be resolved

Solución: Ctrl+Shift+P → Python: Select Interpreter → seleccionar .\venv\Scripts\python.exe

Puerto en uso
Síntoma: Address already in use

Solución:


# Cambiar puerto
uvicorn main:app --reload --port 8001
Comandos Útiles

# Activar entorno virtual
.\venv\Scripts\activate              # Windows PowerShell
source venv/Scripts/activate         # Windows Git Bash
source venv/bin/activate             # Linux/Mac

# Instalar dependencias
pip install -r requirements.txt

# Ejecutar en desarrollo
uvicorn main:app --reload --port 8000

# Ejecutar en producción
uvicorn main:app --host 0.0.0.0 --port 8000

# Debug en VS Code
F5
Licencia
Este proyecto es de uso educativo.

Autor
Basado en el proyecto ApiGenericaCsharp de Carlos Arturo Castro Castro.

Versión simplificada en Python/FastAPI enfocada en CRUD genérico.

