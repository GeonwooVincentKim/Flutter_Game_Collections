import 'package:flutter/material.dart';
import 'package:flutter_app/model/game/game.dart';
import 'package:flutter_app/shared/style.dart';
import 'package:flutter_app/widgets/Home/game_tile.dart';
import 'package:flutter_app/widgets/Home/home_title.dart';
import 'package:flutter_app/widgets/expanded/divider.dart';


class ListTilesWithTitle extends StatelessWidget{
  final String title;
  final List<Game> gameList;
  final bool marginBottom;
  late Game game;

  ListTilesWithTitle({
    required this.title,
    required this.gameList,
    this.marginBottom = true
  });

  @override
  Widget build(BuildContext context) {
    return gameList.length > 0 ?
      Column(
        children: <Widget>[
          ProgressText(title: title),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => transparent_divider(),
            itemCount: gameList.length,
            itemBuilder: (context, index){
              return ClipRRect(borderRadius: BorderRadius.circular(10.0), child: GameTile(game: gameList[index]));
            }
          )
        ]
      ) :
      Column(
        children: [
          ProgressText(title: title),
          Center(
            child: Container(
              padding: EdgeInsets.all(defaultPadding / 2),
              color: Colors.black12,
              child: Text('There is no Game in the List')
            )
          ), (marginBottom ? SizedBox(height: defaultPadding * 2) : Container())
        ],
      );
  }
}