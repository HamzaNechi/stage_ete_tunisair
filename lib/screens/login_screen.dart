import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:billet_faveur/main.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:billet_faveur/utils/crud.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            

            //image logo
            Container(
              width: 280,
              height: 280,
              child: Image.asset('assets/images/lg.png'),
            ),


            //const SizedBox(height: defaultPadding,),



            //login form
            const LoginForm(),

          ],
        ),
      ),
    );
  }
}


//login form

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey= GlobalKey();
  TextEditingController _matriculeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  Crud crud = Crud();
  bool isLoading = false;


  //deecoder base64
  String decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }
    return utf8.decode(base64Url.decode(output));
  }
  //end

  login() async{
    isLoading=true;
    setState(() {
      
    });
    var response=await crud.postRequest(loginUrl, {
      "matricule":_matriculeController.text,
      "password":_passwordController.text
    });
    isLoading=false;
    setState(() {
      
    });



    if(response['statusCode'] == 200){
      String jwt = response['data'];
      Map<String, dynamic> decodedJwt = json.decode(decodeBase64(jwt.split('.')[1]));
      sharedPref.setString('matUser', decodedJwt['matricule'].toString());
      sharedPref.setString('nom', decodedJwt['nom']);
      sharedPref.setString('prenom', decodedJwt['prenom']);
      sharedPref.setString('tel', decodedJwt['tel']);
      sharedPref.setString('email', decodedJwt['email']);
      sharedPref.setString('cin', decodedJwt['cin']);
      sharedPref.setString('image', decodedJwt['image']);
      sharedPref.setString('role', decodedJwt['role']);
      sharedPref.setString('accessToken', jwt);
      Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
    }else{
      AwesomeDialog(
        context: context,
        btnCancel: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                
              },
              child: Text('OK' , style: TextStyle(color: Colors.blue),)),
          ],
        ),
        title: 'Warning !',
        body: Text("Vérifier votre information d'authentification")
        )..show();
    }
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? 
    const Center(
      child: CircularProgressIndicator(),
    )
    :Form(
      key: _formKey,
      child: Column(
        children: [

          //email

          TextFormField(
            controller: _matriculeController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            cursorColor: primaryColor,
            onSaved: (String? value) {
              _matriculeController.text = value!;
            },
            validator: (value) {
              if(value == null || value.isEmpty){
                  return 'Champ obligatoire';
              }else{
                  if(value.length > 5){
                    return 'Matricule ne dépasse pas 8 chifres';
                  }else{
                    return null;
                  }
              }
            },
            decoration: const InputDecoration(
              hintText: "Matricule",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),


          const SizedBox(height: defaultPadding),


          //password 
          TextFormField(
              textInputAction: TextInputAction.done,
              controller: _passwordController,
              obscureText: true,
              cursorColor: primaryColor,
              onSaved: (String? value) {
                setState(() {
                  _passwordController.text = value!;
                });
              },
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Champ obligatoire';
                }else{
                  if(value.length > 8){
                    return 'Mot de passe ne dépasse pas 8 caractére';
                  }else{
                    return null;
                  }
                }
              },
              decoration: const InputDecoration(
                hintText: "Mot de passe",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),


          const SizedBox(height: defaultPadding,),

          
          //submit button
          
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  login();
                }
                
              },
              child: const Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    //fontFamily: 'Mark-Light',
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ),
        ],
      )
      );
  }
}