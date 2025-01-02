
Este README proporciona:
1. Instrucciones claras de instalación
2. Documentación de la estructura
3. Comandos útiles
4. Guías de mantenimiento
5. Convenciones del proyecto
6. Solución a problemas comunes


# Base de Datos FútbolApp

Este directorio contiene los scripts SQL y documentación relacionada con la base de datos de FútbolApp.

## Estructura del Directorio
database/
├── migrations/
│   ├── 001_initial_schema.sql       # Esquema inicial de la base de datos
│   ├── 002_seed_data.sql           # Datos iniciales y de prueba
│   └── README.md                    # Documentación de migraciones
├── scripts/
│   └── test_data.sql               # Scripts para pruebas
└── README.md                        # Este archivo

## Requisitos Previos

- PostgreSQL 12 o superior
- pgAdmin 4 (recomendado para gestión visual)

## Configuración Inicial

1. Crear una nueva base de datos:
```sql
CREATE DATABASE futbol_app_db;

psql -U tu_usuario -d futbol_app_db -f migrations/001_initial_schema.sql
psql -U tu_usuario -d futbol_app_db -f migrations/002_seed_data.sql

O desde pgAdmin:

Abrir pgAdmin
Conectar a tu servidor
Crear nueva base de datos "futbol_app_db"
Abrir la herramienta de consultas
Ejecutar los scripts en orden

Estructura de la Base de Datos
Tablas Principales

usuarios: Información de usuarios
perfil_jugador: Perfiles de jugadores
partidos: Información de partidos
equipo_partido: Equipos en cada partido
tipo_partido: Tipos de partido (6vs6, 7vs7, etc.)
grupos: Grupos de jugadores
invitaciones: Sistema de invitaciones
notificaciones: Sistema de notificaciones

Tipos ENUM

usuario_estado: Estados posibles de usuario
partido_estado: Estados posibles de un partido
equipo_tipo: Tipos de equipo (LOCAL/VISITANTE)
pie_dominante: Preferencia de pie del jugador

Desarrollo
Datos de Prueba
Para cargar datos de prueba, descomentar la sección correspondiente en 002_seed_data.sql
Convenciones de Nombrado

Tablas: plural, snake_case
Columnas: singular, snake_case
Índices: prefix 'idx_'
Constraints: descriptivos del propósito