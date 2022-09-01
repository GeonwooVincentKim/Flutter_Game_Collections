import 'package:flutter/material.dart';
import 'package:flutter_app/provider/games_provider.dart';
import 'package:flutter_app/shared/style.dart';
import 'package:provider/provider.dart';


class CreateGameTile extends StatefulWidget {
  final String id;
  final String contents;
  final List<dynamic> isSelected;

  CreateGameTile({@required this.id, @required this.contents, @required this.isSelected});
  @override
  _CreateGameTileState createState() => _CreateGameTileState();
}

class _CreateGameTileState extends State<CreateGameTile> {
  bool isClicked = false;

  @override
  void initState(){
    setState((){
      isClicked = widget.isSelected.contains(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        widget.contents,
        style: TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          side: BorderSide(color: isClicked ? Colors.white : textAccentColor),
          borderRadius: BorderRadius.circular(5)),
        foregroundColor: Colors.white
      ),
      onPressed: (){
        setState(() {
          isClicked = !isClicked;
          if(isClicked) widget.isSelected.add(widget.id);
          else widget.isSelected.remove(widget.id);
        });
      }
    );
  }
}