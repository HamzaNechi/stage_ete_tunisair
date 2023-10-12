import 'dart:convert';

import 'package:billet_faveur/utils/apiAirport.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


class AchatBilletScreen extends StatefulWidget {
  const AchatBilletScreen({super.key});

  @override
  State<AchatBilletScreen> createState() => _AchatBilletScreenState();
}

class _AchatBilletScreenState extends State<AchatBilletScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _deController = TextEditingController();
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _dateDepartController = TextEditingController();
  final TextEditingController _dateArriveController = TextEditingController();


  List<String> listCabine=['Classe économique','Classe affaires','Premiére classe'];
  List<String> listAdulte=['0','1','2','3','4','5','6','7','8','9'];
  List<String> listEnfant=['0','1','2','3','4','5','6','7','8','9'];
  List<String> listNourrissons=['0','1','2','3','4','5','6','7','8','9'];


  //State variable

  bool allerRetour = true;
  int valueRadioGroupe = 2;

  //select date function depart
  DateTime _selectedDate = DateTime.now();
  DateTime lastDate = DateTime.now().add(const Duration(days: 5*365));
  bool _verifDateRetour = false;

   Future<void> _selectDateDepart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: lastDate,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
         _dateDepartController.text = DateFormat.yMd().format(_selectedDate);
      });
    }
  }
  //end select date depart function



  //select date function retour
  DateTime _selectedDateRetour = DateTime.now();
  DateTime lastDateRetour = DateTime.now().add(const Duration(days: 5*365));
  Future<void> _selectDateRetour(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateRetour,
      firstDate: DateTime.now(),
      lastDate: lastDateRetour,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _verifDateRetour = picked.compareTo(_selectedDate) < 0;
        _selectedDateRetour = picked;
        _dateArriveController.text = DateFormat.yMd().format(_selectedDateRetour);
      });
    }
  }
  //end select date retour function



  //vérifier le nombre de personne <= 9
  int nbrAdulte = 0;
  int nbrJeune = 0;
  int nbrEnfant = 0;
  int nbrBebe = 0;
  bool? _verifNombrePersonne(){
    return (nbrAdulte+nbrBebe+nbrEnfant+nbrJeune) <= 9;
  }
  // end verif nombre de personne


  //list of widget pour ajouter une nouvelle destination
  bool showAddDestination = false;
   Widget destination = Column(
    children: [
      //de
       TextFormField(
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    decoration: const InputDecoration(
                      hintText: "De",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child:Icon(FontAwesomeIcons.planeDeparture,size: 18),
                      ),
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Champ obligatoire" ;
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      
                    },
                    
                  ),
                  // end de 
                  const SizedBox(height: defaultPadding),
                  
                  
                  
                  //a
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    decoration: const InputDecoration(
                      hintText: "A",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(FontAwesomeIcons.planeArrival,size: 18,),
                      ),
                    ),
                    validator:(value){
                      if(value == null || value.isEmpty){
                        return "Champ obligatoire";
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      
                    },
                  ),
                    
                    
                  const SizedBox(height: defaultPadding),
    ],
  );
  List<Widget> listDestinations = [];



  _searchAirport(String keyAir) async{
    AirportApi api = AirportApi();
    api.fetchAirport(keyAir);

    
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/achat.jpg"),
                  fit: BoxFit.cover
                  )
              ),
            ),
        
            const SizedBox(height: 50,),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  //check if aller retour ou aller simple
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      
                      Row(
                        children: [
                          const Text('Réserver un vol :',style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),),
                          const SizedBox(width: defaultPadding/4,),
                          Radio(
                            value: 1, 
                            groupValue: valueRadioGroupe, 
                            onChanged: (value){
                              setState(() {
                                valueRadioGroupe = 1;
                                allerRetour = false ;
                                showAddDestination = false;
                              });
                            }
                            ),
                            const SizedBox(width: defaultPadding/4,),

                            const Text('Aller simple'),


                            const SizedBox(width: defaultPadding/4,),


                            Radio(
                            value: 2, 
                            groupValue: valueRadioGroupe, 
                            onChanged: (value){
                              setState(() {
                                valueRadioGroupe = 2;
                                allerRetour = true ;
                                showAddDestination = false;
                              });
                            }
                            ), 

                            const SizedBox(width: defaultPadding/4,),

                            const Text('Aller Retour'),
                            
                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          const SizedBox(width: defaultPadding*3,),
                          Radio(
                            value: 3, 
                            groupValue: valueRadioGroupe, 
                            onChanged: (value){
                              setState(() {
                                valueRadioGroupe = 3;
                                allerRetour = true ;
                                showAddDestination = true;
                              });
                            }
                            ),
                            const SizedBox(width: defaultPadding/4,),

                            const Text('Multi destinations'),
                        ],
                      )

                      
                    ],
                  ),

                  const SizedBox(height: defaultPadding,),
                    
                  //de
                    
                  TextFormField(
                   // keyboardType: TextInputType.name,
                    controller: _deController,
                    textInputAction: TextInputAction.next,
                    cursorColor: primaryColor,
                    decoration: const InputDecoration(
                      hintText: "De",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child:Icon(FontAwesomeIcons.planeDeparture,size: 18),
                      ),
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Champ obligatoire" ;
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      
                    },
                    
                  ),
                  // end de 
                  const SizedBox(height: defaultPadding),
                  
                  
                  
                  //a
                    
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: _aController,
                    cursorColor: primaryColor,
                    decoration: const InputDecoration(
                      hintText: "A",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(FontAwesomeIcons.planeArrival,size: 18,),
                      ),
                    ),
                    onChanged: (value) {
                      _searchAirport(value);
                    },
                    validator:(value){
                      if(value == null || value.isEmpty){
                        return "Champ obligatoire";
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      
                    },
                  ),
                    
                    
                  

                  // container to add destination
                  Visibility(
                    visible: showAddDestination,
                    child: Column(
                      children: [
                        const SizedBox(height: defaultPadding),

                        Column(
                          children: listDestinations,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                                FloatingActionButton(onPressed: () {
                            setState(() {
                              listDestinations.add(destination);
                            });
                            },
                            backgroundColor: Colors.red[400],
                            child: const Icon(Icons.add_circle, color: Colors.white, size: 30,),
                            ),

                            const SizedBox(width: 5,),

                            FloatingActionButton(onPressed: () {
                              setState(() {
                                if(listDestinations.isNotEmpty){
                                  listDestinations.removeLast();
                                }
                                
                              });
                            },
                            backgroundColor: Colors.grey[500],
                            child: const Icon(Icons.remove_circle, color: Colors.white, size: 30,),
                            ),
                          ],
                        )

                        
                        

                      ],
                    )
                    ),

                    //end container to add destination
                  
                  
                  const SizedBox(height: defaultPadding),
                  //Date
                    
                  GestureDetector(
                    onTap: () {
                      _selectDateDepart(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateDepartController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        cursorColor: primaryColor,
                        onSaved: (String? value) {
                          
                        },
                        decoration: const InputDecoration(
                          hintText: "Date Départ",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.calendar_month,size: 18,),
                          ),
                        ),
                        validator:(value){
                          if(value == null || value.isEmpty){
                            return "Champ obligatoire";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                    
                    
                  const SizedBox(height: defaultPadding),
                  
                  
                  Visibility(
                    visible: allerRetour,
                    child: GestureDetector(
                    onTap: () {
                      _selectDateRetour(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateArriveController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        cursorColor: primaryColor,
                        onSaved: (String? value) {
                          
                        },
                        validator:(value){
                          if(value == null || value.isEmpty){
                            return "Champ obligatoire";
                          }
                          if(_verifDateRetour){
                            return "Entrer une date supérieur à la date de départ";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Date Retour",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.calendar_month,size: 18,),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),


                  Visibility(
                    visible: allerRetour,
                    child: const SizedBox(height: defaultPadding),),
                    
                    
                  
                  
                  
                  
                  //cabine
                  
                  DropdownButtonFormField<String>(
                      //hint
                      items: listCabine
                          .map((item2) => DropdownMenuItem(
                              value: item2,
                              child: Text(item2, style: TextStyle(fontSize: 15))))
                          .toList(),
                      onChanged: (item2) => setState(() {
                        
                      }),
                      decoration: const InputDecoration(
                        hintText: 'Cabine',
                        prefixIcon: Icon(Icons.bedroom_child,size: 18,),
                      ),
                      validator:(value){
                          if(value == null || value.isEmpty){
                            return "Champ obligatoire";
                          }
                          return null;
                        },
                ),
                    
                  
                    
                    
                  const SizedBox(height: defaultPadding),
                  
                  
                  
                  //Adultes
                  
                  DropdownButtonFormField<String>(
                      //hint
                      items: listAdulte
                          .map((item2) => DropdownMenuItem(
                              value: item2,
                              child: Text(item2, style: TextStyle(fontSize: 15))))
                          .toList(),
                      onChanged: (item2) => setState(() {
                        nbrAdulte = int.parse(item2!);
                      }),
                      decoration: const InputDecoration(
                        hintText: 'Adultes 25+ans',
                        prefixIcon: Icon(Icons.man_4_outlined,size: 18,),
                      ),

                      validator:(value){
                          if(value == null || value.isEmpty){
                            return "Champ obligatoire";
                          }else{
                            if(!_verifNombrePersonne()!){
                              return "Le nombre maximale de personne est 9";
                            }else{
                              return null;
                            }
                          }
                        },
                ),
                    
                  
                    
                    
                  const SizedBox(height: defaultPadding),



                  //Jeune
                  
                  DropdownButtonFormField<String>(
                      //hint
                      items: listAdulte
                          .map((item2) => DropdownMenuItem(
                              value: item2,
                              child: Text(item2, style: TextStyle(fontSize: 15))))
                          .toList(),
                      onChanged: (item2) => setState(() {
                        nbrJeune = int.parse(item2!);
                      }),
                      decoration: const InputDecoration(
                        hintText: 'Jeune 12-24+ans',
                        prefixIcon: Icon(Icons.boy,size: 18,),
                      ),

                      validator:(value){
                          if(value == null || value.isEmpty){
                            return "Champ obligatoire";
                          }else{
                            if(!_verifNombrePersonne()!){
                              return "Le nombre maximale de personne est 9";
                            }else{
                              return null;
                            }
                          }
                        },
                ),
                    
                  
                    
                    
                  const SizedBox(height: defaultPadding),
                  
                  
                  //Enfants
                  
                  DropdownButtonFormField<String>(
                      //hint
                      items: listEnfant
                          .map((item2) => DropdownMenuItem(
                              value: item2,
                              child: Text(item2, style: TextStyle(fontSize: 15))))
                          .toList(),
                      onChanged: (item2) => setState(() {
                        nbrEnfant = int.parse(item2!);
                      }),
                      decoration: const InputDecoration(
                        hintText: 'Enfants 2-11ans',
                        prefixIcon: Icon(Icons.boy_outlined,size: 18,),
                      ),

                      validator:(value){
                          if(value == null || value.isEmpty){
                            return "Champ obligatoire";
                          }else{
                            if(!_verifNombrePersonne()!){
                              return "Le nombre maximale de personne est 9";
                            }else{
                              return null;
                            }
                          }
                        },
                ),
                    
                  
                    
                    
                  const SizedBox(height: defaultPadding),
                  
                  
                  //Bébé
                  
                  DropdownButtonFormField<String>(
                      //hint
                      items: listNourrissons
                          .map((item2) => DropdownMenuItem(
                              value: item2,
                              child: Text(item2, style: const TextStyle(fontSize: 15))))
                          .toList(),
                      onChanged: (item2) => setState(() {
                        nbrBebe = int.parse(item2!);
                      }),
                      decoration: const InputDecoration(
                        hintText: 'Bébé -2ans',
                        prefixIcon: Icon(FontAwesomeIcons.baby,size: 18,),
                      ),

                      validator:(value){
                          if(value == null || value.isEmpty){
                            return "Champ obligatoire";
                          }else{
                            if(!_verifNombrePersonne()!){
                              return "Le nombre maximale de personne est 9";
                            }else{
                              return null;
                            }
                          }
                        },
                ),
                    
                  
                    
                    
                  const SizedBox(height: defaultPadding),
                  
                  
                  
                  //submit button
                  
                  Hero(
                    tag: "achat_btn",
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // _keyForm.currentState!.save();
                          // signinAction();
                        }
                      },
                      child: const Text(
                        "Recherche",
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
      ),
    );
  }
}