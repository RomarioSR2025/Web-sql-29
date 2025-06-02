# 📚 Sistema de Evaluaciones Web - Aprende Perú

> Aplicación para la gestión, asignación y desarrollo de evaluaciones online.  
> Proyecto académico para el Centro de Capacitación **Aprende Perú**.

---

## 📌 Objetivo del Proyecto

Diseñar una base de datos relacional que sirva como soporte para una aplicación web de evaluaciones cerradas. El sistema debe permitir al administrador crear y gestionar evaluaciones, asignarlas a estudiantes, y registrar los resultados obtenidos.

---

## ✅ Requerimientos Funcionales

1. 📂 Evaluaciones clasificadas por tipo/área.
2. ❌ Preguntas de tipo *cerradas* (solo alternativas, una correcta).
3. 📝 Cada pregunta tiene un puntaje asignado.
4. 🎯 Solo una respuesta válida por pregunta.
5. 🧮 Calificación vigesimal (escala sobre 20).
6. ⏱️ Evaluaciones con fecha inicio/fin y tiempo límite.
7. 🔒 Cada estudiante puede rendir una evaluación **una sola vez**.
8. 🔁 Administrador puede crear/reiniciar/eliminar intentos.
9. 🗓️ Registro de fecha y hora de inicio/fin del examen.
10. 🎓 Estudiantes solo ven evaluaciones asignadas.
11. 📊 Registro de resultados y respuestas marcadas.

---

## 🧱 Modelo Relacional
![Texto alternativo](/IMAGEN/EXAMEN.02.png)

# Construcción de Base de Datos

Este script crea un esquema de base de datos para gestionar evaluaciones, preguntas, estudiantes e intentos de respuesta. A continuación se presenta el código SQL que define todas las tablas necesarias:

```sql
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
    tiempo_duracion INT NOT NULL,
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
```

## 🧪 Población de Datos (Resumen)

### 👨‍🎓 Estudiantes
- 10 estudiantes registrados

### 📋 Evaluaciones
- 5 evaluaciones creadas
- Cada evaluación contiene:
  - 5 preguntas
  - Cada pregunta con 4 alternativas

### ✅ Preguntas
- 20 preguntas con respuestas correctas definidas

### 👥 Asignaciones
- 4 estudiantes → asignados a 3 evaluaciones cada uno
- 3 estudiantes → asignados a 2 evaluaciones distintas
- 3 estudiantes → sin asignación

### 🧾 Intentos Simulados
- 7 estudiantes realizaron intentos
- 2 estudiantes **desaprobaron**
