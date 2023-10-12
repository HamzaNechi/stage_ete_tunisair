import 'package:billet_faveur/main.dart';
import 'package:billet_faveur/screens/achat.dart';
import 'package:billet_faveur/screens/admin/users_screen.dart';
import 'package:billet_faveur/screens/cotisation.dart';
import 'package:billet_faveur/screens/historique.dart';
import 'package:billet_faveur/screens/profile/profile_screen.dart';
import 'package:billet_faveur/screens/reclamation/reclamation.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;

  static Widget page = const AchatBilletScreen();
  static String title = "Achat billet";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            //DrawerScreen(),
            /***** Drawer */
            Container(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 80,left: 40,bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                            backgroundImage: NetworkImage("$imageUrl/${sharedPref.get('image')}"),
                            radius: 100,
                          ),
                ),
                const SizedBox(
                  width: 10,
                ),

               Text("${sharedPref.get('nom')} ${sharedPref.get('prenom')}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                )
              ],
            ),
            //const SizedBox(height: 80,),
             Column(
              children: [

                //Profile
                InkWell(
                  onTap:() {
                    setState(() {
                      page =const ProfileScreen();
                      xOffset = 0;
                      yOffset = 0;
                      isDrawerOpen = false;
                      title = "Profile" ;
                    });
                  }, 
                  child: const Row(
                    children: [
                      Icon(
                        Icons.person_outlined,
                        color: Colors.white,
                      ),
                
                      SizedBox(
                        width: 20,
                      ),
                
                      Text('Profile' ,
                      style: TextStyle(
                
                        color: Colors.white
                      ),
                      )
                    ],
                  ),
                ),
                //End profile
                const SizedBox(height: 20,),


                //gestion des comptes (accés admin)
                Visibility(
                  visible: sharedPref.getString("role") == "admin",
                  child: InkWell(
                    onTap:() {
                      setState(() {
                        page =const UsersList();
                        xOffset = 0;
                        yOffset = 0;
                        isDrawerOpen = false;
                        title = "Comptes";
                      });
                    }, 
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Colors.white,
                        ),
                  
                        SizedBox(
                          width: 20,
                        ),
                  
                        Text('Comptes' ,
                        style: TextStyle(
                  
                          color: Colors.white
                        ),
                        )
                      ],
                    ),
                  ),
                ),
                //End gestion des comptes
                Visibility(
                  visible: sharedPref.getString("role") == "admin",
                  child: const SizedBox(height: 20,)),

                //achat billet
                InkWell(
                  onTap:() {
                    setState(() {
                      page =const AchatBilletScreen();
                      xOffset = 0;
                      yOffset = 0;
                      isDrawerOpen = false;
                      title = "Achat billet";
                    });
                  }, 
                  child: const Row(
                    children: [
                      Icon(
                        Icons.airplane_ticket_outlined,
                        color: Colors.white,
                      ),
                
                      SizedBox(
                        width: 20,
                      ),
                
                      Text('Achat billet' ,
                      style: TextStyle(
                
                        color: Colors.white
                      ),
                      )
                    ],
                  ),
                ),
                //End achat billet
                const SizedBox(height: 20,),


                //historique de mouvement
                InkWell(
                  onTap:() {
                    setState(() {
                      page =const HistoriqueScreen();
                      xOffset = 0;
                      yOffset = 0;
                      isDrawerOpen = false;
                      title = "Historique de Mouvement";
                    });
                  }, 
                  child: const Row(
                    children: [
                      Icon(
                        Icons.history_outlined,
                        color: Colors.white,
                      ),
                
                      SizedBox(
                        width: 20,
                      ),
                
                      Text('Historique' ,
                      style: TextStyle(
                
                        color: Colors.white
                      ),
                      )
                    ],
                  ),
                ),
                //End historique
                const SizedBox(height: 20,),

                //achat cotisation
                InkWell(
                  onTap:() {
                    setState(() {
                      page =const CotisationScreen();
                      xOffset = 0;
                      yOffset = 0;
                      isDrawerOpen = false;
                      title = "Cotisation";
                    });
                  }, 
                  child: const Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.white,
                      ),
                
                      SizedBox(
                        width: 20,
                      ),
                
                      Text('Cotisation' ,
                      style: TextStyle(
                
                        color: Colors.white
                      ),
                      )
                    ],
                  ),
                ),
                //End cotisation
                const SizedBox(height: 20,),


                //Réclamation
                InkWell(
                  onTap:() {
                    setState(() {
                      page =const ReclamationScreen();
                      xOffset = 0;
                      yOffset = 0;
                      isDrawerOpen = false;
                      title = "Réclamation";
                    });
                  }, 
                  child: const Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                
                      SizedBox(
                        width: 20,
                      ),
                
                      Text('Réclamation' ,
                      style: TextStyle(
                
                        color: Colors.white
                      ),
                      )
                    ],
                  ),
                ),
                //End cotisation
                const SizedBox(height: 20,),

                InkWell(
              onTap: () {
                sharedPref.clear();
                Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
              },
              child: Row(
                children: [
                  Icon(Icons.logout_outlined, color: Colors.white.withOpacity(0.5),),
                  const SizedBox(width: 10,),
                  Text('Log out',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5)
                  ),
                  )
                ],
              ),
            )

              ],
            ),


            Container()

            
            
          ],
        ),
        ),
    ),
            /** End Drawer */



            /*** les page à ouvrir */
            AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(isDrawerOpen ? 0.85 : 1.00)..rotateZ(isDrawerOpen ? -50 : 0),
      duration: Duration(milliseconds: 200),
      color: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,),
      
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isDrawerOpen ? GestureDetector(
                      child: const Icon(Icons.arrow_back_ios),
                      onTap: (){
                        setState(() {
                          xOffset = 0;
                          yOffset = 0;
                          isDrawerOpen = false ;
                        });
                      },
                    ) : 
                    GestureDetector(
                      child: const Icon(Icons.menu , size: 25,),
                      onTap: (){
                        setState(() {
                          xOffset = 290;
                          yOffset = 80;
                          isDrawerOpen = true ;
                        });
                      },
                    ),
      
                    Text(title,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none
                    ),
                    ),
      
      
                    Container(
                      
                    )
                  ],
                ),
              ),
      
              const SizedBox(
                height: 20,
              ),
      
      
              //widget
              
              Container(
                //height: MediaQuery.of(context).size.height,
                child: page,
              )
            ],
          ),
        ),
      ),
      )
            /**** end les pages */
          ],
        ),
      );
  }
}