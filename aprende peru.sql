CREATE DATABASE Aprende_Peru;
USE Aprende_Peru;


CREATE TABLE Area (
    id_area INT PRIMARY KEY,
    nombre_area VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Evaluacion (
    id_evaluacion INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_area INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    tiempo_duracion INT NOT NULL, -- en minutos
    tipo ENUM('cerrada') NOT NULL,
    vigente BOOLEAN NOT NULL,
    CONSTRAINT fk_evaluacion_area FOREIGN KEY (id_area) REFERENCES Area(id_area)
) ENGINE=InnoDB;

CREATE TABLE Pregunta (
    id_pregunta INT PRIMARY KEY,
    id_evaluacion INT NOT NULL,
    enunciado TEXT NOT NULL,
    puntaje INT NOT NULL,
    CONSTRAINT fk_pregunta_evaluacion FOREIGN KEY (id_evaluacion) REFERENCES Evaluacion(id_evaluacion)
) ENGINE=InnoDB;

CREATE TABLE Alternativa (
    id_alternativa INT PRIMARY KEY,
    id_pregunta INT NOT NULL,
    texto TEXT NOT NULL,
    es_correcta BOOLEAN NOT NULL,
    CONSTRAINT fk_alternativa_pregunta FOREIGN KEY (id_pregunta) REFERENCES Pregunta(id_pregunta)
) ENGINE=InnoDB;

CREATE TABLE Estudiante (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Asignacion (
    id_asignacion INT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_evaluacion INT NOT NULL,
    asignada BOOLEAN NOT NULL,
    CONSTRAINT fk_asignacion_estudiante FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante),
    CONSTRAINT fk_asignacion_evaluacion FOREIGN KEY (id_evaluacion) REFERENCES Evaluacion(id_evaluacion),
    CONSTRAINT unq_estudiante_evaluacion UNIQUE (id_estudiante, id_evaluacion)
) ENGINE=InnoDB;

CREATE TABLE Intento (
    id_intento INT PRIMARY KEY,
    id_asignacion INT NOT NULL,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP NULL DEFAULT NULL,
    puntaje_total INT,
    estado ENUM('completado', 'en_progreso', 'anulado') NOT NULL,
    CONSTRAINT fk_intento_asignacion FOREIGN KEY (id_asignacion) REFERENCES Asignacion(id_asignacion)
) ENGINE=InnoDB;

CREATE TABLE Respuesta (
    id_respuesta INT PRIMARY KEY,
    id_intento INT NOT NULL,
    id_pregunta INT NOT NULL,
    id_alternativa_marcada INT NOT NULL,
    CONSTRAINT fk_respuesta_intento FOREIGN KEY (id_intento) REFERENCES Intento(id_intento),
    CONSTRAINT fk_respuesta_pregunta FOREIGN KEY (id_pregunta) REFERENCES Pregunta(id_pregunta),
    CONSTRAINT fk_respuesta_alternativa FOREIGN KEY (id_alternativa_marcada) REFERENCES Alternativa(id_alternativa)
) ENGINE=InnoDB;

INSERT INTO Area (id_area, nombre_area) VALUES
(1, 'Ciencias Básicas');


INSERT INTO Estudiante (id_estudiante, nombre, email) VALUES
(1, 'María Gómez', 'maria.gomez@example.com'),
(2, 'Juan Pérez', 'juan.perez@example.com'),
(3, 'Lucía Martínez', 'lucia.martinez@example.com'),
(4, 'Carlos Rodríguez', 'carlos.rodriguez@example.com'),
(5, 'Ana Fernández', 'ana.fernandez@example.com'),
(6, 'David López', 'david.lopez@example.com'),
(7, 'Sofía Sánchez', 'sofia.sanchez@example.com'),
(8, 'Miguel Torres', 'miguel.torres@example.com'),
(9, 'Laura Díaz', 'laura.diaz@example.com'),
(10, 'Jorge Morales', 'jorge.morales@example.com');


INSERT INTO Evaluacion (id_evaluacion, nombre, id_area, fecha_inicio, fecha_fin, tiempo_duracion, tipo, vigente) VALUES
(1, 'Evaluación Matemáticas Básicas', 1, '2025-06-01', '2025-06-30', 60, 'cerrada', TRUE),
(2, 'Evaluación Física I', 1, '2025-06-05', '2025-07-05', 60, 'cerrada', TRUE),
(3, 'Evaluación Química General', 1, '2025-06-10', '2025-07-10', 60, 'cerrada', TRUE),
(4, 'Evaluación Historia Universal', 1, '2025-06-15', '2025-07-15', 60, 'cerrada', TRUE),
(5, 'Evaluación Literatura Clásica', 1, '2025-06-20', '2025-07-20', 60, 'cerrada', TRUE);

INSERT INTO Pregunta (id_pregunta, id_evaluacion, enunciado, puntaje) VALUES
(1, 1, '¿Cuál es el resultado de 2 + 2?', 5),
(2, 1, '¿Qué número es primo?', 5),
(3, 1, '¿Cuál es la fórmula del área del círculo?', 5),
(4, 1, '¿Qué es un número entero?', 5),
(5, 1, '¿Cuánto es 10 dividido entre 2?', 5),

(6, 2, '¿Cuál es la fórmula de la velocidad?', 5),
(7, 2, '¿Qué unidad mide la fuerza?', 5),
(8, 2, '¿Qué es la gravedad?', 5),
(9, 2, '¿Qué instrumento mide la presión?', 5),
(10, 2, '¿Qué es un vector?', 5),

(11, 3, '¿Cuál es el símbolo químico del agua?', 5),
(12, 3, '¿Qué es un átomo?', 5),
(13, 3, '¿Cuál es el pH neutro?', 5),
(14, 3, '¿Qué es un ion?', 5),
(15, 3, '¿Cuál es la fórmula del dióxido de carbono?', 5),

(16, 4, '¿Quién fue Napoleón Bonaparte?', 5),
(17, 4, '¿Qué evento inició la Primera Guerra Mundial?', 5),
(18, 4, '¿Qué fue la Revolución Francesa?', 5),
(19, 4, '¿En qué año se firmó la Declaración de Independencia de EE.UU.?', 5),
(20, 4, '¿Qué es la Guerra Fría?', 5),

(21, 5, '¿Quién escribió "Don Quijote de la Mancha"?', 5),
(22, 5, '¿Qué es una metáfora?', 5),
(23, 5, '¿Qué género literario es la poesía?', 5),
(24, 5, '¿Quién es Gabriel García Márquez?', 5),
(25, 5, '¿Qué es un cuento?', 5);


INSERT INTO Alternativa (id_alternativa, id_pregunta, texto, es_correcta) VALUES
(1, 1, 'Alternativa A correcta', TRUE),
(2, 1, 'Alternativa B incorrecta', FALSE),
(3, 1, 'Alternativa C incorrecta', FALSE),
(4, 1, 'Alternativa D incorrecta', FALSE),

(5, 2, 'Alternativa A correcta', TRUE),
(6, 2, 'Alternativa B incorrecta', FALSE),
(7, 2, 'Alternativa C incorrecta', FALSE),
(8, 2, 'Alternativa D incorrecta', FALSE),

(9, 3, 'Alternativa A correcta', TRUE),
(10, 3, 'Alternativa B incorrecta', FALSE),
(11, 3, 'Alternativa C incorrecta', FALSE),
(12, 3, 'Alternativa D incorrecta', FALSE),

(13, 4, 'Alternativa A correcta', TRUE),
(14, 4, 'Alternativa B incorrecta', FALSE),
(15, 4, 'Alternativa C incorrecta', FALSE),
(16, 4, 'Alternativa D incorrecta', FALSE),

(17, 5, 'Alternativa A correcta', TRUE),
(18, 5, 'Alternativa B incorrecta', FALSE),
(19, 5, 'Alternativa C incorrecta', FALSE),
(20, 5, 'Alternativa D incorrecta', FALSE),

(21, 6, 'Alternativa A correcta', TRUE),
(22, 6, 'Alternativa B incorrecta', FALSE),
(23, 6, 'Alternativa C incorrecta', FALSE),
(24, 6, 'Alternativa D incorrecta', FALSE),

(25, 7, 'Alternativa A correcta', TRUE),
(26, 7, 'Alternativa B incorrecta', FALSE),
(27, 7, 'Alternativa C incorrecta', FALSE),
(28, 7, 'Alternativa D incorrecta', FALSE),

(29, 8, 'Alternativa A correcta', TRUE),
(30, 8, 'Alternativa B incorrecta', FALSE),
(31, 8, 'Alternativa C incorrecta', FALSE),
(32, 8, 'Alternativa D incorrecta', FALSE),

(33, 9, 'Alternativa A correcta', TRUE),
(34, 9, 'Alternativa B incorrecta', FALSE),
(35, 9, 'Alternativa C incorrecta', FALSE),
(36, 9, 'Alternativa D incorrecta', FALSE),

(37, 10, 'Alternativa A correcta', TRUE),
(38, 10, 'Alternativa B incorrecta', FALSE),
(39, 10, 'Alternativa C incorrecta', FALSE),
(40, 10, 'Alternativa D incorrecta', FALSE),

(41, 11, 'Alternativa A correcta', TRUE),
(42, 11, 'Alternativa B incorrecta', FALSE),
(43, 11, 'Alternativa C incorrecta', FALSE),
(44, 11, 'Alternativa D incorrecta', FALSE),

(45, 12, 'Alternativa A correcta', TRUE),
(46, 12, 'Alternativa B incorrecta', FALSE),
(47, 12, 'Alternativa C incorrecta', FALSE),
(48, 12, 'Alternativa D incorrecta', FALSE),

(49, 13, 'Alternativa A correcta', TRUE),
(50, 13, 'Alternativa B incorrecta', FALSE),
(51, 13, 'Alternativa C incorrecta', FALSE),
(52, 13, 'Alternativa D incorrecta', FALSE),

(53, 14, 'Alternativa A correcta', TRUE),
(54, 14, 'Alternativa B incorrecta', FALSE),
(55, 14, 'Alternativa C incorrecta', FALSE),
(56, 14, 'Alternativa D incorrecta', FALSE),

(57, 15, 'Alternativa A correcta', TRUE),
(58, 15, 'Alternativa B incorrecta', FALSE),
(59, 15, 'Alternativa C incorrecta', FALSE),
(60, 15, 'Alternativa D incorrecta', FALSE),

(61, 16, 'Alternativa A correcta', TRUE),
(62, 16, 'Alternativa B incorrecta', FALSE),
(63, 16, 'Alternativa C incorrecta', FALSE),
(64, 16, 'Alternativa D incorrecta', FALSE),

(65, 17, 'Alternativa A correcta', TRUE),
(66, 17, 'Alternativa B incorrecta', FALSE),
(67, 17, 'Alternativa C incorrecta', FALSE),
(68, 17, 'Alternativa D incorrecta', FALSE),

(69, 18, 'Alternativa A correcta', TRUE),
(70, 18, 'Alternativa B incorrecta', FALSE),
(71, 18, 'Alternativa C incorrecta', FALSE),
(72, 18, 'Alternativa D incorrecta', FALSE),

(73, 19, 'Alternativa A correcta', TRUE),
(74, 19, 'Alternativa B incorrecta', FALSE),
(75, 19, 'Alternativa C incorrecta', FALSE),
(76, 19, 'Alternativa D incorrecta', FALSE),

(77, 20, 'Alternativa A correcta', TRUE),
(78, 20, 'Alternativa B incorrecta', FALSE),
(79, 20, 'Alternativa C incorrecta', FALSE),
(80, 20, 'Alternativa D incorrecta', FALSE),

(81, 21, 'Alternativa A correcta', TRUE),
(82, 21, 'Alternativa B incorrecta', FALSE),
(83, 21, 'Alternativa C incorrecta', FALSE),
(84, 21, 'Alternativa D incorrecta', FALSE),

(85, 22, 'Alternativa A correcta', TRUE),
(86, 22, 'Alternativa B incorrecta', FALSE),
(87, 22, 'Alternativa C incorrecta', FALSE),
(88, 22, 'Alternativa D incorrecta', FALSE),

(89, 23, 'Alternativa A correcta', TRUE),
(90, 23, 'Alternativa B incorrecta', FALSE),
(91, 23, 'Alternativa C incorrecta', FALSE),
(92, 23, 'Alternativa D incorrecta', FALSE),

(93, 24, 'Alternativa A correcta', TRUE),
(94, 24, 'Alternativa B incorrecta', FALSE),
(95, 24, 'Alternativa C incorrecta', FALSE),
(96, 24, 'Alternativa D incorrecta', FALSE),

(97, 25, 'Alternativa A correcta', TRUE),
(98, 25, 'Alternativa B incorrecta', FALSE),
(99, 25, 'Alternativa C incorrecta', FALSE),
(100, 25, 'Alternativa D incorrecta', FALSE);


INSERT INTO Asignacion (id_asignacion, id_estudiante, id_evaluacion, asignada) VALUES
(1, 1, 1, TRUE),
(2, 2, 1, TRUE),
(3, 3, 2, TRUE),
(4, 4, 3, TRUE),
(5, 5, 4, TRUE);


INSERT INTO Intento (id_intento, id_asignacion, fecha_inicio, fecha_fin, puntaje_total, estado) VALUES
(1, 1, '2025-06-02 09:00:00', '2025-06-02 09:50:00', 25, 'completado'),
(2, 2, '2025-06-02 10:00:00', NULL, NULL, 'en_progreso');


INSERT INTO Respuesta (id_respuesta, id_intento, id_pregunta, id_alternativa_marcada) VALUES
(1, 1, 1, 1),
(2, 1, 2, 5),
(3, 1, 3, 9),
(4, 1, 4, 13),
(5, 1, 5, 17);

SELECT
    e.id_evaluacion,
    e.nombre AS nombre_evaluacion,
    a.nombre_area,
    e.fecha_inicio,
    e.fecha_fin,
    e.tiempo_duracion,
    e.tipo,
    e.vigente
FROM Evaluacion e
JOIN Area a ON e.id_area = a.id_area;

SELECT
    p.id_pregunta,
    p.enunciado,
    p.puntaje,
    al.id_alternativa,
    al.texto,
    al.es_correcta
FROM Pregunta p
JOIN Alternativa al ON p.id_pregunta = al.id_pregunta
WHERE p.id_evaluacion = 1
ORDER BY p.id_pregunta, al.id_alternativa;

SELECT
  es.id_estudiante,
  es.nombre AS nombre_estudiante,
  es.email,
  ev.nombre AS nombre_evaluacion,
  asig.asignada
FROM Estudiante es
JOIN Asignacion asig ON es.id_estudiante = asig.id_estudiante
JOIN Evaluacion ev ON asig.id_evaluacion = ev.id_evaluacion
ORDER BY es.id_estudiante, ev.id_evaluacion;

SELECT
  i.id_intento,
  es.nombre AS estudiante,
  ev.nombre AS evaluacion,
  i.fecha_inicio,
  i.fecha_fin,
  i.puntaje_total,
  i.estado
FROM Intento i
JOIN Asignacion a ON i.id_asignacion = a.id_asignacion
JOIN Estudiante es ON a.id_estudiante = es.id_estudiante
JOIN Evaluacion ev ON a.id_evaluacion = ev.id_evaluacion
WHERE es.id_estudiante = 1  -- Cambia el ID para otro estudiante
ORDER BY i.fecha_inicio DESC;

SELECT
  r.id_respuesta,
  p.enunciado AS pregunta,
  al.texto AS alternativa_marcada,
  al.es_correcta
FROM Respuesta r
JOIN Pregunta p ON r.id_pregunta = p.id_pregunta
JOIN Alternativa al ON r.id_alternativa_marcada = al.id_alternativa
WHERE r.id_intento = 1
ORDER BY r.id_respuesta;

SELECT
  es.id_estudiante,
  es.nombre,
  ev.id_evaluacion,
  ev.nombre AS evaluacion,
  COALESCE(SUM(p.puntaje), 0) AS puntaje_obtenido
FROM Estudiante es
JOIN Asignacion a ON es.id_estudiante = a.id_estudiante
JOIN Evaluacion ev ON a.id_evaluacion = ev.id_evaluacion
LEFT JOIN Intento i ON a.id_asignacion = i.id_asignacion AND i.estado = 'completado'
LEFT JOIN Respuesta r ON i.id_intento = r.id_intento
LEFT JOIN Pregunta p ON r.id_pregunta = p.id_pregunta
LEFT JOIN Alternativa al ON r.id_alternativa_marcada = al.id_alternativa AND al.es_correcta = TRUE
WHERE al.id_alternativa IS NOT NULL
GROUP BY es.id_estudiante, ev.id_evaluacion
ORDER BY es.id_estudiante, ev.id_evaluacion;

SELECT
  id_evaluacion,
  nombre,
  fecha_inicio,
  fecha_fin
FROM Evaluacion
WHERE vigente = TRUE
  AND CURDATE() BETWEEN fecha_inicio AND fecha_fin
ORDER BY fecha_inicio;


