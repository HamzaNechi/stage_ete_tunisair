<?php
if (!class_exists('Database')) {
    include "./utils/connect.php";
}
require "./vendor/autoload.php";



use Dotenv\Dotenv;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class User{
    private $id ;
    private $nom;
    private $prenom;
    private $email;
    private $tel;
    private $cin;
    private $image;
    private $role;
    private $mat;
    private $password;


    public function __construct() {
        // Code du constructeur par défaut ici
    }

    public function __constructRegister($mat, $password ,$image,$cin,$tel,$email,$prenom,$nom,$role){
        $this->mat= $mat;
        $this->password = $password;
        $this->image = $image;
        $this->cin= $cin;
        $this->tel = $tel;
        $this->email= $email;
        $this->prenom = $prenom;
        $this->nom= $nom;
        $this->role = $role;
    }

    

    public function fetchUser($matricule){
        $db = Database::getInstance();
        $conn= $db->getConnection();
        $stmt = $conn->prepare("SELECT * from users where matricule = ?");
        $stmt->execute(array($matricule)) ;
        $data = $stmt->fetch(PDO::FETCH_ASSOC);
        $count = $stmt->rowCount();
        if($count > 0){
            return $data;
        }else{
            return null;
        }
    }

    public function getAllUsers($accessToken){
        if($accessToken){
            try {
                // Vérifiez et décodez le JWT
                $dotenv = Dotenv::createImmutable(dirname(__DIR__));
                $dotenv->load();
                $secret_key = $_ENV['TOKEN_SECRET_KEY'];
                $decoded = JWT::decode($accessToken, new Key($secret_key, 'HS256'));
                // Le JWT est valide, vous pouvez accéder au contenu du payload
                if($decoded->role == "admin"){
                    $db = Database::getInstance();
                    $conn= $db->getConnection();
                    $stmt = $conn->prepare("SELECT * from users");

                    $stmt->execute() ;

                    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    $count = $stmt->rowCount();

                    if($count > 0){
                        return array("statusCode"=>200,"message"=>"Liste des utilisateurs","data" => $data);
                    }else{
                        return array("statusCode"=>400,"message"=>"Probléme serveur !");
                    }
                }
            
            } catch (Firebase\JWT\ExpiredException $e) {
                // Le JWT est expiré
                return array("statusCode"=>"400","message"=>"Jeton expiré");
            }catch (Exception $e) {
                // Le JWT n'est pas valide
                return array("statusCode"=>"402","message"=>"error". $e->getMessage());
            }
        }else{
            return array("statusCode"=>"400","message"=>"Tu n'a pas autorisé pour cette action");
        }
    }

    public function findUsers($accessToken , $nom){
        if($accessToken){
            try {
                // Vérifiez et décodez le JWT
                $dotenv = Dotenv::createImmutable(dirname(__DIR__));
                $dotenv->load();
                $secret_key = $_ENV['TOKEN_SECRET_KEY'];
                $decoded = JWT::decode($accessToken, new Key($secret_key, 'HS256'));
                // Le JWT est valide, vous pouvez accéder au contenu du payload
                if($decoded->role == "admin"){
                    $db = Database::getInstance();
                    $conn= $db->getConnection();
                    $pathParam = '%'.$nom.'%';
                    $stmt = $conn->prepare("SELECT * from users where nom  LIKE :nom_user OR prenom LIKE :nom_user");

                    $stmt->bindParam(':nom_user', $pathParam, PDO::PARAM_STR);

                    $stmt->execute() ;

                    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    $count = $stmt->rowCount();

                    if($count > 0){
                        return array("statusCode"=>200,"message"=>"Liste des utilisateurs recherché","data" => $data);
                    }else{
                        return array("statusCode"=>400,"message"=>$nom);
                    }
                }
            
            } catch (Firebase\JWT\ExpiredException $e) {
                // Le JWT est expiré
                return array("statusCode"=>"400","message"=>"Jeton expiré");
            }catch (Exception $e) {
                // Le JWT n'est pas valide
                return array("statusCode"=>"402","message"=>"error". $e->getMessage());
            }
        }else{
            return array("statusCode"=>"400","message"=>"Tu n'a pas autorisé pour cette action");
        }
        
    }

    public function deleteUser($accessToken , $id_user){
        if($accessToken){
            try {
                // Vérifiez et décodez le JWT
                $dotenv = Dotenv::createImmutable(dirname(__DIR__));
                $dotenv->load();
                $secret_key = $_ENV['TOKEN_SECRET_KEY'];
                $decoded = JWT::decode($accessToken, new Key($secret_key, 'HS256'));
                // Le JWT est valide, vous pouvez accéder au contenu du payload
                if($decoded->role == "admin"){
                    $db = Database::getInstance();
                    $conn= $db->getConnection();
                    $stmt = $conn->prepare("DELETE FROM users WHERE id = :id_user");
                    $stmt->bindParam(':id_user', $id_user, PDO::PARAM_INT);
                    if($stmt->execute()){
                        return array("statusCode"=>200,"message"=>"Utilisateur supprimé avec succès.");
                    }else{
                        return array("statusCode"=>400,"message"=>"Erreur lors de la suppression de l'utilisateur.");
                    }
                }
            
            } catch (Firebase\JWT\ExpiredException $e) {
                // Le JWT est expiré
                return array("statusCode"=>"400","message"=>"Jeton expiré");
            }catch (Exception $e) {
                // Le JWT n'est pas valide
                return array("statusCode"=>"402","message"=>"error". $e->getMessage());
            }
        }else{
            return array("statusCode"=>"400","message"=>"Tu n'a pas autorisé pour cette action");
        }
        
    }


    public function editUser($accessToken , $nom ,$prenom,$tel, $mat){
        if($accessToken){
            try {
                // Vérifiez et décodez le JWT
                $dotenv = Dotenv::createImmutable(dirname(__DIR__));
                $dotenv->load();
                $secret_key = $_ENV['TOKEN_SECRET_KEY'];
                $decoded = JWT::decode($accessToken, new Key($secret_key, 'HS256'));
                // Le JWT est valide, vous pouvez accéder au contenu du payload
                if(intval($decoded->matricule) == intval($mat)){
                    //user qui fais l'action == user connecté == user a modifié => action vérifié
                    $db = Database::getInstance();
                    $conn= $db->getConnection();
                    $stmt = $conn->prepare("UPDATE users SET nom= :nom , prenom= :prenom, tel = :tel WHERE matricule = :matricule");
                    $stmt->bindParam(':matricule', $mat, PDO::PARAM_INT);
                    $stmt->bindParam(':nom', $nom, PDO::PARAM_STR);
                    $stmt->bindParam(':prenom', $prenom, PDO::PARAM_STR);
                    $stmt->bindParam(':tel', $tel, PDO::PARAM_STR);
                    if($stmt->execute()){
                        return array("statusCode"=>200,"message"=>"Utilisateur mis à jour avec succès.");
                    }else{
                        return array("statusCode"=>400,"message"=>"Erreur lors de la mise à jour de l'utilisateur.");
                    }
                }else{
                    return array("statusCode"=>400,"message"=>"Vous n'avez pas l'autorisation de mettre à jour cet utilisateur.");
                }
            
            } catch (Firebase\JWT\ExpiredException $e) {
                // Le JWT est expiré
                return array("statusCode"=>400,"message"=>"Jeton expiré");
            }catch (Exception $e) {
                // Le JWT n'est pas valide
                return array("statusCode"=>402,"message"=>"error". $e->getMessage());
            }
        }else{
            return array("statusCode"=>400,"message"=>"Tu n'a pas autorisé pour cette action");
        }
        
    }


    public function changePassword($accessToken,$new,$old,$matricule){
        if($accessToken){
            try {
                // Vérifiez et décodez le JWT
                $dotenv = Dotenv::createImmutable(dirname(__DIR__));
                $dotenv->load();
                $secret_key = $_ENV['TOKEN_SECRET_KEY'];
                $decoded = JWT::decode($accessToken, new Key($secret_key, 'HS256'));
                // Le JWT est valide, vous pouvez accéder au contenu du payload
                if(intval($decoded->matricule) == intval($matricule)){
                    //user qui fais l'action == user connecté == user a modifié => action vérifié
                    $userModel = new User();
                    $user = $userModel->fetchUser($matricule);
                    if(password_verify($old, $user['password'])){
                        $db = Database::getInstance();
                        $conn= $db->getConnection();
                        $hashedPassword = password_hash($new, PASSWORD_BCRYPT);
                        $stmt = $conn->prepare("UPDATE users SET password= :password WHERE matricule = :matricule");
                        $stmt->bindParam(':password', $hashedPassword, PDO::PARAM_STR);
                        $stmt->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                        if($stmt->execute()){
                            return array("statusCode"=>200,"message"=>"Mot de passe mis à jour avec succès.");
                        }else{
                            return array("statusCode"=>400,"message"=>"Erreur lors de la mise à jour de la mot de passe.");
                        }
                    }else{
                        return array("statusCode"=>400,"message"=>"Ancien mot de passe incorrecte !");
                    }
                    
                }else{
                    return array("statusCode"=>400,"message"=>"Vous n'avez pas l'autorisation de mettre à jour cet utilisateur.");
                }
            
            } catch (Firebase\JWT\ExpiredException $e) {
                // Le JWT est expiré
                return array("statusCode"=>400,"message"=>"Jeton expiré");
            }catch (Exception $e) {
                // Le JWT n'est pas valide
                return array("statusCode"=>402,"message"=>"error". $e->getMessage());
            }
        }else{
            return array("statusCode"=>400,"message"=>"Tu n'a pas autorisé pour cette action");
        }
    }


    public function updateImageUser($accessToken,$mat,$imageName){
        if($accessToken){
            try {
                // Vérifiez et décodez le JWT
                $dotenv = Dotenv::createImmutable(dirname(__DIR__));
                $dotenv->load();
                $secret_key = $_ENV['TOKEN_SECRET_KEY'];
                $decoded = JWT::decode($accessToken, new Key($secret_key, 'HS256'));
                // Le JWT est valide, vous pouvez accéder au contenu du payload
                if(intval($decoded->matricule) == intval($mat)){
                    //user qui fais l'action == user connecté == user a modifié => action vérifié
                    $db = Database::getInstance();
                    $conn= $db->getConnection();
                    $stmt = $conn->prepare("UPDATE users SET image= :image WHERE matricule = :matricule");
                    $stmt->bindParam(':matricule', $mat, PDO::PARAM_INT);
                    $stmt->bindParam(':image', $imageName, PDO::PARAM_STR);
                    if($stmt->execute()){
                        return array("statusCode"=>200,"message"=>"Image mis à jour avec succès.","data" => $imageName);
                    }else{
                        return array("statusCode"=>400,"message"=>"Erreur lors de la mise à jour de l'image.");
                    }
                }else{
                    return array("statusCode"=>400,"message"=>"Vous n'avez pas l'autorisation de mettre à jour cet utilisateur.");
                }
            
            } catch (Firebase\JWT\ExpiredException $e) {
                // Le JWT est expiré
                return array("statusCode"=>400,"message"=>"Jeton expiré");
            }catch (Exception $e) {
                // Le JWT n'est pas valide
                return array("statusCode"=>402,"message"=>"error". $e->getMessage());
            }
        }else{
            return array("statusCode"=>400,"message"=>"Tu n'a pas autorisé pour cette action");
        }
    }


    public function getId(){
        return $this->id;
    }

    public function getNom(){
        return $this->nom;
    }

    public function getPrenom(){
        return $this->prenom;
    }

    public function getMatricule(){
        return $this->mat;
    }

    public function getPassword(){
        return $this->password;
    }

    public function getEmail(){
        return $this->email;
    }


    public function getCin(){
        return $this->cin;
    }

    public function getTel(){
        return $this->tel;
    }

    public function getImage(){
        return $this->image;
    }

    public function getRole(){
        return $this->role;
    }
}

?>