<?php
    class Database {
        private static $instance; // Instance unique de la classe
        private $conn;
        private $host = "localhost";
        private $dbname = "bf_tunisair";
        private $username = "root";
        private $password = "";
    
        // Constructeur privé pour empêcher la création d'instances multiples
        private function __construct() {
            $dsn = "mysql:host=$this->host;dbname=$this->dbname";
            $options = array(
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES UTF8"
            );
    
            try {
                $this->conn = new PDO($dsn, $this->username, $this->password, $options);
                $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            } catch (PDOException $e) {
                throw new Exception("Database connection error: " . $e->getMessage());
            }
        }
    
        // Méthode statique pour récupérer l'instance unique
        public static function getInstance() {
            if (self::$instance === null) {
                self::$instance = new self();
            }
            return self::$instance;
        }
    
        // Méthode pour obtenir la connexion à la base de données
        public function getConnection() {
            return $this->conn;
        }
    }
?>