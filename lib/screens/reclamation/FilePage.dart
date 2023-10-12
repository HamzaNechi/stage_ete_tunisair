import 'dart:convert';
import 'package:billet_faveur/main.dart';
import 'package:billet_faveur/screens/reclamation/result_reclamation.dart';
import 'package:http/http.dart' as http;
import 'package:billet_faveur/models/reclamation.dart';
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:billet_faveur/utils/crud.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';

class FilePage extends StatefulWidget {
  final List<PlatformFile> files;
  final ValueChanged<PlatformFile> onOpenedFile;
  final Reclamation reclamation;
  const FilePage({super.key, required this.files, required this.onOpenedFile , required this.reclamation});


  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {

  Crud crud = Crud();

  reclamer() async {
    final uri = Uri.parse(sendReclamationUrl);
    final request = http.MultipartRequest('POST',uri);
    request.fields['sujet'] = widget.reclamation.sujet!;
    request.fields['text'] = widget.reclamation.text!;
    request.fields['matricule_user'] = sharedPref.getString("matUser")!;
    // Ajouter l'accessToken à l'en-tête "Authorization"
    String accessToken = sharedPref.getString('accessToken')!;
    request.headers['Authorization'] = 'Bearer $accessToken';
    
    if(widget.reclamation.files != null && widget.reclamation.files!.isNotEmpty){
      for(var elem in widget.reclamation.files!){
        final file = await http.MultipartFile.fromPath('files[]', elem.path!);
        request.files.add(file);
      }
    }

    var response = await request.send();
    final parsedResponse = await response.stream.bytesToString();
    final responseList = jsonDecode(parsedResponse);
    final resultMap = <String, String>{};

    for (var item in responseList) {
      if (item is Map<String, dynamic>) {
        item.forEach((key, value) {
          resultMap[key] = value.toString();
        });
      }
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ResponseReclamation(map: resultMap),), (route) => false);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        
            

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.2,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60))
              ),


              child:Padding(
                padding: const EdgeInsets.only(top: 80),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Gérer tes fichiers' , style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),),


                    const SizedBox(height: 8,),


                    InkWell(
                      onTap: () async {
                        final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                        if(result == null) return ;
              
                        setState(() {
                          widget.files.addAll(result.files);
                        });
                      },

                      child: const Icon(Icons.file_upload_outlined,color: Colors.white, size: 30,),
                    )
                  ],
                ),
                ),

            ),
            Expanded(
              flex: 1,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8
                  ), 
                  itemCount: widget.files.length,
                  itemBuilder: (context, index) {
                  final file = widget.files[index];
                  return buildFile(file);
                },
                ),
            ),
        
              // const SizedBox(height: defaultPadding,),
        
              // InkWell(
              //   onTap: () async {
              //     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
              //     if(result == null) return ;
        
              //     setState(() {
              //       widget.files.addAll(result.files);
              //     });
                  
              //   },
              //   child: Container(
              //     height: 60,
              //     width: MediaQuery.of(context).size.width,
              //     margin: const EdgeInsets.symmetric(horizontal: 15).copyWith(
              //       bottom: 16
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.grey[400],
              //       borderRadius: BorderRadius.circular(20)
              //     ),
              //     child: const Center(
              //       child:  Text(
              //           "Ajouter des fichiers",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 17),
              //         ),
              //     ),
              //   ),
              // ),
        
        
              //const SizedBox(height: defaultPadding,),
        
              InkWell(
                onTap: () {
                  setState(() {
                    widget.reclamation.files!.addAll(widget.files);
                  });

                  reclamer();
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 15).copyWith(
                    bottom: 16
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: const Center(
                    child:  Text(
                        "Confirmer et Envoyer",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
  
  Widget buildFile(PlatformFile file) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = file.extension ?? 'none' ;
    final color = getColor(extension);
    return InkWell(
      onTap: () => OpenFile.open(file.path!),
      child: Stack(
        children: [
          Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start
            ,
      
            children: [
              Expanded(
                child:Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(extension , style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),),
                ) ,
                ),
      
                Text(file.name , style: const TextStyle(fontWeight: FontWeight.w400),),
      
                Text(fileSize , style: const TextStyle(fontWeight: FontWeight.w200),),
            ],
          ),
        ),


         Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              setState(() {
                widget.files.remove(file);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(FontAwesomeIcons.trash , size: 30, color: (color == Colors.red[400] ? Colors.amber : Colors.red),),
              ),
          )
          )
        ]
      ),
    );
  }

  Color? getColor(String extension) {
    switch (extension){
      case 'pdf' : return Colors.red[400];
      case 'mp4' : return Colors.blue;
      case 'mp3' : return Colors.green[400];
      default : return Colors.amber[400];
    }
  }
}