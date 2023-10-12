class RespponseModel {
   String? statusCode;
   String? message;

  RespponseModel(
      this.statusCode,
      this.message
  );

  RespponseModel.three({this.statusCode,this.message});

  factory RespponseModel.fromJson(dynamic json){
    return RespponseModel.three(
      statusCode : json['statusCode'].toString(), 
      message : json['message'],
    );
  }
}