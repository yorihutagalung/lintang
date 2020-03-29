import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = 'A2C1D680-BE36-4886-8336-9F06F99BC6D1';

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
    CoinData coinData = CoinData(
        'https://rest.coinapi.io/v1/exchangerate/$cryptolist/$currency?apikey=$apiKey');

    var coinCurrency = await coinData.getCoinData() as Map<String, dynamic>;
    var newRate = coinCurrency['rate'] as double;
    return newRate.toStringAsFixed(2);
  }
}
