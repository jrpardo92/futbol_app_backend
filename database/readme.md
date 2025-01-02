# FútbolApp - Documentación de Base de Datos

## Descripción
Este directorio contiene todos los scripts SQL y documentación relacionada con la base de datos PostgreSQL de FútbolApp. La base de datos está diseñada para soportar una aplicación de organización de partidos de fútbol amateur.

## Estructura del Proyecto

database/
├── migrations/          # Scripts de migración secuenciales
│   ├── 001_initial_schema.sql   # Estructura inicial de la DB
│   ├── 002_seed_data.sql       # Datos iniciales necesarios
│   └── README.md               # Guía de migraciones
├── scripts/            # Scripts útiles y de prueba
│   └── test_data.sql          # Datos de prueba para desarrollo
└── README.md          # Este archivo

## Requisitos
- PostgreSQL 12 o superior
- pgAdmin 4 (recomendado)
- Permisos de superusuario para crear extensiones

## Instalación

1. Crear la base de datos
```sql
CREATE DATABASE futbol_app_db;

# Desde línea de comandos
psql -U tu_usuario -d futbol_app_db -f migrations/001_initial_schema.sql
psql -U tu_usuario -d futbol_app_db -f migrations/002_seed_data.sql

# O usar pgAdmin para ejecutar los scripts

Estructura de la Base de Datos
Tablas Principales

usuarios: Almacena información de usuarios
perfil_jugador: Perfiles de jugadores
partidos: Gestión de partidos
equipo_partido: Equipos por partido
jugador_equipo_partido: Asignación de jugadores
grupos: Grupos de usuarios
invitaciones: Sistema de invitaciones
amistades: Relaciones entre usuarios
notificaciones: Sistema de notificaciones

Relaciones Clave

Un usuario puede tener un perfil de jugador
Un partido tiene dos equipos (local y visitante)
Los jugadores pueden pertenecer a un equipo en un partido
Los usuarios pueden crear y pertenecer a grupos

Uso
Desarrollo

Ejecutar migraciones base
Cargar datos de prueba si es necesario:
psql -U tu_usuario -d futbol_app_db -f scripts/test_data.sql

Producción

Solo ejecutar migraciones base
NO ejecutar scripts de prueba