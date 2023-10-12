<?php
if (!class_exists('Database')) {
    include "./utils/connect.php";
}
require_once "user_model.php";
require "./vendor/autoload.php";



use Dotenv\Dotenv;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;


class Reclamation{
    private $id;
    private $sujet;
    private $message;
    private $files;

    public function __construct(){}

    public function __constructTous($id,$sujet,$message,$files)
    {
        $this->id= $id;
        $this->sujet = $sujet;
        $this->message = $message;
        $this->files = $files;
    }

    public function addReclamation($matUser,$sujet,$message,$files,$accessToken){
        if($accessToken){
            try {
                // Vérifiez et décodez le JWT
                $dotenv = Dotenv::createImmutable(dirname(__DIR__));
                $dotenv->load();
                $secret_key = $_ENV['TOKEN_SECRET_KEY'];
                $decoded = JWT::decode($accessToken, new Key($secret_key, 'HS256'));
                // Le JWT est valide, vous pouvez accéder au contenu du payload
                if($decoded->matricule == intval($matUser)){
                    $db = Database::getInstance();
                    $conn= $db->getConnection();
                    $stmt = $conn->prepare("
                        insert into reclamation (sujet,text,user_mat)
                        values (? ,? ,?)
                        ");

                        $stmt->execute(array($sujet,$message,$matUser)) ;


                        $count = $stmt->rowCount();
                        $last_inserted_id = 0;
                        if($count > 0){
                            $last_inserted_id = $conn->lastInsertId();
                            if($files != null){
                                return $this->uploadFiles($files,$last_inserted_id);
                            }else{
                                return array("statusCode"=>"200","message"=>"Reclamation ajoutée avec succée");
                            }
                        }else{
                            return array("statusCode"=>"400","message"=>"Probléme serveur !");
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


    public function uploadFiles($files,$last_inserted_id){
        $db = Database::getInstance();
        $conn= $db->getConnection();
        $statusUpload = [] ; // il faux renvoyer un tableau contient la status de l'upload des fichiers échec(extention, size ...) ou succé.
        foreach ($files["name"] as $index => $name) {
            $type = $files["type"][$index];
            $tmp_name = $files["tmp_name"][$index];
            $error = $files["error"][$index];
            $size = $files["size"][$index];
        
            // Vous pouvez faire ce que vous voulez avec ces valeurs ici
            $imagename= $name;
            $imagetmp= $tmp_name;
            $imagesize= $size;
            $allowExt = array("jpg", "png" , "gif" ,  "pdf" , "mp3" , "mp4");
            $strToArray = explode("." , $imagename);
            $ext = end($strToArray);
            $ext = strtolower($ext);
            $filename = strval(random_int(1000 , 9999)).".".$ext;
            $verifUpload = true;
            if(!empty($imagename) && !in_array($ext , $allowExt)){
                $verifUpload = false;
                $statusUpload [] = array($name => "L'application ne supporte pas l'extention ".$ext);
            }

            if($imagesize > 3 * MB){
                $verifUpload = false;
                $statusUpload [] = array($name => "Fichier trop volumineux");
            }

            if($verifUpload){
                switch ($ext){
                    case 'jpg' : 
                        if(move_uploaded_file($imagetmp, "C:/wamp64/www/tunisair_api/assets/images/".$filename)){
                            $statusUpload [] = array($name => "success");
                        }else{
                            $statusUpload [] = array($name => "Problem server upload");
                        }
                        break;
                    case 'png' : 
                        if(move_uploaded_file($imagetmp, "C:/wamp64/www/tunisair_api/assets/images/".$filename)){
                            $statusUpload [] = array($name => "success");
                        }else{
                            $statusUpload [] = array($name => "Problem server upload");
                        }
                        break;
                    case 'gif' : 
                        if(move_uploaded_file($imagetmp, "C:/wamp64/www/tunisair_api/assets/images/".$filename)){
                            $statusUpload [] = array($name => "success");
                        }else{
                            $statusUpload [] = array($name => "Problem server upload");
                        }
                        break;
                    case 'pdf' :
                        if(move_uploaded_file($imagetmp, "C:/wamp64/www/tunisair_api/assets/file/".$filename)){
                            $statusUpload [] = array($name => "success");
                        }else{
                            $statusUpload [] = array($name => "Problem server upload");
                        }
                        break;
                    case 'mp3' : 
                        if(move_uploaded_file($imagetmp, "C:/wamp64/www/tunisair_api/assets/audio/".$filename)){
                            $statusUpload [] = array($name => "success");
                        }else{
                            $statusUpload [] = array($name => "Problem server upload");
                        }
                        break;
                    case 'mp4' :
                        if(move_uploaded_file($imagetmp, "C:/wamp64/www/tunisair_api/assets/audio/".$filename)){
                            $statusUpload [] = array($name => "success");
                        }else{
                            $statusUpload [] = array($name => "Problem server upload");
                        }
                    break;
                    default : $statusUpload [] = array($name => "fail");
                    break;
                }

                
                
                //add path to db
                $stmt = $conn->prepare("
                    insert into file_reclamation (path,id_reclamation)
                    values (? ,?)
                    ");

                $stmt->execute(array($filename,$last_inserted_id)) ;
            }
                
        }

        return $statusUpload;
    }


    public function getId(){
        return $this->id;
    }

    public function getSujet(){
        return $this->sujet;
    }

    public function getMessage(){
        return $this->message;
    }

    public function getFiles(){
        return $this->files;
    }



}

?>