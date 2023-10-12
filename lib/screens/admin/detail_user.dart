import 'package:billet_faveur/models/user.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants.dart';

class DetailUser extends StatefulWidget {
  final User user;
  const DetailUser({super.key, required this.user});

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [

              const SizedBox(height: defaultPadding*2.2,),
        
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
        
        
                    Text("Détail utilisateur",style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none
                      ),),
        
        
                    const SizedBox(width: 20,)
                  ],
                ),
        
        
                
                
              ),
        
              const SizedBox(height: defaultPadding*3,),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("$imageUrl/${widget.user.image}"),
                          radius: 100,
                        ),
                      ),
        
        
                      const SizedBox(height: defaultPadding,),
        
                       Text('${widget.user.prenom} ${widget.user.nom}' , style:const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),),
        
                      const SizedBox(height: defaultPadding*0.4,),
        
                      Text(widget.user.email! , style:const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),)
                    ],
                  )
                ],
              ),
        
        
              //const SizedBox(height: defaultPadding,),
        
        
              ListView(
                shrinkWrap: true,
                children:  [
                  DetailListItem(
                    text: "Tél : ${widget.user.tel}",
                    icon: FontAwesomeIcons.squarePhone,
                    hasNavigation: false,
                  ),
        
                  DetailListItem(
                    text: "Cin : ${widget.user.cin}",
                    icon: FontAwesomeIcons.idCard,
                    hasNavigation: false,
                  ),
        
        
                  DetailListItem(
                    text: "Matricule : ${widget.user.matricule}",
                    icon: FontAwesomeIcons.idBadge,
                    hasNavigation: false,
                  ),

                  DetailListItem(
                    text: "Rôle : ${widget.user.role}",
                    icon: FontAwesomeIcons.idBadge,
                    hasNavigation: false,
                  ),
                ],
              ),
        
              
            ],
          ),
        ),
      ),
    );
  }
}

class DetailListItem extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final bool? hasNavigation;
  const DetailListItem({
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