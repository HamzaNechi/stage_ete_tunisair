import 'package:billet_faveur/main.dart';
import 'package:billet_faveur/models/reclamation.dart';
import 'package:billet_faveur/screens/reclamation/AskForFile.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class ReclamationScreen extends StatefulWidget {
  const ReclamationScreen({super.key});

  @override
  State<ReclamationScreen> createState() => _ReclamationScreenState();
}

class _ReclamationScreenState extends State<ReclamationScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController sujetController = TextEditingController();
  final TextEditingController textController = TextEditingController();


  @override
  Widget build(BuildContext context) {



    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 50),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          Container(
            width: 250,
            height: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/reclamation.jpg"),
                fit: BoxFit.cover
                )
            ),
          ),

          const SizedBox(height: 50,),
          Form(
            key: _formKey,
            child: Column(
              children: [
        
                //email
        
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: sujetController,
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
                    hintText: "Sujet",
                  ),
                ),
        
        
                const SizedBox(height: defaultPadding),

        
        
                 TextField(
                  controller: textController,
                  maxLines: 5, //or null 
                  decoration:const InputDecoration(
                      hintText: "Entrer votre Message",
                      //prefixIcon: Icon(Icons.messenger_outline_outlined),
                      ),
                  ),
        
        
                const SizedBox(height: defaultPadding,),


                
                //submit button
                
                Hero(
                  tag: "reclamation_btn",
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        var reclamation = Reclamation(sharedPref.getString('matUser'), sujetController.text, textController.text, []);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AskForFile(reclamation: reclamation),), (route) => false);
                      }
                      
                    },
                    child: const Text(
                      "Suivant",
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
          ),
        ],
      ),
    );

    
  }

  
}