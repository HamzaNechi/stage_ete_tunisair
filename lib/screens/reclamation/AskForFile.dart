import 'package:billet_faveur/models/reclamation.dart';
import 'package:billet_faveur/screens/reclamation/FilePage.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class AskForFile extends StatefulWidget {
  final Reclamation reclamation;
  const AskForFile({super.key,required this.reclamation});

  @override
  State<AskForFile> createState() => _AskForFileState();
}

class _AskForFileState extends State<AskForFile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
        
              Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/file_upload.png"),
                    fit: BoxFit.cover
                    )
                ),
              ),

               Column(
                children: [
                   const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Voulez-vous ajouter des fichiers ?' , style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),),
                    ],
                  ),


                  Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text('Pour enrichissez votre réclamation tu peux ajouter des fichier pdf , jpg , png ...' , 
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                        
                                          ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              

        
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  InkWell(
                    onTap: ()async {
                    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                          if(result == null) return ;
                  
                          //open files
                          final files = result.files;
                          openFiles(files,context);
                      
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5),topRight: Radius.circular(5))
                      ),

                      child: const Row(
                        children: [
                           Icon(Icons.add_circle_outline_sharp , color: Colors.white,),
                           SizedBox(width: 5,),
                           Text('Ajouter' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10,),

                  InkWell(
                    onTap: (){
                      print('reclamation askForFile = ${this.widget.reclamation.files}');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      height: 50,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topRight: Radius.circular(5))
                      ),

                      child: const Row(
                        children: [
                           Icon(Icons.send_rounded , color: Colors.white,),
                           SizedBox(width: 5,),
                           Text('Envoyer la réclamation' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ),
                  )

                 
                ],
              ),
            ],
          ),
        ),
      ),
    );

    
  }

  void openFiles(List<PlatformFile> files,BuildContext context) =>
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => FilePage(files: files, onOpenedFile: openFile,reclamation: widget.reclamation),
    )
    );

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}