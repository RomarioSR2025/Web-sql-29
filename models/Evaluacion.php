<?php
require_once __DIR__ . '/../config/Database.php';

class Evaluacion
{
    private $conn;
    private $table_name = "Evaluacion";

    // Propiedades de la tabla
    public $id_evaluacion;
    public $nombre;
    public $id_area;
    public $fecha_inicio;
    public $fecha_fin;
    public $tiempo_duracion;
    public $tipo;
    public $vigente;

    public function __construct()
    {
        $database = new Database();
        $this->conn = $database->getConnection();
    }

    // Crear nueva evaluación
    public function create()
    {
        $query = "INSERT INTO " . $this->table_name . " 
                  (nombre, id_area, fecha_inicio, fecha_fin, tiempo_duracion, tipo, vigente) 
                  VALUES 
                  (:nombre, :id_area, :fecha_inicio, :fecha_fin, :tiempo_duracion, :tipo, :vigente)";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->nombre = htmlspecialchars(strip_tags($this->nombre));
        $this->id_area = (int)$this->id_area;
        $this->fecha_inicio = htmlspecialchars(strip_tags($this->fecha_inicio));
        $this->fecha_fin = htmlspecialchars(strip_tags($this->fecha_fin));
        $this->tiempo_duracion = (int)$this->tiempo_duracion;
        $this->tipo = htmlspecialchars(strip_tags($this->tipo));
        $this->vigente = (int)$this->vigente;

        // Vincular parámetros
        $stmt->bindParam(":nombre", $this->nombre);
        $stmt->bindParam(":id_area", $this->id_area, PDO::PARAM_INT);
        $stmt->bindParam(":fecha_inicio", $this->fecha_inicio);
        $stmt->bindParam(":fecha_fin", $this->fecha_fin);
        $stmt->bindParam(":tiempo_duracion", $this->tiempo_duracion, PDO::PARAM_INT);
        $stmt->bindParam(":tipo", $this->tipo);
        $stmt->bindParam(":vigente", $this->vigente, PDO::PARAM_INT);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }

        return false;
    }

    // Obtener todas las evaluaciones
    public function getAll()
    {
        $query = "SELECT 
                    e.id_evaluacion,
                    e.nombre,
                    e.id_area,
                    a.nombre_area,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.tiempo_duracion,
                    e.tipo,
                    e.vigente
                  FROM " . $this->table_name . " e
                  LEFT JOIN Area a ON e.id_area = a.id_area
                  ORDER BY e.fecha_inicio DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener evaluación por ID
    public function getById($id_evaluacion)
    {
        $query = "SELECT 
                    e.id_evaluacion,
                    e.nombre,
                    e.id_area,
                    a.nombre_area,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.tiempo_duracion,
                    e.tipo,
                    e.vigente
                  FROM " . $this->table_name . " e
                  LEFT JOIN Area a ON e.id_area = a.id_area
                  WHERE e.id_evaluacion = :id_evaluacion";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_evaluacion", $id_evaluacion, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Obtener evaluaciones por área
    public function getByArea($id_area)
    {
        $query = "SELECT 
                    e.id_evaluacion,
                    e.nombre,
                    e.id_area,
                    a.nombre_area,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.tiempo_duracion,
                    e.tipo,
                    e.vigente
                  FROM " . $this->table_name . " e
                  LEFT JOIN Area a ON e.id_area = a.id_area
                  WHERE e.id_area = :id_area
                  ORDER BY e.fecha_inicio DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_area", $id_area, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}

?>