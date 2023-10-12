<?php

require_once "./model/auth_model.php";
require_once "./model/user_model.php";
require_once "./model/reclamation_model.php";
define('MB', 1048576);


// Récupérer la méthode HTTP (GET, POST, PUT, DELETE)
$method = $_SERVER['REQUEST_METHOD'];

// Récupérer l'URL demandée
$request = $_SERVER['REQUEST_URI'];

// Diviser l'URL en parties
$requestParts = explode('/', $request);

// Récupérer dernière partie de l'URL
$uri = end($requestParts);

$endpoint = "";

if (strpos($uri, "?") !== false) {
    //Diviser l'Uri en partie (?) pour tester si il y a des query params
    $uriParts = explode('?',$uri);
    //Définir l'endponit
    $endpoint = $uriParts[0];
} else {
    $endpoint = $uri;
}


$authModel = new Auth();
$userModel = new User();
$reclamationModel = new Reclamation();
// Routes
switch($endpoint){
    //login
    case 'login' :{
        switch ($method) {
            case 'POST':
                $response = $authModel->login(filterRequest("matricule"),filterRequest("password"));
                echo json_encode($response);
                break;
            default:
                http_response_code(405); // Méthode non autorisée
                echo json_encode(array('message' => 'Méthode non autorisée'));
                break;
        }
        break; 
    }
    //register
    case "register" : {
        switch ($method) {
            case 'POST':
                // Récupérez le JWT de la requête HTTP
                $jwt = null;
                $authHeader = $_SERVER['HTTP_AUTHORIZATION'];

                if (!empty($authHeader)) {
                    $bearerToken = explode(' ', $authHeader);
                    $jwt = $bearerToken[1];
                }

                $nom = filterRequest("nom");
                $prenom = filterRequest("prenom");
                $cin = filterRequest("cin");
                $tel = filterRequest("tel");
                $email = filterRequest("email");
                $password = filterRequest("password");
                $matricule = filterRequest("matricule");
                $role = filterRequest("role");
                $filename = $nom.substr($cin,5);
                $nameimage = imageUpload("image",$filename);
                $user= new User();
                $user->__constructRegister($matricule,$password,$nameimage,$cin,$tel,$email,$prenom,$nom,$role);
                $response = $authModel->register($user,$jwt);
                echo json_encode($response);
                break;
            default:
                http_response_code(405); // Méthode non autorisée
                echo json_encode(array('statusCode'=>"405",'message' => 'Méthode non autorisée'));
                break;
        }
        break;
    }
    //user
    case 'user' :{
        switch ($method) {
            case 'GET':
                $jwt = null;
                $authHeader = $_SERVER['HTTP_AUTHORIZATION'];

                if (!empty($authHeader)) {
                    $bearerToken = explode(' ', $authHeader);
                    $jwt = $bearerToken[1];
                }
                $nom = isset($_GET['nom_user']) ? $_GET['nom_user'] : null;
                if($nom !== null){
                    $response = $userModel->findUsers($jwt,$nom);
                }else{
                    $response = $userModel->getAllUsers($jwt);
                }
                echo json_encode($response);
                break;
            case "DELETE":
                $jwt = null;
                $authHeader = $_SERVER['HTTP_AUTHORIZATION'];
    
                if (!empty($authHeader)) {
                    $bearerToken = explode(' ', $authHeader);
                    $jwt = $bearerToken[1];
                }
                $id_user = intval(isset($_GET['id_user']) ? $_GET['id_user'] : null);
                $response = $userModel->deleteUser($jwt,$id_user);
                echo json_encode($response);
                break;
            case "PUT":
                $jwt = null;
                $authHeader = $_SERVER['HTTP_AUTHORIZATION'];
        
                if (!empty($authHeader)) {
                    $bearerToken = explode(' ', $authHeader);
                    $jwt = $bearerToken[1];
                }
                $input = file_get_contents("php://input");
                $data = json_decode($input);
                $nom = $data->nom;
                $prenom = $data->prenom;
                $tel = $data->tel;
                $mat = $data->matricule;
                $response = $userModel->editUser($jwt,$nom,$prenom,$tel,$mat);
                echo json_encode($response);
                break;
            default:
                http_response_code(405); // Méthode non autorisée
                echo json_encode(array('message' => 'Méthode non autorisée'));
                break;
        }
        break; 
    }
    //update image
    case "update_profile_image" :{
        if($method == "POST"){
            $jwt = null;
                $authHeader = $_SERVER['HTTP_AUTHORIZATION'];
            
                if (!empty($authHeader)) {
                    $bearerToken = explode(' ', $authHeader);
                    $jwt = $bearerToken[1];
                }
                $nom = filterRequest("nom");
                $imageAncien = filterRequest("imageAncien");
                $cin = filterRequest("cin");
                $matricule = filterRequest("matricule");
                $filename = "";
                $nameimage = "";
                //supprimer l'image ancienne
                $repertoireCourant = getcwd();
                $nomFichier = $repertoireCourant.'/assets/images/'.$imageAncien;
                // Vérifiez si le fichier existe
                if (file_exists($nomFichier)) {
                    // Supprimez le fichier
                    unlink($nomFichier);
                    $filename = $nom.substr($cin,5);
                    $nameimage = imageUpload("image",$filename);
                } else {
                    $filename = $nom.substr($cin,0);
                    $nameimage = imageUpload("image",$filename);
                }
                //end 
                $mat = $matricule;
                $response = $userModel->updateImageUser($jwt,$mat,$nameimage);
                echo json_encode($response);
                
        }
        break;
    }
    //update image
    case "change_password" :{
        if($method == "POST"){
            $jwt = null;
                $authHeader = $_SERVER['HTTP_AUTHORIZATION'];
            
                if (!empty($authHeader)) {
                    $bearerToken = explode(' ', $authHeader);
                    $jwt = $bearerToken[1];
                }
                $new = filterRequest("new_password");
                $old_pwd = filterRequest("old_password");
                $matricule = filterRequest("matricule");               
                $response = $userModel->changePassword($jwt,$new,$old_pwd,$matricule);
                echo json_encode($response);      
        }
        break;
    }
    //reclamation
    case "reclamation" : {
        switch ($method) {
            case 'POST':
                // Récupérez le JWT de la requête HTTP
                $jwt = null;
                $authHeader = $_SERVER['HTTP_AUTHORIZATION'];

                if (!empty($authHeader)) {
                    $bearerToken = explode(' ', $authHeader);
                    $jwt = $bearerToken[1];
                }

                $sujet = filterRequest("sujet");
                $text = filterRequest("text");
                $mat_user =intval(filterRequest("matricule_user")) ;
                $files = null;
                if(isset($_FILES['files'])){
                    $files = $_FILES['files'];
                }
                $response = $reclamationModel->addReclamation($mat_user,$sujet,$text,$files,$jwt);
                echo json_encode($response);
                break;
            default:
                http_response_code(405); // Méthode non autorisée
                echo json_encode(array('message' => 'Méthode non autorisée'));
                break;
        }
        break;
    }
    //notfound
    default:{
        // Endpoint non trouvé
        http_response_code(404); // Ressource non trouvée
        echo json_encode(array('statusCode'=>404 ,'message' => 'NOT_FOUND'));
    }
}



function filterRequest($requestname){
    if(isset($_POST[$requestname])) {
        return $_POST[$requestname];
    } else {
        return 'null'; // Ou une valeur par défaut appropriée si la clé n'est pas définie
    }
}

function imageUpload($imageRequest, $new_filename){

    global $msgError;
    $imagename= $_FILES[$imageRequest]['name'];
    $imagetmp= $_FILES[$imageRequest]['tmp_name'];
    $imagesize= $_FILES[$imageRequest]['size'];
    $allowExt = array("jpg", "png" , "gif" );
    $strToArray = explode("." , $imagename);
    $ext = end($strToArray);
    $ext = strtolower($ext);
    $new_filename = $new_filename.".".$ext;
    if(!empty($imagename) && !in_array($ext , $allowExt)){
        $msgError[] = "Ext";
    }

    if($imagesize > 2 * MB){
        $msgError = "size" ;
    }

    if(empty($msgError)){
        move_uploaded_file($imagetmp, "C:/wamp64/www/tunisair_api/assets/images/".$new_filename);
        return $new_filename;
    }else{
        return $imageRequest;
    }
    
}
?>