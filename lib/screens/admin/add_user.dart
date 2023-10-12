import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:billet_faveur/main.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  final Function(bool userCreated) onUserCreated;
  const AddUser({super.key , required this.onUserCreated});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController matController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
  final TextEditingController roleController = TextEditingController();


  File? _image;
  bool switchRole = false;
  String valueRole = "user";

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addUser() async {
    print('add user function start');
    final uri =Uri.parse(addUserUrl);
    final request = http.MultipartRequest('POST',uri);

    String accessToken = sharedPref.getString('accessToken')!;
    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields['nom'] = nomController.text;
    request.fields['prenom'] = prenomController.text;
    request.fields['email'] = emailController.text;
    request.fields['password'] = passController.text;
    request.fields['tel'] = telController.text;
    request.fields['matricule'] = matController.text;
    request.fields['cin'] = cinController.text;
    request.fields['role'] = valueRole;


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
    
    if(r["statusCode"] == 201){
      
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        btnCancel: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  nomController.text = "";
                  prenomController.text = "";
                  emailController.text = "";
                  passController.text = "";
                  telController.text = "";
                  matController.text = "";
                  cinController.text = "";
                  valueRole = "user";
                  switchRole = false;
                  _image = null;
                });
                widget.onUserCreated(true);
                Navigator.pop(context);
              },
              child: Text('OK' , style: TextStyle(color: Colors.blue),)),
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
              child: Text('OK' , style: TextStyle(color: Colors.blue),)),
          ],
        ),
        title: 'Warning !',
        body: Text(r["message"])
        )..show();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8,),
        
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
              
                      child: Icon(Icons.arrow_back , color: Colors.black,),
                    ),
        
        
                    Text("Ajouter un utilisateur",style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none
                      ),),
        
        
                    const SizedBox(width: 20,)
                  ],
                ),
        
        
                
                
              ),
        
              const SizedBox(height: defaultPadding,),
        
        
              //add image
              InkWell(
                onTap: () {
                  _selectImage();
                },
                child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),

                child: CircleAvatar(
                  radius: 200,
                  child: _image != null ? Image.file(_image!) : Image.asset('assets/images/standard_profile_image.png'), 
                ),
                  ),
              ),

              const SizedBox(height: defaultPadding,),
        
        
              //user form

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nomController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Champ obligatoir !';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    onSaved: (String? value) {
                      
                    },
                    decoration: const InputDecoration(
                      hintText: "Nom",
                    ),
                  ),
              ),



              const SizedBox(height: defaultPadding,),


              //prenom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: prenomController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Champ obligatoir !';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    onSaved: (String? value) {
                      
                    },
                    decoration: const InputDecoration(
                      hintText: "Prénom",
                    ),
                  ),
              ),



              const SizedBox(height: defaultPadding,),


              //email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Champ obligatoir !';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    onSaved: (String? value) {
                      
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
              ),


              const SizedBox(height: defaultPadding,),


              //mdp
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passController,
                    obscureText: true,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Champ obligatoir !';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    onSaved: (String? value) {
                      
                    },
                    decoration: const InputDecoration(
                      hintText: "Mot de passe",
                    ),
                  ),
              ),



              const SizedBox(height: defaultPadding,),


              //tel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: telController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Champ obligatoir !';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    onSaved: (String? value) {
                      
                    },
                    decoration: const InputDecoration(
                      hintText: "Téléphone",
                    ),
                  ),
              ),

              const SizedBox(height: defaultPadding,),


              //matricule
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: matController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Champ obligatoir !';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    onSaved: (String? value) {
                      
                    },
                    decoration: const InputDecoration(
                      hintText: "Matricule",
                    ),
                  ),
              ),


              const SizedBox(height: defaultPadding,),

              //cin
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: cinController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Champ obligatoir !';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    onSaved: (String? value) {
                      
                    },
                    decoration: const InputDecoration(
                      hintText: "CIN",
                    ),
                  ),
              ),

              const SizedBox(height: defaultPadding,),

              //role
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tu veux ajouter un administrateur ?" ,style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 16
                    ),),
              
                    Switch(value: switchRole, 
                    onChanged: (value) {
                      setState(() {
                        switchRole = value;
                        valueRole = value ? "admin" : "user";
                      });
                    },)
                  ],
                ),
              ),


              const SizedBox(height: defaultPadding,),


              //submit button
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Hero(
                    tag: "add_user_btn",
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _addUser();
                        }
                        
                      },
                      child: const Text(
                        "Ajouter",
                        style: TextStyle(
                            color: Colors.white,
                            //fontFamily: 'Mark-Light',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: defaultPadding,),
            ],
          ),
        ),
      ),
    );
  }
}