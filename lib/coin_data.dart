import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '5AF12FDF-1374-4650-A294-027BD612418C';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  CoinData(this.url);

  final String url;

  Future<dynamic> getCoinData() async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

class CoinDataModel {
  Future<String> getCoinDataModel(String currency, String cryptolist) async {
    var url = 'https://rest.coinapi.io/v1/exchangerate/$cryptolist/$currency?apikey=$apiKey';
    CoinData coinData = CoinData(url);
    var coinCurrency = await coinData.getCoinData() as Map<String, dynamic>;
    var newRate = coinCurrency['rate'];
    if (newRate is int) {
      return newRate.toString();
    } else {
      return newRate.toStringAsFixed(2);
    }
  }
}
