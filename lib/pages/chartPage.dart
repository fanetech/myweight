import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gardesmonpoids/bd.dart';
import 'package:gardesmonpoids/components/poidsTables.dart';

class Chartpage extends StatefulWidget {

  @override
  State<Chartpage> createState() => _ChartpageState();
}

class _ChartpageState extends State<Chartpage> {
 List<Map<String, dynamic>> allweight = [];
 
   @override
  void initState() {
    super.initState();
    fetchWeightData();
  }

    Future<void> fetchWeightData() async {
      final db = await BD.instance.database;
    final data = await BD.instance.obtenirHistoriquePoids();
    setState(() {
      allweight = data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
      ),
      body: Center(
        child: Container(
    height: 300,
    width: 50,
    child: allweight.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: allweight
                        .asMap()
                        .entries
                        .map((e) => FlSpot(
                            e.key.toDouble(), e.value['valeur_poids'].toDouble()))
                        .toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
  )
      ),
    );
  }
}