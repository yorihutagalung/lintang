import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  CoinDataModel coinDataModel = CoinDataModel();
  String selectedRate = '0';
  String selectedRate2 = '0';
  String selectedRate3 = '0';

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropDownMenuList = [];

    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var menuItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropDownMenuList.add(menuItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownMenuList,
      onChanged: (value) => dropDownItemChange(value),
    );
  }

  void dropDownItemChange(String selectedValue) async {
    var btcRate =
        await coinDataModel.getCoinDataModel(selectedValue, cryptoList.first);
    var ethRate =
        await coinDataModel.getCoinDataModel(selectedValue, cryptoList[1]);
    var ltcRate =
        await coinDataModel.getCoinDataModel(selectedValue, cryptoList.last);
    setState(() {
      selectedCurrency = selectedValue;
      selectedRate = btcRate;
      selectedRate2 = ethRate;
      selectedRate3 = ltcRate;
    });
  }

  CupertinoPicker iOSpicker() {
    List<Text> cupertinoPickerList = [];

    for (String currency in currenciesList) {
      cupertinoPickerList.add(Text(currency));
    }
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (i) => selectedItemChange(i),
        children: cupertinoPickerList);
  }

  void selectedItemChange(int selectedValue) async {
    var newCurrency = currenciesList[selectedValue];
    var btcRate = await coinDataModel.getCoinDataModel(newCurrency, cryptoList.first);
    var ethRate = await coinDataModel.getCoinDataModel(newCurrency, cryptoList[1]);
    var ltcRate = await coinDataModel.getCoinDataModel(newCurrency, cryptoList.last);
    setState(() {
      selectedCurrency = newCurrency;
      selectedRate = btcRate;
      selectedRate2 = ethRate;
      selectedRate3 = ltcRate;
    });
  }

  @override
  void initState() {
    super.initState();
    dropDownItemChange(currenciesList.first);
    // selectedItemChange(0); buat fungsi parameternya dr iOS
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: CardUI(
                selectedRate: selectedRate, selectedCurrency: selectedCurrency, cryptoList: 'BTC',),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: CardUI(
                selectedRate: selectedRate2, selectedCurrency: selectedCurrency, cryptoList: 'ETH',),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: CardUI(
                selectedRate: selectedRate3, selectedCurrency: selectedCurrency, cryptoList: 'LTC',),
          ),
          Spacer(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSpicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CardUI extends StatefulWidget {
  const CardUI({
    Key key,
    @required this.selectedRate,
    @required this.selectedCurrency,
    @required this.cryptoList,
  }) : super(key: key);

  final String selectedRate;
  final String selectedCurrency;
  final String cryptoList;

  @override
  _CardUIState createState() => _CardUIState();
}

class _CardUIState extends State<CardUI> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 ${widget.cryptoList} = ${widget.selectedRate} ${widget.selectedCurrency}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=A2C1D680-BE36-4886-8336-9F06F99BC6D1
