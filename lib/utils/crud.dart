import 'package:http/http.dart' as http;
import 'dart:convert';

class Crud {

  //get request
  getRequest(String url, String accessToken) async{
    try{
      var response ;
      if(accessToken.isEmpty){
        response =await http.get(Uri.parse(url));
      }else{
        response =await http.get(Uri.parse(url),headers: {
          'Authorization': 'Bearer $accessToken',
        },);
      }
      
      if(response.statusCode == 200){
        var responsebody = jsonDecode(response.body);
        return responsebody;
      }else{
        print("Error ${response.statusCode}");
      }
    }catch(e){
      print("Error catch $e");
    }
  }

  //post request
  postRequest(String url, Map data) async{
    try{
      var response =await http.post(Uri.parse(url),body: data);
      if(response.statusCode == 200){
        var responsebody = jsonDecode(response.body);
        return responsebody;
      }else{
        print("Error ${response.statusCode}");
      }
    }catch(e){
      print("Error catch $e");
    }
  }


  //post request with token
  postRequestToken(String url, Map data, String accessToken) async{
    try{
      var response =await http.post(Uri.parse(url),body: data,headers: {
          'Authorization': 'Bearer $accessToken',
        },);
      if(response.statusCode == 200){
        var responsebody = jsonDecode(response.body);
        return responsebody;
      }else{
        print("Error ${response.statusCode}");
      }
    }catch(e){
      print("Error catch $e");
    }
  }


  //delete request
  deleteRequest(String url ,String accessToken) async{
    try{
      var response =await http.delete(Uri.parse(url) , headers: {
        'Authorization': 'Bearer $accessToken', // Ajoutez le jeton d'accès ici
      },);
      if(response.statusCode == 200){
        var responsebody = jsonDecode(response.body);
        return responsebody;
      }else{
        print("Error ${response.statusCode}");
      }
    }catch(e){
      print("Error catch $e");
    }
  }


  //put request
  putRequest(String url, Map data, String accessToken) async{
    try{
      var response =await http.put(Uri.parse(url),body: jsonEncode(data), headers: {
        'Authorization': 'Bearer $accessToken', // Ajoutez le jeton d'accès ici
      });
      if(response.statusCode == 200){
        var responsebody = jsonDecode(response.body);
        return responsebody;
      }else{
        print("Error ${response.statusCode}");
      }
    }catch(e){
      print("Error catch $e");
    }
  }
}