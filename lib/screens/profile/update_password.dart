import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:billet_faveur/main.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:billet_faveur/utils/crud.dart';
import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  GlobalKey<FormState> _formKeyUpdatePassword= GlobalKey();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _newController = TextEditingController();


  Future<void> updatePassword() async{
    Crud crud=Crud();
    String matricule = sharedPref.getString('matUser').toString();
    String accessToken = sharedPref.getString('accessToken').toString();
    Map<String, dynamic> bodyMap = {};
      bodyMap['matricule'] = matricule;
      bodyMap['old_password'] = _passwordController.text;
      bodyMap['new_password'] = _newController.text;
    var response = await crud.postRequestToken('$userUrl/change_password', bodyMap, accessToken);
    print('response change password = $response');
    
    if(response['statusCode'] == 200){
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
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red
                  ),
                  child: Center(child: Text('OK' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),)))),
            ],
          ),
          title: 'Warning !',
          body: Text(response["message"])
          )..show();
    }

  }
  
  @override
  Widget build(BuildContext context) {
    double defaultWidth = MediaQuery.of(context).size.width;
    double defaultHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: defaultWidth,
        height: defaultHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: defaultPadding*3,),
        
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
              
                      child: Icon(Icons.arrow_back , color: Colors.black,),
                    ),


                    const SizedBox(width: 8,),
        
                    Text("Retour",style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none
                      ),),
                  ],
                ),
        
        
                
                
              ),


            const SizedBox(height: defaultPadding*2.5,),

            Container(
              width: defaultWidth*0.9,
              height: defaultWidth * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/update_password.png")),
              ),
            ),


            const SizedBox(height: defaultPadding/4,),

            Text("Changer votre mot de passe",style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        fontStyle: FontStyle.italic
                      ),),

            const SizedBox(height: defaultPadding/4,),

            Expanded(
              child: Form(
                key: _formKeyUpdatePassword,
                child: ListView(
                  children: [
                    
                          
                    //password 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
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
                            hintText: "Ancien mot de passe",
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.password),
                            ),
                          ),
                        ),
                    ),
                          
                          
                      const SizedBox(height: 10,),
                          
                          
                      //new password 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                          textInputAction: TextInputAction.done,
                          controller: _newController,
                          obscureText: true,
                          cursorColor: primaryColor,
                          onSaved: (String? value) {
                            setState(() {
                              _newController.text = value!;
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
                            hintText: "Nouveau mot de passe",
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.lock),
                            ),
                          ),
                        ),
                    ),
              
              
                    const SizedBox(height: 10,),
              
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Hero(
                          tag: "update_password_btn",
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKeyUpdatePassword.currentState!.validate()) {
                                _formKeyUpdatePassword.currentState!.save();
                                updatePassword();
                              }
                              
                            },
                            child: const Text(
                              "Modifier",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Mark-Light',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}