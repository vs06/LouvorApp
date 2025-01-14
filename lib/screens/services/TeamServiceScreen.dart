import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/screens/services/service_screen.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:intl/intl.dart';

class TeamServiceScreen extends StatefulWidget {

  List<Song> _lstSongSelecionadas = new List<Song>();
  Service service;

  TeamServiceScreen.buildTeamServiceScreen(Service s) {
    service = s;

    if(service.lstSongs != null){
      _lstSongSelecionadas.addAll(service.lstSongs);
    } else {
      service.lstSongs = new List();
    }
  }

  TeamServiceScreen(Service s) : service = s != null ? s.clone() : Service();

  @override
  State<StatefulWidget> createState() {
    return TeamServiceScreenState();
  }

}

class TeamServiceScreenState extends State<TeamServiceScreen> {

  String valueRoleDropDownSelected = AppListPool.serviceRoles[0];
  String valueUserDropDownSelected = AppListPool.usersName[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
        title: Text('Culto ${widget.service.data != null ? DateUtils.convertDatePtBr(widget.service.data) : ''} ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                            fontSize: 18,
                           )
                    ),
        centerTitle: true,
      ),
      body:
      Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8),
              child : Column(
                  children: [
                    Card( shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.all(10),
                        child:
                        Center(
                          child:
                          Column(
                            children: <Widget>[
                              const SizedBox(width: 16,),
                              Row(
                                children: [
                                  Expanded(
                                   // flex: 5,
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                            children: [
                                              Text('Função',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w800,
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              ),
                                            ]
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 140.0,
                                                  child:
                                                      DropdownButton<String>(
                                                      value: valueRoleDropDownSelected,
                                                      icon: const Icon(Icons.arrow_downward),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      style: const TextStyle(color: Colors.deepPurple),
                                                      underline: Container(
                                                        height: 2,
                                                        color: Colors.lightBlue,
                                                      ),
                                                      onChanged: (String newValue) {
                                                        setState(() {
                                                          valueRoleDropDownSelected = newValue;
                                                        });
                                                      },
                                                      items: AppListPool.serviceRoles.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    )
                                            )
                                            //DropDownListString(AppListPool.serviceRoles),
                                          ],

                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                   // flex: 5,
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                            children: [
                                              Text('Voluntário',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w800,
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              ),
                                            ]
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                width: 140.0,
                                                child:
                                                    DropdownButton<String>(
                                                      value: valueUserDropDownSelected,
                                                      icon: const Icon(Icons.arrow_downward),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      isExpanded: true,
                                                      style: const TextStyle(color: Colors.deepPurple),
                                                      underline: Container(
                                                        height: 2,
                                                        color: Colors.lightBlue,
                                                      ),
                                                      onChanged: (String newValue) {
                                                        setState(() {
                                                          valueUserDropDownSelected = newValue;
                                                        });
                                                      },
                                                      items: AppListPool.usersName.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(value, overflow: TextOverflow.ellipsis,),
                                                        );
                                                      }).toList(),
                                                    )
                                            )
                                            //DropDownListString(AppListPool.users),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              Center(
                                child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 2, // 20%
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                            child:
                                            Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                            GestureDetector(
                                                              onTap: () { addTeamMap(valueRoleDropDownSelected, valueUserDropDownSelected); },
                                                              child: Icon(
                                                                Icons.add_circle_sharp,
                                                                color: Colors.lightBlue,
                                                                size: 40,
                                                              ),
                                                            )
                                                      ]
                                                  ),
                                                ]
                                            )
                                           ),
                                        ),
                                      ],
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
              )

          ),
          Text('Selecionados',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).primaryColor
            ),
          ),
          Expanded(
            flex: 4, // 40%
            child:
                Column( children: <Widget>[
                                            ListView.builder(
                                                padding: const EdgeInsets.all(8),
                                                itemCount: widget.service.team != null ? widget.service.team.length : 0,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  String role =  widget.service.team.keys.elementAt(index);
                                                  return
                                                    Column(
                                                        children: <Widget>[
                                                             Card(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(4)
                                                              ),
                                                              child: Container(
                                                                height: 40,
                                                                padding: const EdgeInsets.all(8),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    const SizedBox(width: 16,),
                                                                        Column( children: <Widget>[
                                                                          Expanded(
                                                                            flex: 5,
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    Text( role +':',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w800,
                                                                                        color: Colors.lightBlue,
                                                                                      ),
                                                                                    ),

                                                                                    Text( splitVolunteers(widget.service.team[role]),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w800,
                                                                                      ),
                                                                                    ),

                                                                                    Align(
                                                                                      alignment: Alignment.center,
                                                                                      child:
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            widget.service.team.remove(widget.service.team.keys.elementAt(index));
                                                                                          });
                                                                                        },
                                                                                        child:Icon(Icons.delete , color: Colors.blueGrey,),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                // tentativa de listar os volunteers por role, para edicao em separado
                                                                                // Column(
                                                                                //   children: [
                                                                                //                   Row(
                                                                                //                             children: [
                                                                                //                                       ListView.builder(
                                                                                //                                       padding: const EdgeInsets.all(8),
                                                                                //                                       itemCount: widget.service.team[role].length,
                                                                                //                                       shrinkWrap: true,
                                                                                //                                       itemBuilder: (BuildContext context, int index) {
                                                                                //                                             String users =  widget.service.team[role].elementAt(index);
                                                                                //                                             return Expanded(child: Card(shape:
                                                                                //                                                             RoundedRectangleBorder(
                                                                                //                                                             borderRadius: BorderRadius.circular(4)
                                                                                //                                                             )
                                                                                //                                                             )
                                                                                //                                                     );}
                                                                                //                                       )
                                                                                //
                                                                                //                             ],
                                                                                //                   )
                                                                                //   ],
                                                                                // ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                       ]
                                                                     )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                      ]
                                                  );
                                                }
                                            ),
                        ]
                      )

          ),
          ElevatedButton.icon(
            onPressed: () {
              widget.service.lstSongs.clear();
              widget.service.lstSongs.addAll(widget._lstSongSelecionadas);
              //fillSongsNameIntoService(widget.service);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ServiceScreen(widget.service))
              );
            },
            icon: Icon(Icons.add, size: 10),
            label: Text("Adicionar selecionados"),
          ),
        ],
      ),
    );
  }

  String splitVolunteers(List<String> lstVolunteers) {
    String volunteers = "";
    int counter = lstVolunteers.length;
    lstVolunteers.forEach((element) {
                                      volunteers += element;
                                      counter--;
                                      if(counter > 0)
                                        volunteers +=  ', ';
                                    }
                         );
    return  volunteers;
  }

  void addTeamMap(String valueRoleDropDownSelected, String valueUserDropDownSelected) {
    if(!valueRoleDropDownSelected.isEmpty && !valueUserDropDownSelected.isEmpty){

      if(widget.service.team.containsKey(valueRoleDropDownSelected)){
        if(!widget.service.team[valueRoleDropDownSelected].contains(valueUserDropDownSelected)){
          setState(() {
            widget.service.team[valueRoleDropDownSelected].add(valueUserDropDownSelected);
          });
        }else{
          setState(() {
            widget.service.team.putIfAbsent(valueRoleDropDownSelected, () => [valueUserDropDownSelected]);
          });
        }
      } else {
        setState(() {
          widget.service.team.putIfAbsent(valueRoleDropDownSelected, () => [valueUserDropDownSelected]);
        });
      }
    }
  }

}