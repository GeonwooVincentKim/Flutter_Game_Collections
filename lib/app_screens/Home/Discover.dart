import 'package:flutter/material.dart';
import 'package:flutter_app/model/game/game.dart';
import 'package:flutter_app/provider/games_provider.dart';
import 'package:flutter_app/shared/style.dart';
import 'package:flutter_app/widgets/Discover/game_card.dart';
import 'package:flutter_app/widgets/expanded/divider.dart';
import 'package:provider/provider.dart';

class Discover extends StatefulWidget{ State<StatefulWidget> createState() => _DiscoverState(); }

class _DiscoverState extends State<Discover>{
  List<Game> pageList = [];
  Future<void> refreshUsers() async {
    var result = await http_get('games');
    if(result.ok){
      setState(() {
        pageList.clear();
        var in_games = result.data as List<dynamic>;
        in_games.forEach((in_games){
          pageList.add(Game(
            in_games['id'].toString(),
            in_games['']
          ));
        });
      });
    }
  }

  @override
  void initState(){
    super.initState();
  }

  Widget _buildDiscoverBody(){
    return Padding(
      padding: EdgeInsets.all(defaultPadding),
      child: Consumer<GameProvider>(
        builder: (ctx, gamesProduct, child){
          final List<Game> listGame = gamesProduct.gameItems;
          pageList = listGame.toList();

          return ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) =>
              transparent_divider(),
            itemCount: pageList.length,
            itemBuilder: (context, index){
              final item = pageList[index];
              return DiscoverGameCard(discoverGame: item);
            }
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _buildDiscoverBody(),
      backgroundColor: backgroundColor,
    );
  }
}
