<?php
if (!class_exists('Database')) {
    include "./utils/connect.php";
}
require_once "user_model.php";
require "./vendor/autoload.php";



use Dotenv\Dotenv;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// Spécifiez le chemin vers votre fichier .env

class Auth {

    private $mat;
    private $password;

    

    public function __construct(){
    }

    public function __constructAuth($mat, $password){
        $this->mat= $mat;
        $this->password = $password;
    }

    public function login($mat,$pass){
        $userModel = new User();
        $user = $userModel->fetchUser($mat);
        if($user != null){
            if(password_verify($pass, $user['password'])){
                $dotenv = Dotenv::createImmutable(dirname(__DIR__));
                $dotenv->load();
                $secret_key = $_ENV['TOKEN_SECRET_KEY'];
                $jwt = JWT::encode($user, $secret_key,'HS256');
                return array("statusCode"=>200,"message"=>"utilisateur authentifier","data" => $jwt);
            }else{
                return array("statusCode"=>400,"message"=>"Mot de passe incorrecte !");
            }
            
        }else{
            return array("statusCode"=>400,"message"=>"Matricule incorrecte !");
        }
        
    }



    public function register($user, $accessToken){
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
                    $hashedPassword = password_hash($user->getPassword(), PASSWORD_BCRYPT);
                    $stmt = $conn->prepare("insert into users (nom,prenom,email,password,tel,matricule,cin,image,role) values (? ,? ,?,?,?,?,?,?,?)");
                    $stmt->execute(array($user->getNom(),$user->getPrenom(),$user->getEmail(),$hashedPassword,$user->getTel(),$user->getMatricule(),$user->getCin(),$user->getImage(), $user->getRole())) ;
                    $count = $stmt->rowCount();

                    if($count > 0){
                        return array("statusCode"=>201,"message"=>"utilisateur créé avec succé");
                    }else{
                        return array("statusCode"=>400,"message"=>"Probléme serveur !");
                    }
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
}

?>