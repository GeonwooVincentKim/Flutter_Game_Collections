import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/provider/filter.dart';
import 'package:flutter_app/provider/games_provider.dart';
import 'package:flutter_app/widgets/Home/list_tiles_with_title.dart';
import 'package:flutter_app/widgets/expanded/divider.dart';
import 'package:flutter_app/model/game/game.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget{
  // final void Function(int) onBottomTapped;
  // const Home({Key key, this.onBottomTapped}) : super(key: key);

  @override
  State<StatefulWidget> createState()
  => _BodyState();
}

class _BodyState extends State<Home>{
  int pageIndex = 0;
  // Function onBottomTapped;
  
  List<Game> inProgress = [], completed = [], newGame = [];
  List<String> titleList = <String>['IN PROCESS', 'Completed', 'New Game'];
  Game deletedGame;

  List<Game> _games = List<Game>();
  Future<List<Game>> fetchGames() async {
    var url = "http://192.168.88.204:3010/api/users";
    var response = await http.get(url);
    var games = List<Game>();

    if(response.statusCode == 200){
      var gamesInfo = json.decode(response.body) as List;
      for(var gameInfo in gamesInfo){
        games.add(Game.fromJSON(gameInfo));
      }
    }
    return games;
  }

  @override
  void initState() {
    fetchGames().then((value){
      setState(() {
        _games.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.black12,
      child: SingleChildScrollView(
        child: Consumer<GameProvider>(
          builder: (ctx, gamesProduct, child){
            final Map<String, dynamic> homeFilter = Provider.of<Filters>(context).homeFilters;
            final List<Game> listGame = gamesProduct.userItems;
            // final List<Game> listGame2 = gamesProduct.gameItems;
            inProgress = listGame.where((game) => game.progression != 0 && game.progression != 100).toList();
            completed = listGame.where((game) => game.progression == 100).toList();
            newGame = listGame.where((game) => game.progression == 0).toList();
            // inProgress = listGame.where((game) => game.progression != 0 && game.progression != 100 || isFilter(game, homeFilter)).toList();
            // completed = listGame.where((game) => game.progression == 100 || isFilter(game, homeFilter)).toList();
            // newGame = listGame.where((game) => game.progression == 0 && isFilter(game, homeFilter)).toList();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTilesWithTitle(title: titleList[0], gameList: inProgress),
                transparent_divider(),
                ListTilesWithTitle(title: titleList[1], gameList: completed),
                transparent_divider(),
                ListTilesWithTitle(title: titleList[2], gameList: newGame),
              ],
            );
          }
        )
      ),
    );
  }
}