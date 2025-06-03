-- Consultas para el sistema de evaluaciones
<?php
require_once __DIR__ . '/../config/Database.php';

class Alternativa
{
    private $conn;
    private $table_name = "Alternativa";

    // Propiedades de la tabla
    public $id_alternativa;
    public $id_pregunta;
    public $texto;
    public $es_correcta;

    public function __construct()
    {
        $database = new Database();
        $this->conn = $database->getConnection();
    }

    // Crear nueva alternativa
    public function create()
    {
        $query = "INSERT INTO " . $this->table_name . " 
                  (id_pregunta, texto, es_correcta) 
                  VALUES 
                  (:id_pregunta, :texto, :es_correcta)";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->id_pregunta = htmlspecialchars(strip_tags($this->id_pregunta));
        $this->texto = htmlspecialchars(strip_tags($this->texto));
        $this->es_correcta = (int)$this->es_correcta;

        // Vincular parámetros
        $stmt->bindParam(":id_pregunta", $this->id_pregunta);
        $stmt->bindParam(":texto", $this->texto);
        $stmt->bindParam(":es_correcta", $this->es_correcta, PDO::PARAM_INT);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }

        return false;
    }

    // Obtener todas las alternativas
    public function getAll()
    {
        $query = "SELECT 
                    a.id_alternativa,
                    a.id_pregunta,
                    p.enunciado AS texto_pregunta,
                    a.texto,
                    a.es_correcta
                  FROM " . $this->table_name . " a
                  LEFT JOIN Pregunta p ON a.id_pregunta = p.id_pregunta
                  ORDER BY a.id_pregunta, a.id_alternativa ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener alternativa por ID
    public function getById($id)
    {
        $query = "SELECT 
                    a.id_alternativa,
                    a.id_pregunta,
                    p.enunciado AS texto_pregunta,
                    a.texto,
                    a.es_correcta
                  FROM " . $this->table_name . " a
                  LEFT JOIN Pregunta p ON a.id_pregunta = p.id_pregunta
                  WHERE a.id_alternativa = :id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Obtener alternativas por pregunta
    public function getByPregunta($id_pregunta)
    {
        $query = "SELECT 
                    a.id_alternativa,
                    a.id_pregunta,
                    p.enunciado AS texto_pregunta,
                    a.texto,
                    a.es_correcta
                  FROM " . $this->table_name . " a
                  LEFT JOIN Pregunta p ON a.id_pregunta = p.id_pregunta
                  WHERE a.id_pregunta = :id_pregunta
                  ORDER BY a.id_alternativa ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_pregunta", $id_pregunta, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener alternativas correctas por pregunta
    public function getCorrectasByPregunta($id_pregunta)
    {
        $query = "SELECT 
                    a.id_alternativa,
                    a.id_pregunta,
                    p.enunciado AS texto_pregunta,
                    a.texto,
                    a.es_correcta
                  FROM " . $this->table_name . " a
                  LEFT JOIN Pregunta p ON a.id_pregunta = p.id_pregunta
                  WHERE a.id_pregunta = :id_pregunta AND a.es_correcta = 1
                  ORDER BY a.id_alternativa ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_pregunta", $id_pregunta, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Crear múltiples alternativas para una pregunta
    public function createMultiple($alternativas)
    {
        try {
            $this->conn->beginTransaction();

            $query = "INSERT INTO " . $this->table_name . " 
                      (id_pregunta, texto, es_correcta) 
                      VALUES 
                      (:id_pregunta, :texto, :es_correcta)";

            $stmt = $this->conn->prepare($query);

            $inserted_ids = [];

            foreach ($alternativas as $alternativa) {
                $stmt->bindParam(":id_pregunta", $alternativa['id_pregunta'], PDO::PARAM_INT);
                $stmt->bindParam(":texto", $alternativa['texto']);
                $stmt->bindParam(":es_correcta", $alternativa['es_correcta'], PDO::PARAM_INT);

                if ($stmt->execute()) {
                    $inserted_ids[] = $this->conn->lastInsertId();
                } else {
                    throw new Exception("Error al insertar alternativa");
                }
            }

            $this->conn->commit();
            return $inserted_ids;
        } catch (Exception $e) {
            $this->conn->rollBack();
            return false;
        }
    }

    // Validar que exista al menos una alternativa correcta
    public function validateCorrectAnswers($id_pregunta)
    {
        $query = "SELECT COUNT(*) as total_correctas 
                  FROM " . $this->table_name . " 
                  WHERE id_pregunta = :id_pregunta AND es_correcta = 1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_pregunta", $id_pregunta, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['total_correctas'] > 0;
    }
}
?>