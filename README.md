                                      Aprende Perú - Evaluación Web
Este proyecto tiene como objetivo desarrollar un sistema web para gestionar y evaluar a los estudiantes del centro de capacitación Aprende Perú, permitiendo la creación de exámenes, asignación a estudiantes y evaluación automática.

📝 Requerimientos Funcionales
Crear evaluaciones clasificadas por tipo o área.

Evaluaciones de tipo cerrada (solo alternativas).

Cada pregunta tiene un puntaje y una única respuesta correcta.

Las evaluaciones son vigesimales (puntaje máximo de 20).

Fecha de inicio/fin y tiempo máximo para desarrollar una evaluación.

Cada estudiante solo puede rendir una evaluación una vez.

El administrador puede crear, reiniciar o eliminar evaluaciones/intentos.

Registrar fecha y hora de inicio y fin del examen.

Los estudiantes solo pueden rendir las evaluaciones que se les asignen.

Registro del resultado del examen, estudiante, puntaje y respuestas marcadas.

📌 Actividades Desarrolladas
✅ Modelo relacional diseñado.

✅ Base de datos creada con tablas y relaciones adecuadas.

✅ Se insertaron datos:

10 estudiantes.

5 evaluaciones.

Cada evaluación con 5 preguntas, cada una con 4 alternativas (y su respuesta correcta).

4 estudiantes asignados a 3 exámenes.

3 estudiantes asignados a 2 exámenes distintos.

3 estudiantes sin asignaciones.

Registros simulados de evaluaciones, con al menos 2 desaprobados.

📊 Consultas Implementadas
Total de alumnos desaprobados.

Número de aprobados por curso.

Exámenes inscritos, resueltos y pendientes por alumno.

Mejor y peor calificación por evaluación.

Promedio de calificaciones por estudiante.

🛠️ Tecnologías Utilizadas
Base de Datos: PostgreSQL / MySQL (según implementación).

Frontend & Backend: No especificado, pero adaptable a tecnologías como PHP, Node.js, React, etc.

📂 Estructura de la Base de Datos
Incluye entidades como:

Alumno

Evaluacion

Pregunta

Alternativa

Asignacion

Intento

Respuesta

🧪 Consideraciones
Validación para evitar múltiples intentos por alumno.

Restricción de acceso solo a evaluaciones asignadas.

Cálculo de nota basado en respuestas correctas vs. puntaje total.

Almacenamiento histórico de evaluaciones rendidas.

