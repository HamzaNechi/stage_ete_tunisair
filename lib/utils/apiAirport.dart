import 'package:http/http.dart' as http;
import 'dart:convert';


// class Airport{
//   {isActive: true,
//    AirportName: Achutupo Airport, 
//    city: Achutupo, country: Panama, 
//    AirportCode: ACU, 
//    citycode: null, 
//    lat: 9.2, 
//    long: -77.98, 
//    timzone: -5, 
//    cityunicode: U, 
//    zone: America/Panama, 
//    CountryCode: 
//    PA, 
//    id: 61e07352e2f371d6f4906ad6
// }

class AirportApi{


  Future<void> fetchAirport(String key) async{

    var url = Uri.parse("https://world-airports-directory.p.rapidapi.com/v1/airports/$key?page=1&limit=20&sortBy=city%3Aasc");
    var headers ={
      "X-RapidAPI-Host" : "world-airports-directory.p.rapidapi.com",
      "X-RapidAPI-Key" : "2f41b0ca1dmsh71f33c5a756a669p1a159ajsn52c538eb81ba"
    };

    try{
      var response =await http.get(url, headers: headers);
      
      if(response.statusCode == 200){
        //var responsebody = jsonDecode(response.body);
        if(response.body.isNotEmpty){
          List<dynamic> data = jsonDecode(response.body);

          for(var item in data){
            print(item['AirportName']);
          }
        }
        //return responsebody ;
      }else{
        print("Error ${response.statusCode}");
      }
    }catch(e){
      print("Error catch $e");
    }
  }



}