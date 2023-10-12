import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:flutter/material.dart';

class CotisationScreen extends StatefulWidget {
  const CotisationScreen({super.key});

  @override
  State<CotisationScreen> createState() => _CotisationScreenState();
}

class _CotisationScreenState extends State<CotisationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();


  List<String> itemList=['Mensuel 30 DT','Trimestriel 60 DT','Semestriel 90 DT'];


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
                image: AssetImage("assets/images/cotisation.jpg"),
                fit: BoxFit.cover
                )
            ),
          ),

          const SizedBox(height: 50,),
          Form(
            key: _formKey,
            child: Column(
              children: [
        
                //cin
        
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _cinController,
                  textInputAction: TextInputAction.next,
                  cursorColor: primaryColor,
                  onSaved: (String? value) {
                    
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Champs obligatoir !';
                    }else{
                      if(value.length != 8){
                        return 'Le numéro de cin composé de 8 chiffres';
                      }else{
                        if(!RegExp(r'^[0-9]+$').hasMatch(value)){
                          return 'Le numéro de cin composé de 8 chiffres';
                        }else{
                          return null;
                        }
                      }
                      
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "CIN",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.card_membership_outlined),
                    ),
                  ),
                ),
        
        
                const SizedBox(height: defaultPadding),



                //nom
        
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  controller: _nomController,
                  cursorColor: primaryColor,
                  onSaved: (String? value) {
                    
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Champs obligatoir !';
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Nom",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.person_outlined),
                    ),
                  ),
                ),
        
        
                const SizedBox(height: defaultPadding),


                //prénom
        
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _prenomController,
                  textInputAction: TextInputAction.next,
                  cursorColor: primaryColor,
                  onSaved: (String? value) {
                    
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Champs obligatoir !';
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Prénom",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.bookmark_outline),
                    ),
                  ),
                ),
        
        
                const SizedBox(height: defaultPadding),


                //option de paiement

                DropdownButtonFormField<String>(
                    //hint
                    items: itemList
                        .map((item2) => DropdownMenuItem(
                            value: item2,
                            child: Text(item2, style: TextStyle(fontSize: 15))))
                        .toList(),
                    onChanged: (item2) => setState(() {
                      
                    }),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Champs obligatoir !';
                      }else{
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Choisir une option',
                      prefixIcon: Icon(Icons.data_exploration_outlined),
                    ),
              ),
        
                
        
        
                const SizedBox(height: defaultPadding),


                
                //submit button
                
                Hero(
                  tag: "cotisation_btn",
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                          // _keyForm.currentState!.save();
                          // signinAction();
                        }
                    },
                    child: const Text(
                      "Payer",
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