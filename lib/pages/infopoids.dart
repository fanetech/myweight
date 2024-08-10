import 'package:flutter/material.dart';
import '../bd.dart';
import 'package:fl_chart/fl_chart.dart';

class InfoPoids extends StatefulWidget {
  final String nom;
  final String prenom;
  final String username;
  InfoPoids({required this.nom, required this.prenom, required this.username});
  @override
  _InfoPoidsState createState() => _InfoPoidsState();
}

class _InfoPoidsState extends State<InfoPoids> {
  String valeur_poids = '';
  String date_prise = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> allweight = [];

  @override
  void dispose() {
    _poidsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchWeightData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      print(_poidsController.text);
      print(_dateController.text);
      // If all fields are valid, display a snackbar
      final db = await BD.instance.database;
      await db.insert('poids', {
        'valeur_poids': _poidsController.text,
        'date_prise': _dateController.text,
      });
      final allw = await BD.instance.obtenirHistoriquePoids();
      setState(() {
        allweight = allw;
      });
      print(allweight);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully!')),
      );
      // You can perform any additional logic here, like sending data to a server
    }
  }

  Future<void> fetchWeightData() async {
    final data = await BD.instance.obtenirHistoriquePoids();
    setState(() {
      allweight = data;
    });
  }

  void deleteRecord(int id) async {
  int result = await BD.instance.deleteData(id);
  if (result > 0) {
    print('Record deleted');
  } else {
    print('No record found with id $id');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Renseigner votre poids'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          Container(
          color: Colors.blue[900],
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Poids (kg)',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _poidsController,
                  decoration: InputDecoration(
                    labelText: 'Poids (kg)',
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre poids';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Date de prise',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date (jour-mois-année)',
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la date';
                    }
                    final RegExp dateRegExp = RegExp(
                      r'^(\d{1,2})-(\d{1,2})-(\d{4})$',
                    );
                    if (!dateRegExp.hasMatch(value)) {
                      return 'Veuillez entrer la date au format jour-mois-année';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _submitForm();
                      },
                      child: Text('Enregistrer', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                       Navigator.pushReplacementNamed(context, '/chart');
                      },
                      child: Text('Voir le graphique', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
 SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Weight')),
                        // Add more columns as needed
                      ],
                      rows: allweight.map((weight) {
                        return DataRow(cells: [
                          DataCell(Text(weight['date_prise']
                              .toString())), // Adjust according to your data structure
                          DataCell(Text(weight['valeur_poids']
                              .toString())), // Adjust according to your data structure
                          // Add more DataCells as needed
                        ]);
                      }).toList(),
                    ),
                    ),
                  ]
                ),
               
                    Chart(context, allweight)
              ],
            ),
          ),
        ),
        ],
        
      ),
    );
  }
}

Widget Chart(BuildContext context, List<Map<String, dynamic>> allweight) {
  return Container(
    height: 300,
    width: MediaQuery.of(context).size.width,
    child: allweight.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            
            child:  allweight.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: allweight.map((weight) {
                    return PieChartSectionData(
                      color: Colors.blue, // You can assign different colors based on categories
                      value: weight['valeur_poids'].toDouble(), // Weight as value
                      title: '${weight['valeur_poids']} kg', // Title for each section
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
    )
  );
}
