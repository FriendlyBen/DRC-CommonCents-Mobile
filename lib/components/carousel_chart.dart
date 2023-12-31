import 'package:commoncents/components/formatMarkets.dart';
import 'package:commoncents/cubit/miniChart_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../apistore/miniChartData.dart';
import '../pages/simulationpage.dart';

class CarouselChart extends StatefulWidget {
  const CarouselChart({Key? key}) : super(key: key);

  @override
  _CarouselChartState createState() => _CarouselChartState();
}

class _CarouselChartState extends State<CarouselChart> {
  MiniChartCubit miniChartCubit = MiniChartCubit();
  late Map<String, Map<String, dynamic>> marketData;
  List<FlSpot> spots = [];
  late double last = 0.0;
  late List<String> items;

  @override
  void initState() {
    super.initState();

    items = [
      'Volatility 10',
      'Volatility 25',
      'Volatility 50',
      'Volatility 75',
      'Volatility 100',
      'Volatility 10 (1S)',
      'Volatility 25 (1S)',
      'Volatility 50 (1S)',
      'Volatility 75 (1S)',
      'Volatility 100 (1S)',
      'Jump 10',
      'Jump 25',
      'Jump 50',
      'Jump 75',
      'Jump 100',
      'Bear Market',
      'Bull Market',
    ];
    miniChartCubit = MiniChartCubit();
    marketData = {};
    // Establish a WebSocket connection
    connectWebSocket(context);
  }

  @override
  void dispose() {
    // miniChartCubit.close();
    closeMiniWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final market = items[index];
        return Stack(
          children: [
            Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: [
                Text(formatMarkets(market)),
                BlocBuilder<MiniChartCubit, List<Map<String, dynamic>>>(
                  bloc: minichartCubit,
                  builder: (context, miniData) {
                    if (miniData.isNotEmpty) {
                      var dataForMarket = miniData.firstWhere(
                        (entry) => entry.containsKey(formatMarkets(market)),
                        orElse: () => {},
                      );
                      var spots = <FlSpot>[];
                      if (dataForMarket.isNotEmpty) {
                        var data = dataForMarket[formatMarkets(market)];
                        for (var item in data) {
                          double x = item['epoch'];
                          double y = item['close'];
                          spots.add(FlSpot(x, y));
                        }
                      }
                      if (spots.isNotEmpty) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, anim1, anim2) => SimulationPage(market: market),
                                      transitionDuration: Duration.zero),
                                );
                              },
                              child: SizedBox(
                                height: 120,
                                width: 120,
                                child: SfCartesianChart(
                                  plotAreaBorderColor: Colors.transparent,
                                  borderWidth: 0,
                                  primaryXAxis: DateTimeAxis(
                                    isVisible: false,
                                  ),
                                  primaryYAxis: NumericAxis(isVisible: false),
                                  series: <ChartSeries>[
                                    LineSeries<FlSpot, DateTime>(
                                      dataSource: spots,
                                      xValueMapper: (FlSpot spot, _) =>
                                          DateTime.fromMillisecondsSinceEpoch(
                                              spot.x.toInt() * 1000,
                                              isUtc: true),
                                      yValueMapper: (FlSpot spot, _) => spot.y,
                                      yAxisName: 'secondaryYAxis',
                                      width: 2.0,
                                      color: spots.isNotEmpty &&
                                              spots[spots.length - 2].y >
                                                  spots.last.y
                                          ? Colors.redAccent
                                          : Colors.greenAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: spots.isNotEmpty &&
                                        spots[spots.length - 2].y > spots.last.y
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text(
                                spots.last.y.toString(),
                                // style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, anim1, anim2) => SimulationPage(market: market),
                      transitionDuration: Duration.zero),
                );
              },
              child: Container(height: 120,
                width: 120,
                color: Colors.transparent,
              ),
            ),
          ]
        );
      },
    ));
  }
}