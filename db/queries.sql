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
WHERE es.id_estudiante = 1  
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
