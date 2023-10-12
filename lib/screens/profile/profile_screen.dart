import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:billet_faveur/main.dart';
import 'package:billet_faveur/screens/profile/update_password.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/crud.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  GlobalKey<FormState> _formProfileKey= GlobalKey();
  TextEditingController _nomController = TextEditingController(); 
  TextEditingController _prenomController = TextEditingController(); 
  TextEditingController _emailController = TextEditingController(); 
  TextEditingController _telController = TextEditingController();
  TextEditingController _matriculeController = TextEditingController(); 
  TextEditingController _cinController = TextEditingController(); 
  TextEditingController _roleController = TextEditingController(); 

  String imageName = sharedPref.getString('image').toString();
  
  File? _image;

  @override
  Widget build(BuildContext context) {
    

    setState(() {
      _nomController.text = sharedPref.get('nom').toString();
      _prenomController.text = sharedPref.getString('prenom').toString();
      _emailController.text = sharedPref.getString('email').toString();
      _telController.text = sharedPref.getString('tel').toString();
      _matriculeController.text = sharedPref.getString('matUser').toString();
      _cinController.text = sharedPref.getString('cin').toString();
      _roleController.text = sharedPref.getString('role').toString() == "admin" ? "Administrateur" : "Simple utilisateur";
    });

    Future<void> _selectImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }

      final uri =Uri.parse('$userUrl/update_profile_image');
      final request = http.MultipartRequest('POST',uri);

      String accessToken = sharedPref.getString('accessToken')!;
      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields['nom'] = sharedPref.getString('nom').toString();
      request.fields['matricule'] = sharedPref.getString('matUser').toString();
      request.fields['cin'] = sharedPref.getString('cin').toString();
      request.fields['imageAncien'] = imageName;

      // add image file
      if (_image != null) {
        final bytes = await _image!.readAsBytes();
        final file = http.MultipartFile.fromBytes(
          'image',
          bytes,// or any other filename with extension
          filename: 'image.jpg'
        );
        request.files.add(file);
      }

      final response = await request.send();
      final resp = await http.Response.fromStream(response);
      var r = jsonDecode(resp.body);

      if(r["statusCode"] == 200){
          setState(() {
                      sharedPref.setString("image", r["data"]);
                      imageName = r["data"];
                      _image = null;
                    });
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            btnCancel: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    
                    Navigator.pop(context);
                  },
                  child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                  ),
                  child: Center(child: Text('OK' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),)))),
              ],
            ),
            title: 'Succée',
            body: Text(r["message"])
            )..show();
        }else{
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            btnCancel: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red
                  ),
                  child: Center(child: Text('OK' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),)))),
              ],
            ),
            title: 'Warning !',
            body: Text(r["message"])
            )..show();
        }
    }


    updateProfile() async {
      Crud crud = Crud();

      //remplir le body
      String tel = _telController.text;
      String nom = _nomController.text;
      String prenom = _prenomController.text;
      Map<String, dynamic> userMap = {};
      userMap['nom'] = nom;
      userMap['prenom'] = prenom;
      userMap['tel'] = tel;
      userMap['matricule'] = _matriculeController.text;
      var response = await crud.putRequest(userUrl,userMap,sharedPref.getString('accessToken').toString());

      if(response["statusCode"] == 200){
        setState(() {
                    //set shared preferences nom,prenom,tel
                    sharedPref.setString('nom', nom);
                    sharedPref.setString('prenom', prenom);
                    sharedPref.setString('tel', tel);
                  });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          btnCancel: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                  ),
                  child: Center(child: Text('OK' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),)))),
            ],
          ),
          title: 'Succée',
          body: Text(response["message"])
          )..show();
      }else{
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          btnCancel: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('OK' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),)))),
            ],
          ),
          title: 'Warning !',
          body: Text(response["message"])
          )..show();
      }
    }


    return Padding(
      padding: const EdgeInsets.fromLTRB(defaultPadding, defaultPadding, defaultPadding, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage("$imageUrl/$imageName"),
                          radius: 100,
                        ),
                  
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              _selectImage();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(
                                  FontAwesomeIcons.pen,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
    
    
                  const SizedBox(height: defaultPadding,),
    
                   Text('${sharedPref.get('prenom').toString()} ${sharedPref.get('nom').toString()}' , style:const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),),
    
                  const SizedBox(height: defaultPadding*0.4,),
    
                  Text(sharedPref.get('email').toString() , style:const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),)
                ],
              )
            ],
          ),
    
    
          const SizedBox(height: defaultPadding*2,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //2 button supprimer compte et modifier mot de passe
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePassword(),));
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width*0.7,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor,
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
              
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('Modifier mot de passe' , style: TextStyle(fontSize: 18, color: primaryColor),),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: defaultPadding,),
    
    
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Form(
                key: _formProfileKey,
                child: Column(
                  children:  [
                    
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _nomController,
                      cursorColor: primaryColor,
                      onSaved: (String? value) {
                        setState(() {
                          _nomController.text = value!;
                        });
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Champ obligatoire';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Nom",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(FontAwesomeIcons.userTag, size: 16, color: Colors.grey,),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: defaultPadding,),
          
          
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _prenomController,
                      cursorColor: primaryColor,
                      onSaved: (String? value) {
                        setState(() {
                          _prenomController.text = value!;
                        });
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Champ obligatoire';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Prénom",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(FontAwesomeIcons.userTag , size: 16, color: Colors.grey,),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: defaultPadding,),
          
                    
          
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _telController,
                      cursorColor: primaryColor,
                      onSaved: (String? value) {
                        setState(() {
                          _telController.text = value!;
                        });
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Champ obligatoire';
                        }else{
                          if(value.length != 8){
                            return 'Le numéro de téléphone est composé de 8 chiffres';
                          }else{
                            return null;
                          }
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Téléphone",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(FontAwesomeIcons.phone, size: 16, color: Colors.grey,),
                        ),
                      ),
                    ),


                    
          
                    const SizedBox(height: defaultPadding,),
          
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _emailController,
                      cursorColor: primaryColor,
                      enabled: false,
                      onSaved: (String? value) {
                        setState(() {
                          _emailController.text = value!;
                        });
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Champ obligatoire';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(FontAwesomeIcons.solidEnvelope, size: 16, color: Colors.grey,),
                        ),
                      ),
                    ),
          
          
                    const SizedBox(height: defaultPadding,),
          
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _matriculeController,
                      cursorColor: primaryColor,
                      enabled: false,
                      onSaved: (String? value) {
                        setState(() {
                          _matriculeController.text = value!;
                          print('value matricule on saved form $value');
                        });
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Champ obligatoire';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Matricule",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(FontAwesomeIcons.idCardClip, size: 16, color: Colors.grey,),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: defaultPadding,),
          
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _cinController,
                      cursorColor: primaryColor,
                      enabled: false,
                      onSaved: (String? value) {
                        setState(() {
                          _cinController.text = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Cin",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(FontAwesomeIcons.solidAddressCard, size: 16, color: Colors.grey,),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: defaultPadding,),
          
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _roleController,
                      cursorColor: primaryColor,
                      enabled: false,
                      onSaved: (String? value) {
                        setState(() {
                          _roleController.text = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Role",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(FontAwesomeIcons.personCircleQuestion , size: 16 , color: Colors.grey,),
                        ),
                      ),
                    ),
          
          
          
                    const SizedBox(height: defaultPadding,),
          
                    //submit button
                  
                    Hero(
                      tag: "update_profile_hero",
                      child: ElevatedButton(
                        style:  ElevatedButton.styleFrom(
                          elevation: 0, 
                          backgroundColor: Colors.grey.shade400,
                          shape: const StadiumBorder(),
                          maximumSize: const Size(double.infinity, 56),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        onPressed: () {
                          if (_formProfileKey.currentState!.validate()) {
                            _formProfileKey.currentState!.save();
                            print('update profile');
                            updateProfile();
                          }
                          
                        },
                        child: const Text(
                          "Modifier",
                          style: TextStyle(
                              color: primaryColor,
                              //fontFamily: 'Mark-Light',
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    
          
        ],
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final bool? hasNavigation;
  const ProfileListItem({
    super.key,
    this.icon,
    this.text,
    this.hasNavigation
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 15).copyWith(
        bottom: 16
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: secondColor
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(icon, size: 25, color: primaryColor,),

          const SizedBox(width: 10,),

          Text(
            text!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}