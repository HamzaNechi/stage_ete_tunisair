import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:billet_faveur/screens/admin/add_user.dart';
import 'package:billet_faveur/screens/admin/detail_user.dart'; 
import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:billet_faveur/utils/crud.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/user.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

  Crud crud = Crud();

  //list of users
  List<User> list_of_users = [];
  List<User> search_list_of_users = [];
  List<User> main_list_of_users = [];

  late Future<bool> fetchedData;


  getAllUSers() async {
     var response = await crud.getRequest(userUrl,sharedPref.getString('accessToken')!);
     if(response['statusCode'] == 200){
      
      
      List<dynamic> data = response['data'];

      for(var item in data){
        
        var user = User(int.parse(item['id']), item['nom'], item['prenom'], item['email'], item['tel'], int.parse(item['matricule']), item['cin'], item['image'], item['role']);
        list_of_users.add(user);
      }

      setState(() {
          main_list_of_users.clear();
          main_list_of_users.addAll(list_of_users);
        });
     }
  }


  Future<void> deleteUser(User user)async {
    var id_user = user.id;
    var response = await crud.deleteRequest(
      '$userUrl?id_user=$id_user', 
      sharedPref.getString('accessToken')!
    );

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
              child: Text('OK' , style: TextStyle(color: Colors.blue),)),
          ],
        ),
        title: 'Succés',
        body: Text(response['message'])
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
              child: Text('OK' , style: TextStyle(color: Colors.blue),)),
          ],
        ),
        title: 'Warning !',
        body: Text(response['message'])
        )..show();
    }
  }

  @override
  void initState() {
    super.initState();
    getAllUSers();
  }

  void updateList(String value)async {
    setState(() {
      search_list_of_users.clear();
    });
    // this is the function that will filter our list
    if(value.isNotEmpty){      
      var response = await crud.getRequest('$userUrl?nom_user=$value',sharedPref.getString('accessToken')!);
      print('print update list user $response'); 
      if(response['statusCode'] == 200){
        List<dynamic> data = response['data'];
        for(var item in data){          
          var user = User(int.parse(item['id']), item['nom'], item['prenom'], item['email'], item['tel'], int.parse(item['matricule']), item['cin'], item['image'], item['role']);  
          search_list_of_users.add(user);
        }

        setState(() {
            main_list_of_users.clear();
            main_list_of_users.addAll(search_list_of_users);
          });
      }
    }else{
      setState(() {
          main_list_of_users.clear();
          list_of_users.clear();
          search_list_of_users.clear();
          getAllUSers();
      });
    }   
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.86,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: defaultPadding+10,),
           Padding(
            padding:const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Recherche" , style: TextStyle(
                color: Colors.black87,
                fontSize: 22.0,
                fontWeight: FontWeight.bold
                ),),

                InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser(
                          onUserCreated: (userCreated) {
                            if(userCreated){
                              //refresh list
                              setState(() {
                                main_list_of_users.clear();
                                list_of_users.clear();
                                search_list_of_users.clear();
                                getAllUSers();
                              });
                            }
                          },
                        ),));
                      },
                      child: Container(
                        padding:const EdgeInsets.all(8),
                        height: 40,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topRight: Radius.circular(5))
                        ),
          
                        child: const Row(
                          children: [
                             Icon(Icons.add_circle_outline_sharp , color: Colors.white,),
                             SizedBox(width: 5,),
                             Text('Nouveau' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),

    
        const SizedBox(height: defaultPadding+4,),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: TextField(
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: secondColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none
              ),
              hintText: "Recherche par nom",
              prefixIcon: const Icon(Icons.search)
            ),
            onChanged: (value) {
              setState(() {
                updateList(value);
              });
            },
          ),
        ),

          Expanded(
            child: ListView.builder(
                      itemCount: main_list_of_users.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: ValueKey<User>(main_list_of_users[index]),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red
                            ),
                          ),

                          confirmDismiss: (DismissDirection direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirmation de suppression"),
                                              content: const Text("Êtes-vous sûr de vouloir supprimer cet utilisateur ?"),
                                              actions: <Widget>[

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children :[

                                                  
                                                  InkWell(
                                                    onTap: () {  
                                                      
                                                      Navigator.of(context).pop(true);
                                                    },
                                                    child: Container(
                                                      padding:const EdgeInsets.all(15),
                                                      height: 50,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topRight: Radius.circular(5))
                                                      ),

                                                      child: const Row(
                                                        children: [
                                                          Icon(Icons.delete , color: Colors.white,),
                                                          SizedBox(width: 5,),
                                                          Text('Supprimer' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500),)
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(width: 5,),


                                                  InkWell(
                                                    onTap: () {  
                                                      Navigator.of(context).pop(false);
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(15),
                                                      height: 50,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topRight: Radius.circular(5))
                                                      ),

                                                      child: const Row(
                                                        children: [
                                                          Icon(Icons.cancel , color: Colors.white,),
                                                          SizedBox(width: 5,),
                                                          Text('Annuler' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500),)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  ]
                                                ),
                                              ],
                                            )
                                            ;
                                          },
                                        );
                                      },
                          onDismissed: (direction) {
                            
                            deleteUser(main_list_of_users[index]);
                            setState(() {
                              main_list_of_users.removeAt(index);
                            });
                          },
                          child: ListTile(
                            
                            title: Text('${main_list_of_users[index].nom} ${main_list_of_users[index].prenom}',style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                            ),),
                          
                            subtitle: Text(main_list_of_users[index].email!,style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.normal
                            ),),
                          
                            trailing: FloatingActionButton(
                              heroTag: "detail_btn${main_list_of_users[index].id}",
                              onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailUser(user: main_list_of_users[index]),));
                            },
                            backgroundColor: const Color.fromARGB(255, 216, 163, 1),
                            elevation: 1,
                            mini: true,
                            child: const Icon(Icons.remove_red_eye_outlined),
                            ),
                          
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage("$imageUrl/${main_list_of_users[index].image}"),
                            ),
                          ),
                        );
                      }
                    ),
          ),
        ],
      ),
    );
  }
}

