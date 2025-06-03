
SELECT COUNT(DISTINCT a.id_estudiante) AS total_desaprobados
FROM Asignacion a
JOIN Intento i ON a.id_asignacion = i.id_asignacion
WHERE i.puntaje_total < 11 AND i.estado = 'completado';


SELECT COUNT(DISTINCT a.id_estudiante) AS total_aprobados
FROM Asignacion a
JOIN Intento i ON a.id_asignacion = i.id_asignacion
WHERE a.id_evaluacion = 1 AND i.puntaje_total >= 11 AND i.estado = 'completado';


SELECT
    COUNT(a.id_asignacion) AS total_inscritos,
    SUM(CASE WHEN i.estado = 'completado' THEN 1 ELSE 0 END) AS resueltos,
    SUM(CASE WHEN i.estado = 'en_progreso' THEN 1 ELSE 0 END) AS pendientes
FROM Asignacion a
LEFT JOIN Intento i ON a.id_asignacion = i.id_asignacion
WHERE a.id_estudiante = 1;


SELECT
    MAX(i.puntaje_total) AS mejor_calificacion,
    MIN(i.puntaje_total) AS peor_calificacion
FROM Asignacion a
JOIN Intento i ON a.id_asignacion = i.id_asignacion
WHERE a.id_evaluacion = 1 AND i.estado = 'completado';


SELECT AVG(i.puntaje_total) AS promedio
FROM Asignacion a
JOIN Intento i ON a.id_asignacion = i.id_asignacion
WHERE a.id_estudiante = 1 AND i.estado = 'completado';