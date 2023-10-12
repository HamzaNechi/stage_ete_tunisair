import 'package:billet_faveur/navigations/root_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class ResponseReclamation extends StatelessWidget {
  final Map<String,String> map;
  const ResponseReclamation({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80 , bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      
            
      
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *0.23,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/result_upload.png'))
                ),
            ),
      
      
            
      
      
            Expanded(
              
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: map.length,
                  itemBuilder: (context, index) {
                  final fileName = map.keys.elementAt(index);
                  final status = map[fileName] == "success" ? "Fichier ajoutée avec succés" : map[fileName];
                        
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      title: Text(fileName, maxLines: 1,style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                      ),),
                      subtitle: Text(status! ,style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500
                      ),),
                      leading: status == "Fichier ajoutée avec succés" ? const Icon(Icons.check_circle , color: Colors.green,) : const Icon(Icons.error , color: Colors.red,),
                      // Vous pouvez ajouter d'autres widgets ici pour personnaliser l'apparence de chaque élément de la liste
                    ),
                  );
                  },
                ),
              ),
            ),
      
      
      
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RootScreen(),), (route) => false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          width: 70,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topRight: Radius.circular(5))
                          ),
            
                          child:const Center(child: Text('Ok' , style: TextStyle(color: Colors.white , fontSize: 18,fontWeight: FontWeight.w500),))
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}