import 'package:file_picker/file_picker.dart';

class Reclamation {
   String? idUser;
   String? sujet;
   String? text;
   List<PlatformFile>? files;

  Reclamation(
      this.idUser,
      this.sujet,
      this.text,
      this.files
  );

  Reclamation.three({this.idUser,this.sujet,this.text,this.files});

  factory Reclamation.fromJson(dynamic json){
    return Reclamation.three(
      idUser : json['idUser'], 
      sujet : json['sujet'], 
      text : json['text'],
      files : json['files'],
      );
  }


  Map toJson() => {
        'matricule_user': this.idUser,
        'sujet': this.sujet,
        'text': this.text,
      };
}