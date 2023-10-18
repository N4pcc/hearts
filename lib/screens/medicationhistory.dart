import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class HEARTSMyRidesScreen extends StatefulWidget {
  @override
  State<HEARTSMyRidesScreen> createState() => _HEARTSMyRidesScreenState();
}

class _HEARTSMyRidesScreenState extends State<HEARTSMyRidesScreen> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Emergency History'),
                Tab(text: 'Medication History'),
              ],
            ),
            title: const Text('Medication and Emergency History')),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  const SizedBox(
                    height: 100,
                    // child: HeaderWidget(100, false, Icons.house_rounded),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Emergency History",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              const ListTile(
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4),
                                                leading: Icon(
                                                    Icons.emergency_rounded),
                                                title: Text(
                                                    "Have you ever been in an emergency situation"),
                                                subtitle: Text("optional"),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.emergency_rounded),
                                                title: Text(
                                                    "What was the reason for your previous emergency"),
                                                subtitle: Text("optional"),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.emergency_rounded),
                                                title: Text(
                                                    "Do you have any chronic medical conditions that \n  may lead to an emergency"),
                                                subtitle: Text("optional"),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.emergency_rounded),
                                                title: Text(
                                                    "Do you have any allergies or adverse reactions to\n medications that may cause an emergency"),
                                                subtitle: Text("optional."),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.emergency_rounded),
                                                title: Text(
                                                    "Do you have any medical devices or implants\n that may require emergency intervention"),
                                                subtitle: Text("optional."),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Stack(
                children: [
                  const SizedBox(
                    height: 100,
                    // child: HeaderWidget(100, false, Icons.house_rounded),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Medication History",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              const ListTile(
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4),
                                                leading: Icon(
                                                    Icons.local_pharmacy),
                                                title: Text(
                                                    "Do you take any prescription medications?"),
                                                subtitle: Text("optional"),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.local_pharmacy),
                                                title: Text(
                                                    "wat are the names of the medications you \n are taking?"),
                                                subtitle: Text("optional"),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.local_pharmacy),
                                                title: Text(
                                                    "what is the dosage and frequency of each \n medication?"),
                                                subtitle: Text("optional"),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.local_pharmacy),
                                                title: Text(
                                                    "Have you ever had an allergic reaction \n to any medication?"),
                                                subtitle: Text("optional."),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.local_pharmacy),
                                                title: Text(
                                                    "Are you taking any over-the-counter medications,\n vitamins or supplements? "),
                                                subtitle: Text("optional."),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.local_pharmacy),
                                                title: Text(
                                                    "Do you have a history of medication non-compliance? "),
                                                subtitle: Text("optional."),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.local_pharmacy),
                                                title: Text(
                                                    "Have you ever been hospitalized due to \n medication-related complications? "),
                                                subtitle: Text("optional."),
                                              ),
                                              const ListTile(
                                                leading: Icon(
                                                    Icons.local_pharmacy),
                                                title: Text(
                                                    "Do you have any concerns or questions about \n your medication regimen? "),
                                                subtitle: Text("optional."),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
