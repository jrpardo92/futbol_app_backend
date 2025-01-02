-- 001_initial_schema.sql
-- Descripción: Esquema inicial de la base de datos para la aplicación de fútbol
-- Fecha: 2024-01-02

-- Crear extensión para UUID si no existe
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Crear tipos ENUM
CREATE TYPE usuario_estado AS ENUM ('ACTIVO', 'INACTIVO', 'SUSPENDIDO', 'ELIMINADO');
CREATE TYPE grupo_estado AS ENUM ('ACTIVO', 'ARCHIVADO');
CREATE TYPE partido_estado AS ENUM ('PROGRAMADO', 'EN_PROGRESO', 'FINALIZADO', 'CANCELADO');
CREATE TYPE invitacion_estado AS ENUM ('PENDIENTE', 'ACEPTADA', 'RECHAZADA', 'EXPIRADA');
CREATE TYPE equipo_tipo AS ENUM ('LOCAL', 'VISITANTE');
CREATE TYPE pie_dominante AS ENUM ('IZQUIERDO', 'DERECHO', 'AMBOS');
CREATE TYPE amistad_estado AS ENUM ('PENDIENTE', 'ACEPTADA');

-- Crear tablas
-- Tabla usuarios
CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    google_id VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(30) UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    foto_perfil VARCHAR(255),
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    estado usuario_estado DEFAULT 'ACTIVO',
    CONSTRAINT username_format CHECK (username ~ '^[a-zA-Z0-9_-]{4,30}$')
);

-- Tabla perfil_jugador
CREATE TABLE perfil_jugador (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    pierna_dominante pie_dominante,
    posiciones_experiencia JSONB,
    nivel_experiencia VARCHAR(20),
    UNIQUE(usuario_id)
);

-- Tabla tipo_partido
CREATE TABLE tipo_partido (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(20) NOT NULL UNIQUE,
    max_jugadores INTEGER NOT NULL
);

-- Tabla partidos
CREATE TABLE partidos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organizador_id UUID NOT NULL REFERENCES usuarios(id),
    tipo_partido_id UUID NOT NULL REFERENCES tipo_partido(id),
    fecha_hora TIMESTAMP WITH TIME ZONE NOT NULL,
    lugar VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500),
    estado partido_estado DEFAULT 'PROGRAMADO',
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla equipo_partido
CREATE TABLE equipo_partido (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    partido_id UUID NOT NULL REFERENCES partidos(id),
    tipo equipo_tipo NOT NULL,
    nombre VARCHAR(50),
    UNIQUE(partido_id, tipo)
);

-- Tabla jugador_equipo_partido
CREATE TABLE jugador_equipo_partido (
    equipo_partido_id UUID REFERENCES equipo_partido(id),
    usuario_id UUID REFERENCES usuarios(id),
    posicion VARCHAR(50) NOT NULL,
    PRIMARY KEY (equipo_partido_id, usuario_id)
);

-- Tabla grupos
CREATE TABLE grupos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(50) NOT NULL,
    creador_id UUID NOT NULL REFERENCES usuarios(id),
    logo VARCHAR(255),
    descripcion VARCHAR(500),
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    estado grupo_estado DEFAULT 'ACTIVO'
);

-- Tabla miembro_grupo
CREATE TABLE miembro_grupo (
    grupo_id UUID REFERENCES grupos(id),
    usuario_id UUID REFERENCES usuarios(id),
    es_admin BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (grupo_id, usuario_id)
);

-- Tabla invitaciones
CREATE TABLE invitaciones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    partido_id UUID NOT NULL REFERENCES partidos(id),
    invitador_id UUID NOT NULL REFERENCES usuarios(id),
    invitado_id UUID NOT NULL REFERENCES usuarios(id),
    estado invitacion_estado DEFAULT 'PENDIENTE',
    fecha_invitacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_respuesta TIMESTAMP WITH TIME ZONE
);

-- Tabla amistades
CREATE TABLE amistades (
    usuario1_id UUID REFERENCES usuarios(id),
    usuario2_id UUID REFERENCES usuarios(id),
    estado amistad_estado DEFAULT 'PENDIENTE',
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario1_id, usuario2_id),
    CHECK (usuario1_id < usuario2_id)
);

-- Tabla notificaciones
CREATE TABLE notificaciones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    tipo VARCHAR(50) NOT NULL,
    contenido TEXT NOT NULL,
    leida BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion TIMESTAMP WITH TIME ZONE
);

-- Crear índices
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_partidos_fecha_hora ON partidos(fecha_hora);
CREATE INDEX idx_partidos_organizador ON partidos(organizador_id);
CREATE INDEX idx_partidos_estado_fecha ON partidos(estado, fecha_hora);
CREATE INDEX idx_invitaciones_partido ON invitaciones(partido_id);
CREATE INDEX idx_invitaciones_estado ON invitaciones(estado);
CREATE INDEX idx_notificaciones_usuario ON notificaciones(usuario_id, leida);
CREATE INDEX idx_notificaciones_usuario_fecha ON notificaciones(usuario_id, fecha_creacion);
CREATE INDEX idx_miembro_grupo_usuario ON miembro_grupo(usuario_id);
CREATE INDEX idx_jugador_equipo_usuario ON jugador_equipo_partido(usuario_id);