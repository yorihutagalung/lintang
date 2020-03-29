import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
class NewPriceScreen extends StatefulWidget{
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<NewPriceScreen> {
  String selectedCurrency = currenciesList.first;
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
          Column(
            children: cryptoList.map((item){
              return Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: CardUI(
                  cryptoList: item,
                  selectedCurrency: selectedCurrency,
                ),
              );
            }).toList(),
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

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropDownMenuList = 
      currenciesList.map((item){
        return DropdownMenuItem(child: Text(item), value: item);
      }).toList();
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownMenuList,
      onChanged: (value) => setState(()=>selectedCurrency = value),
    );
  }
  
  CupertinoPicker iOSpicker() {
    List<Text> cupertinoPickerList = [];
    for (String currency in currenciesList) {
      cupertinoPickerList.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged:(selectedIndex)=>setState((){
        selectedCurrency = currenciesList[selectedIndex];
      }),
      children: cupertinoPickerList
    );
  }
}

class CardUI extends StatefulWidget{
  final String cryptoList;
  final String selectedCurrency;
  const CardUI({Key key, this.cryptoList, this.selectedCurrency}) : super(key: key);
  @override
  _CardUIState createState() => _CardUIState();
}

class _CardUIState extends State<CardUI> {
  String rate = "0";

  @override
  void initState() {
    getRate();
    super.initState();
  }

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
          '1 ${widget.cryptoList} = $rate ${widget.selectedCurrency}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void getRate() async{
    var coinData = CoinDataModel();
    var newRate = await coinData.getCoinDataModel(widget.selectedCurrency, widget.cryptoList);
    setState(()=>rate = newRate);
  }
}