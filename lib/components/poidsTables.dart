import 'package:flutter/material.dart';

class PoidsTables extends StatefulWidget {
  // const PoidsTables({super.key});
 final List<Map<String, dynamic>> allweight;

  PoidsTables({required this.allweight});
  @override
  State<PoidsTables> createState() => _PoidsTablesState();
}

class _PoidsTablesState extends State<PoidsTables> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Weight')),
            // Add more columns as needed
          ],
          rows: widget.allweight.map((weight) {
            return DataRow(cells: [
              DataCell(Text(weight['date_prise'].toString())), // Adjust according to your data structure
              DataCell(Text(weight['valeur_poids'].toString())), // Adjust according to your data structure
              // Add more DataCells as needed
            ]);
          }).toList(),
        )
        
        );
  }
}