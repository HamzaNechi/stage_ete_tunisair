
class User {
   int? id;
   String? nom;
   String? prenom;
   String? email;
   String? tel;
   int? matricule;
   String? cin;
   String? image;
   String? role;


  User(
      this.id,
      this.nom,
      this.prenom,
      this.email,
      this.tel,
      this.matricule,
      this.cin,
      this.image,
      this.role
  );

  User.three({this.id,this.nom,this.prenom});

  factory User.fromJson(dynamic json){
    return User.three(
      id : json['id'], 
      nom : json['nom'], 
      prenom : json['prenom'],
      );
  }


  Map toJson() => {
        'id': this.id,
        'nom': this.nom,
        'prenom': this.prenom,
      };
}