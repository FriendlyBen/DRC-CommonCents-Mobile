import 'dart:async';
import 'dart:convert';
import 'package:commoncents/cubit/candlestick_cubit.dart';
import 'package:commoncents/cubit/miniChart_cubit.dart';
import '../apistore/PriceProposal.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/stock_data_cubit.dart';

WebSocketChannel? socket;
late StockDataCubit stockDataCubit;
const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

List<Map<String, dynamic>> ticks = [];
List<Map<String, dynamic>> candles = [];

final unsubscribeRequest = {"forget_all": "ticks"};

Map<String, dynamic> tickStream(String market) {
  Map<String, dynamic> request = {"ticks": market, "subscribe": 1};
  return request;
}

Map<String, dynamic> ticksHistoryRequest(String market) {
  Map<String, dynamic> request = {
    "ticks_history": "$market",
    "adjust_start_time": 1,
    "count": 100,
    "end": "latest",
    "start": 1,
    "style": "ticks"
  };
  return request;
}

Map<String, dynamic> CandleHistoryRequest(String market) {
  Map<String, dynamic> request = {
    "ticks_history": "$market",
    "adjust_start_time": 1,
    "count": 100,
    "end": "latest",
    "start": 1,
    "style": "candles"
  };

  return request;
}

Map<String, dynamic> CandleTicksRequest(String market) {
  Map<String, dynamic> request = {
    "ticks_history": "$market",
    "adjust_start_time": 1,
    "subscribe": 1,
    "count": 1,
    "end": "latest",
    "start": 1,
    "style": "candles"
  };

  return request;
}

Future<void> connectToWebSocket(
    {required BuildContext context,
    required bool isCandle,
    required String market}) async {
  socket = WebSocketChannel.connect(url);

  socket?.stream.listen((dynamic message) {
    try {
      handleResponse(data: message, isCandle: isCandle, context: context);
    } catch (e) {
      handleError(e);
    }
  }, onError: (error) {
    handleError(error);
  }, onDone: () {
    handleConnectionClosed();
  });

  if (isCandle) {
    subscribeCandleTicks(market);
  } else {
    subscribeTicks(market);
  }
}

void subscribeCandleTicks(String market) async {
  await requestCandleHistory(market);
  await candleTicks(market);
}

Future<void> requestCandleHistory(String market) async {
  final request = CandleHistoryRequest(market);
  socket?.sink.add(jsonEncode(request));
}

Future<void> candleTicks(String market) async {
  final request = CandleTicksRequest(market);
  socket?.sink.add(jsonEncode(request));
}

void subscribeTicks(String market) async {
  await requestTicksHistory(market);
  await tickSubscriber(market);
}

void unsubscribe() async {
  socket?.sink.add(jsonEncode(unsubscribeRequest));
  // stockDataCubit.clearStockData();
}

void closeWebSocket() {
  socket?.sink.close();
}

Future<void> tickSubscriber(String market) async {
  final request = tickStream(market);
  socket?.sink.add(jsonEncode(request));
}

Future<void> requestTicksHistory(String market) async {
  final request = ticksHistoryRequest(market);
  socket?.sink.add(jsonEncode(request));
}

Future<void> handleResponse(
    {required BuildContext context,
    required bool isCandle,
    required dynamic data}) async {
  final decodedData = jsonDecode(data);
  final List<Map<String, dynamic>> tickHistory = [];
  final List<Map<String, dynamic>> miniHistory = [];
  final stockDataCubit = BlocProvider.of<StockDataCubit>(context);

  if (decodedData['msg_type'] == 'proposal') {
    handleBuyResponse(context, decodedData);
  } else if (decodedData['msg_type'] == 'ohlc') {
    // Stream candles data
    final ohlc = decodedData['ohlc'];
    if (ohlc != null) {
      final double open = double.parse(ohlc['open']);
      final double high = double.parse(ohlc['high']);
      final double low = double.parse(ohlc['low']);
      final double close = double.parse(ohlc['close']);
      final double time = ohlc['open_time'].toDouble();

      if (candles.isNotEmpty) {
        final lastItem = candles.last;
        final double lastEpoch = lastItem['epoch'];

        if (time == lastEpoch) {
          lastItem['high'] = high;
          lastItem['low'] = low;
          lastItem['close'] = close;
          // lastItem['open'] = open;
        } else {
          candles.add({
            'high': high,
            'open': open,
            'close': close,
            'low': low,
            'epoch': time,
          });
        }
      } else {
        candles.add({
          'high': high,
          'open': open,
          'close': close,
          'low': low,
          'epoch': time,
        });
      }

      final candleStickData = BlocProvider.of<CandlestickCubit>(context);
      candleStickData.updateCandlestickData(candles);
    }
  } else if (decodedData['msg_type'] == 'candles') {
    //history candles data
    if (isCandle) {
      final List<dynamic> legitCandles = decodedData['candles'];
      for (int i = 0; i < legitCandles.length; i++) {
        final candle = legitCandles[i];
        final int epoch = candle['epoch'];
        DateTime utcTime =
            DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
        double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;
        final double high = candle['high'].toDouble();
        final double low = candle['low'].toDouble();
        final double close = candle['close'].toDouble();
        final double open = candle['open'].toDouble();

        candles.add({
          'high': high,
          'open': open,
          'close': close,
          'low': low,
          'epoch': utcTimeDouble
        });
      }
      if (candles.length > 101) {
        candles = candles.sublist(candles.length - 101);
      }

      final candleStickData = BlocProvider.of<CandlestickCubit>(context);
      candleStickData.updateCandlestickData(candles);
    }
  } else if (decodedData['msg_type'] == 'history') {
    //lines historty
    final List<dynamic> prices = decodedData['history']['prices'];
    final List<dynamic> times = decodedData['history']['times'];

    for (int i = 0; i < prices.length; i++) {
      final double quote = prices[i].toDouble();
      final int epoch = times[i];

      DateTime utcTime =
          DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
      double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      tickHistory.add({
        'close': quote,
        'epoch': utcTimeDouble,
      });
    }
    ticks = tickHistory;
    print(ticks.length);
  } else if (decodedData['msg_type'] == 'tick') {
    final tickData = decodedData['tick'];

    if (tickData != null) {
      final double price = tickData['quote'].toDouble();
      final int time = tickData['epoch'];
      DateTime utcTime =
          DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
      double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      // Append the latest tick price and time to the ticks list
      ticks.add({'close': price, 'epoch': utcTimeDouble});
    }

    stockDataCubit.updateStockData(ticks); // this is for line chart
  }
}

void handleError(dynamic error) {
  print("Failed to get data: $error");
}

void handleConnectionClosed() {
  print("Connection closed");
}
