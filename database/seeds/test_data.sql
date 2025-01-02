-- test_data.sql
-- Descripción: Datos de prueba para desarrollo y testing
-- Fecha: 2024-01-02

-- Limpiar datos existentes si es necesario
/*
DELETE FROM jugador_equipo_partido;
DELETE FROM equipo_partido;
DELETE FROM partidos;
DELETE FROM perfil_jugador;
DELETE FROM usuarios;
*/

-- Insertar usuarios de prueba
INSERT INTO usuarios (google_id, email, username, nombre) VALUES 
    ('test_gid_1', 'jugador1@test.com', 'jugador1', 'Juan Pérez'),
    ('test_gid_2', 'jugador2@test.com', 'jugador2', 'María García'),
    ('test_gid_3', 'jugador3@test.com', 'jugador3', 'Carlos López'),
    ('test_gid_4', 'jugador4@test.com', 'jugador4', 'Ana Martínez'),
    ('test_gid_5', 'jugador5@test.com', 'jugador5', 'Pedro Sánchez'),
    ('test_gid_6', 'jugador6@test.com', 'jugador6', 'Laura Torres'),
    ('test_gid_7', 'jugador7@test.com', 'jugador7', 'Diego Ramírez'),
    ('test_gid_8', 'jugador8@test.com', 'jugador8', 'Sofia Castro'),
    ('test_gid_9', 'jugador9@test.com', 'jugador9', 'Lucas Ruiz'),
    ('test_gid_10', 'jugador10@test.com', 'jugador10', 'Emma Díaz');

-- Insertar perfiles de jugador
INSERT INTO perfil_jugador (usuario_id, pierna_dominante, posiciones_experiencia, nivel_experiencia)
SELECT 
    id,
    CASE random()::int % 3 
        WHEN 0 THEN 'DERECHO'
        WHEN 1 THEN 'IZQUIERDO'
        ELSE 'AMBOS'
    END,
    CASE random()::int % 3
        WHEN 0 THEN '{"delantero": 5, "mediocampista": 3}'::jsonb
        WHEN 1 THEN '{"defensa": 4, "portero": 2}'::jsonb
        ELSE '{"mediocampista": 5, "defensa": 3}'::jsonb
    END,
    CASE random()::int % 3
        WHEN 0 THEN 'PRINCIPIANTE'
        WHEN 1 THEN 'INTERMEDIO'
        ELSE 'AVANZADO'
    END
FROM usuarios;

-- Crear partido de prueba (6vs6)
INSERT INTO partidos (
    organizador_id,
    tipo_partido_id,
    fecha_hora,
    lugar,
    direccion,
    descripcion
) VALUES (
    (SELECT id FROM usuarios WHERE email = 'jugador1@test.com'),
    (SELECT id FROM tipo_partido WHERE nombre = '6vs6'),
    NOW() + interval '2 days',
    'Cancha Deportiva Central',
    'Av. Principal 123, Ciudad Deportiva',
    'Partido amistoso de prueba'
);

-- Crear equipos para el partido
INSERT INTO equipo_partido (partido_id, tipo, nombre) 
SELECT 
    (SELECT id FROM partidos WHERE lugar = 'Cancha Deportiva Central'),
    tipo,
    nombre
FROM (
    VALUES 
        ('LOCAL', 'Equipo Local Test'),
        ('VISITANTE', 'Equipo Visitante Test')
) AS equipos(tipo, nombre);

-- Asignar jugadores a equipos
WITH equipo_local AS (
    SELECT id FROM equipo_partido WHERE tipo = 'LOCAL'
),
equipo_visitante AS (
    SELECT id FROM equipo_partido WHERE tipo = 'VISITANTE'
),
jugadores_locales AS (
    SELECT id FROM usuarios WHERE email IN (
        'jugador1@test.com',
        'jugador2@test.com',
        'jugador3@test.com',
        'jugador4@test.com',
        'jugador5@test.com'
    )
),
jugadores_visitantes AS (
    SELECT id FROM usuarios WHERE email IN (
        'jugador6@test.com',
        'jugador7@test.com',
        'jugador8@test.com',
        'jugador9@test.com',
        'jugador10@test.com'
    )
)
INSERT INTO jugador_equipo_partido (equipo_partido_id, usuario_id, posicion)
SELECT 
    (SELECT id FROM equipo_local), 
    id,
    'JUGADOR'
FROM jugadores_locales
UNION ALL
SELECT 
    (SELECT id FROM equipo_visitante),
    id,
    'JUGADOR'
FROM jugadores_visitantes;

-- Crear algunas amistades
INSERT INTO amistades (usuario1_id, usuario2_id, estado)
SELECT 
    u1.id,
    u2.id,
    'ACEPTADA'
FROM usuarios u1
JOIN usuarios u2 ON u1.id < u2.id
WHERE u1.email = 'jugador1@test.com'
AND u2.email IN ('jugador2@test.com', 'jugador3@test.com');

-- Crear algunas notificaciones
INSERT INTO notificaciones (usuario_id, tipo, contenido)
SELECT 
    id,
    'INVITACION_PARTIDO',
    'Has sido invitado a un nuevo partido'
FROM usuarios
WHERE email IN ('jugador1@test.com', 'jugador2@test.com');

-- Query de verificación
SELECT 
    p.fecha_hora,
    p.lugar,
    u.nombre as organizador,
    ep.tipo as tipo_equipo,
    ep.nombre as nombre_equipo,
    COUNT(jep.usuario_id) as num_jugadores
FROM partidos p
JOIN usuarios u ON p.organizador_id = u.id
JOIN equipo_partido ep ON p.id = ep.partido_id
LEFT JOIN jugador_equipo_partido jep ON ep.id = jep.equipo_partido_id
GROUP BY p.fecha_hora, p.lugar, u.nombre, ep.tipo, ep.nombre
ORDER BY p.fecha_hora;