import 'package:firestore_record/app_providers/record_provider.dart';
import 'package:firestore_record/dependency_injection.dart';
import 'package:firestore_record/route/routeString.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app_providers/authentication_provider.dart';
import 'detailsScreen/detail_screen.dart';


class RecordHomeScreen extends StatefulWidget {
  const RecordHomeScreen({super.key});

  @override
  State<RecordHomeScreen> createState() => _RecordHomeScreenState();
}

class _RecordHomeScreenState extends State<RecordHomeScreen> {

  final _authProvider = sl<AuthenticationProvider>();
  final recordProvider = sl<RecordProvider>();

  @override
  void initState() {
     Future.delayed(const Duration(milliseconds: 0),(){
       recordProvider.getUserRecord(userId: _authProvider.getUserUId.toString());

     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle title =  const TextStyle(fontWeight: FontWeight.bold,fontSize: 14);
    TextStyle detail =  const TextStyle(fontWeight: FontWeight.w500,fontSize: 14);

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade400,
          title: const Text("Records",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          centerTitle: true,
          leading:  IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back,color: Colors.white)),
        ),
        body: Consumer<RecordProvider>(builder: (context, recordState, child) {
          if(recordProvider.getRecordStatus == RecordStatus.loading){
            return const  Center(child: CircularProgressIndicator());
          }
          return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: recordState.addRecordModel.isNotEmpty

           ? ListView.builder(
                itemCount: recordState.addRecordModel.length,
                itemBuilder: (context,index){
                  final data = recordState.addRecordModel[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>   RecordDetailScreen(addRecordModel: data)));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 1),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 2), // changes position of shadow
                            ),
                          ],

                        ),
                        child:  Padding(
                          padding: const EdgeInsets.only(left: 10.0,top: 15,bottom: 15),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name:         ",style: title),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      child: SizedBox(
                                        //color: Colors.red,
                                          width: MediaQuery.of(context).size.width * 0.65,
                                          child:  Text(data.name.toString(),style: detail,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                    ),

                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("About Me:   ",style: title),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: SizedBox(
                                      //color: Colors.red,
                                        width: MediaQuery.of(context).size.width * 0.65,
                                        child:  Text(data.about.toString(),style: detail,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                  ),

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
           :  Center(child: Text("No Records Found",style: title.copyWith(fontSize: 20),)),
          );
        }),



        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo.shade400,

          onPressed: (){
            Navigator.pushNamed(context, RouteString.addHomeRoute);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRecordScreen()));
          },
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      );










  }

}
