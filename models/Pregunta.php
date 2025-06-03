<?php
require_once __DIR__ . '/../config/Database.php';

class Pregunta
{
    private $conn;
    private $table_name = "Pregunta";

    // Propiedades de la tabla
    public $id_pregunta;
    public $id_evaluacion;
    public $enunciado;
    public $puntaje;

    public function __construct()
    {
        $database = new Database();
        $this->conn = $database->getConnection();
    }

    // Crear nueva pregunta
    public function create()
    {
        $query = "INSERT INTO " . $this->table_name . " 
                  (id_evaluacion, enunciado, puntaje) 
                  VALUES 
                  (:id_evaluacion, :enunciado, :puntaje)";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->id_evaluacion = (int)$this->id_evaluacion;
        $this->enunciado = htmlspecialchars(strip_tags($this->enunciado));
        $this->puntaje = (int)$this->puntaje;

        // Vincular parámetros
        $stmt->bindParam(":id_evaluacion", $this->id_evaluacion, PDO::PARAM_INT);
        $stmt->bindParam(":enunciado", $this->enunciado);
        $stmt->bindParam(":puntaje", $this->puntaje, PDO::PARAM_INT);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }

        return false;
    }

    // Obtener todas las preguntas
    public function getAll()
    {
        $query = "SELECT 
                    p.id_pregunta,
                    p.id_evaluacion,
                    e.nombre AS evaluacion_nombre,
                    p.enunciado,
                    p.puntaje
                  FROM " . $this->table_name . " p
                  LEFT JOIN Evaluacion e ON p.id_evaluacion = e.id_evaluacion
                  ORDER BY p.id_evaluacion, p.id_pregunta ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener pregunta por ID
    public function getById($id_pregunta)
    {
        $query = "SELECT 
                    p.id_pregunta,
                    p.id_evaluacion,
                    e.nombre AS evaluacion_nombre,
                    p.enunciado,
                    p.puntaje
                  FROM " . $this->table_name . " p
                  LEFT JOIN Evaluacion e ON p.id_evaluacion = e.id_evaluacion
                  WHERE p.id_pregunta = :id_pregunta";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_pregunta", $id_pregunta, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Obtener preguntas por evaluación
    public function getByEvaluacion($id_evaluacion)
    {
        $query = "SELECT 
                    p.id_pregunta,
                    p.id_evaluacion,
                    e.nombre AS evaluacion_nombre,
                    p.enunciado,
                    p.puntaje
                  FROM " . $this->table_name . " p
                  LEFT JOIN Evaluacion e ON p.id_evaluacion = e.id_evaluacion
                  WHERE p.id_evaluacion = :id_evaluacion
                  ORDER BY p.id_pregunta ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_evaluacion", $id_evaluacion, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener preguntas con sus alternativas
    public function getWithAlternativas($id_evaluacion)
    {
        $query = "SELECT 
                    p.id_pregunta,
                    p.id_evaluacion,
                    p.enunciado,
                    p.puntaje,
                    a.id_alternativa,
                    a.texto,
                    a.es_correcta
                  FROM " . $this->table_name . " p
                  LEFT JOIN Alternativa a ON p.id_pregunta = a.id_pregunta
                  WHERE p.id_evaluacion = :id_evaluacion
                  ORDER BY p.id_pregunta ASC, a.id_alternativa ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_evaluacion", $id_evaluacion, PDO::PARAM_INT);
        $stmt->execute();

        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Agrupar alternativas por pregunta
        $preguntas = [];
        foreach ($results as $row) {
            $pregunta_id = $row['id_pregunta'];

            if (!isset($preguntas[$pregunta_id])) {
                $preguntas[$pregunta_id] = [
                    'id_pregunta' => $row['id_pregunta'],
                    'id_evaluacion' => $row['id_evaluacion'],
                    'enunciado' => $row['enunciado'],
                    'puntaje' => $row['puntaje'],
                    'alternativas' => []
                ];
            }

            if ($row['id_alternativa']) {
                $preguntas[$pregunta_id]['alternativas'][] = [
                    'id_alternativa' => $row['id_alternativa'],
                    'texto' => $row['texto'],
                    'es_correcta' => $row['es_correcta']
                ];
            }
        }

        return array_values($preguntas);
    }
}

?>