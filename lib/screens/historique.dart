import 'package:billet_faveur/utils/colors.dart';
import 'package:billet_faveur/utils/constants.dart';
import 'package:flutter/material.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {


  var data =[
    {'image':'assets/images/mastercard.png','status':'Succés','montant':'100','date':'12-07-2023'},
    {'image':'assets/images/poste.png','status':'Rejetée','montant':'80','date':'12-07-2023'},
    {'image':'assets/images/mastercard.png','status':'Succés','montant':'250','date':'12-07-2023'},
    {'image':'assets/images/visa.png','status':'En attente','montant':'180','date':'12-07-2023'},
    {'image':'assets/images/poste.png','status':'Succés','montant':'100','date':'12-07-2023'},
    {'image':'assets/images/mastercard.png','status':'Rejetée','montant':'280','date':'12-07-2023'},
    {'image':'assets/images/visa.png','status':'Succés','montant':'60','date':'12-07-2023'},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding,),


        Container(
          width: MediaQuery.of(context).size.width*0.92,
          height: MediaQuery.of(context).size.height * 0.2,
          padding:const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(24)
          ),

          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Balance",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),

                      
                    ),

                    SizedBox(height: 2,),

                    Text(
                      "2800 DT",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),

                      
                    ),
                  ],
                )
                ),


                Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Carte",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),

                      
                    ),

                    SizedBox(height: 2,),

                    Text(
                      "Ma carte",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),

                      
                    ),
                  ],
                )
                )
            ],
          ),
        ),


        const SizedBox(height: defaultPadding,),


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  OutlinedButton(
                    onPressed: (){}, 
                    child: Icon(Icons.payment_outlined, color:Colors.black,),
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      side: const BorderSide(color: Colors.transparent),
                      padding: const EdgeInsets.all(16),
                      elevation: 5,
                      backgroundColor: Colors.grey[300],
                      shadowColor: Colors.grey.withOpacity(0.2)
                    ),
                    )
                ],
              ),

              Column(
                children: [
                  OutlinedButton(
                    onPressed: (){}, 
                    child: Icon(Icons.money_off_csred_outlined, color:Colors.black,),
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      side: const BorderSide(color: Colors.transparent),
                      padding: const EdgeInsets.all(16),
                      elevation: 5,
                      backgroundColor: Colors.grey[300],
                      shadowColor: Colors.grey.withOpacity(0.2)
                    ),
                    )
                ],
              ),


              Column(
                children: [
                  OutlinedButton(
                    onPressed: (){}, 
                    child: Icon(Icons.date_range, color:Colors.black,),
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      side: const BorderSide(color: Colors.transparent),
                      padding: const EdgeInsets.all(16),
                      elevation: 5,
                      backgroundColor: Colors.grey[300],
                      shadowColor: Colors.grey.withOpacity(0.2)
                    ),
                    )
                ],
              ),


            ],
          ),


        ),

        const SizedBox(height: defaultPadding,),

        Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('Les paiements',style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,

              ),),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset(data[index]['image'].toString()),
                ),
                title: Text(
                  data[index]['status'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green
                  ),
                ),
                subtitle: Text(
                  data[index]['date'].toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                trailing:Text(
                  '${data[index]['montant']} DT',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ),
          ],
        )

      ],
    );
  }
}

getColor(String status) {
  if(status == 'Succés'){
    return Colors.green;
  }else{
    if(status == 'Rejetée'){
      return Colors.red;
    }else{
      return Colors.blue;
    }
  }
}