-- 002_seed_data.sql
-- Descripción: Datos iniciales necesarios para el funcionamiento de la aplicación
-- Fecha: 2024-01-02

-- Insertar tipos de partido
INSERT INTO tipo_partido (nombre, max_jugadores) VALUES
    ('6vs6', 12),
    ('7vs7', 14),
    ('11vs11', 22)
ON CONFLICT (nombre) DO NOTHING;

-- Insertar usuario de prueba administrador (opcional)
INSERT INTO usuarios (
    google_id,
    email,
    username,
    nombre,
    estado
) VALUES (
    'admin_google_id_123',
    'admin@futbolapp.com',
    'admin',
    'Administrador',
    'ACTIVO'
) ON CONFLICT (email) DO NOTHING;

-- Insertar datos de prueba para desarrollo (comentados por defecto)
/*
-- Usuarios de prueba
INSERT INTO usuarios (google_id, email, username, nombre) VALUES
    ('test_id_1', 'test1@example.com', 'test1', 'Usuario Test 1'),
    ('test_id_2', 'test2@example.com', 'test2', 'Usuario Test 2'),
    ('test_id_3', 'test3@example.com', 'test3', 'Usuario Test 3')
ON CONFLICT (email) DO NOTHING;

-- Perfiles de jugador de prueba
INSERT INTO perfil_jugador (
    usuario_id,
    pierna_dominante,
    posiciones_experiencia,
    nivel_experiencia
) VALUES (
    (SELECT id FROM usuarios WHERE email = 'test1@example.com'),
    'DERECHO',
    '{"delantero": 5, "mediocampista": 3}'::jsonb,
    'INTERMEDIO'
);
*/

-- Agregar cualquier otro dato inicial necesario aquí