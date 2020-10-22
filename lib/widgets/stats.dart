import 'package:ccm/transactions/models/chart_data_sets.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/transactions/bloc/stats.dart';
import 'package:ccm/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return LoadingIndicator();
        } else if (state is StatsLoaded) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Billed:',
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.headline6,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      '${state.billed}',
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.subtitle1,
                        color: const Color(0xFFFF7043),
                      ),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Paid:',
                        style: GoogleFonts.openSans(
                          textStyle: Theme.of(context).textTheme.headline6,
                          color: Colors.greenAccent,
                        ),
                      ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      '${state.totalPaid}',
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.subtitle1,
                        color: state.totalPaid > state.billed ? Colors.green : Colors.red,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Dues:',
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.headline6,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      '${state.due}',
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.subtitle1,
                        color: Colors.red,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Advances:',
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.headline6,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "${state.advances}",
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.subtitle1,
                        color: Colors.green,
                      ),
                    ),
                  ),*/

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.blur_linear_sharp,
                          color: Colors.blue[900],
                        ),
                        SizedBox(width: 8.0,),
                        Text(
                          'Overview',
                          style: GoogleFonts.openSans(
                            textStyle: Theme.of(context).textTheme.headline5,
                            color: Colors.blue[900],
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: MediaQuery.of(context).size.height/2.1,
                      child: SFCategory(
                        state.sFChartData,)
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category,
                          color: Colors.blue[900],
                        ),
                        SizedBox(width: 8.0,),
                        Text(
                          'Expenditure by Category',
                          style: GoogleFonts.openSans(
                            textStyle: Theme.of(context).textTheme.headline5,
                            color: Colors.blue[900],
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.height/2.1,
                      child: DatumLegendWithMeasures(
                        _createData(state.chartData),
                        animate: false,)
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  static List<charts.Series<LinearExpenditure, String>> _createData( var data ) {
    return [
      new charts.Series<LinearExpenditure, String>(
        id: 'Category',
        domainFn: (LinearExpenditure expense, _) => expense.category,
        measureFn: (LinearExpenditure expense, _) => expense.expenditure,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearExpenditure row, _) => '${row.category}: ${row.expenditure}',
      )
    ];
  }

  static List<charts.Series<OrdinalStats, String>> _createOrdinalData(var data) {
    return [
      new charts.Series<OrdinalStats, String>(
        id: 'Head',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalStats head, _) => head.head,
        measureFn: (OrdinalStats head, _) => head.amount,
        data: data,
      )
    ];
  }

}

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }
}

class DatumLegendWithMeasures extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DatumLegendWithMeasures(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : '$value';
          },
        ),
      ],
    );
  }
}

class InitialSelection extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  InitialSelection(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.InitialSelection(selectedDataConfig: [
          new charts.SeriesDatumConfig<String>('Head', 'Billed')
        ])
      ],
    );
  }

}

class SFCategory extends StatelessWidget {
  final List<SFChartData> seriesData;

  SFCategory(this.seriesData);

  @override
  Widget build(BuildContext context) {

    return new SfCartesianChart(
      // Initialize category axis
        primaryXAxis: CategoryAxis(),

        series: <ColumnSeries<SFChartData, String>>[
          ColumnSeries<SFChartData, String>(
            // Bind data source
              dataSource:  seriesData,
              xValueMapper: (SFChartData data, _) => data.x,
              yValueMapper: (SFChartData data, _) => data.yValue,
            pointColorMapper: (SFChartData data, _) => data.pointColor,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ]
    );
  }

}
