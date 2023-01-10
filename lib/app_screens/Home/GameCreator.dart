import 'package:flutter/material.dart';
import 'package:flutter_app/app_screens/Home/SideMenu.dart';
import 'package:flutter_app/model/Users.dart';
import 'package:flutter_app/model/game/game.dart';
import 'package:flutter_app/model/game/publisher.dart';
import 'package:flutter_app/provider/games_provider.dart';
import 'package:flutter_app/provider/publishers_provider.dart';
import 'package:flutter_app/shared/helpers/helpers.dart';
import 'package:flutter_app/shared/helpers/icomoon.dart';
// import 'package:flutter_app/provider/games.dart';
import 'package:flutter_app/shared/style.dart';
import 'package:flutter_app/widgets/CreateGame/GameCreateForm.dart';
import 'package:provider/provider.dart';


class GameCreator extends StatefulWidget {
  @override
  _GameCreatorState createState() => _GameCreatorState();
}

class _GameCreatorState extends State<GameCreator> {
  final formGameKey = GlobalKey<FormState>();
  final Map<String, dynamic> formGameData = {
    'title': '',
    // 'imageURL': [''],
    'images': [''],
    'singleImage': '',
    'platforms': [],
    'genres': [],
    'description': '',
    'releaseYear': '',
    'releaseMonth': '',
    'releaseDay': '',
    'publisher': '',
    // 'releaseDate': '',
    'isFavorite': false,
    'progression': 0.0,
    // 'videoURL': ''
  };
  List<String> imageURL = [''];
  String image = '';
  String appBarTitle = 'Create Games';
  
  @override
  void initState(){
    final Game? gameSelect = Provider.of<GameProvider>(context, listen: false).selectedGame;
    final Publisher? pub = Provider.of<PublisherProvider>(context, listen: false).singlePublisher;
    // final String userID = Provider.of<User>(context, listen: false).id;
    if(gameSelect != null /* && gameSelect.createUser == userID */){
      print("Intializing..");
      appBarTitle = 'Edit Game';

      final DateTime getCurrentDate = getDateTimeFormat(gameSelect.releaseDate);
      formGameData['id'] = gameSelect.id;
      formGameData['title'] = gameSelect.title;
      formGameData['images'] = gameSelect.images;
      // imageURL.add(gameSelect.images[0]);
      // formGameData['publisher'] = pub.name;
      
      formGameData['platforms'] = gameSelect.platforms;
      formGameData['genres'] = gameSelect.genres;
      formGameData['releaseYear'] = getCurrentDate.year.toString();
      formGameData['releaseMonth'] = getCurrentDate.month.toString();
      formGameData['releaseDay'] = getCurrentDate.day.toString();
      // formGameData['releaseDate'] = gameSelect.releaseDate;
      formGameData['isFavorite'] = gameSelect.isFavorite;
      formGameData['progression'] = gameSelect.progression;
    }
    super.initState();
  }

  AppBar _buildAppBarCreator(){
    return AppBar(
      title: Text(appBarTitle),
      backgroundColor: appBarColor,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(IconMoon.isave, color: Colors.white),
          onPressed: () => _submitForm(),
        )
      ],
    );
  }

  Widget _buildCreatorBody(){
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      color: backgroundColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
              // child: Text("Hello World"),
              child: GameCreateForm(
                formGameData: formGameData, formGameKey: formGameKey, 
                imageURL: imageURL,
                isTitle: true, isPublisher: true, isPlatform: true, isGenre: true, isReleaseDate: true,
                isDescription: true, isImages: true,
              ),
            )
          ),
          _buildSaveForm(),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: _buildAppBarCreator(),
      body: _buildCreatorBody(),
    );
  }

  Widget _buildSaveForm(){
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: ContinuousRectangleBorder(side: BorderSide(color: lineColor)),
          foregroundColor: Colors.black87
        ),
        child: Padding(
          padding: EdgeInsets.all(defaultPadding / 2),
          child: Text("SAVE", style: settingsMainFont),
        ),
        onPressed: () => _submitForm(),
      )
    );
  }

  void _submitForm(){
    if(!formGameKey.currentState!.validate()) return;
    formGameKey.currentState!.save();

    formGameData['images'] = imageURL;
    final String month = formGameData['releaseMonth'];
    final String day = formGameData['releaseDay'];
    formGameData['releaseDate'] = "$formGameData['releaseYear']/$month/$day";
    
    if(formGameData['progression'] == null){
      formGameData['progression'] = 0.0;
    } else if (formGameData['progression']  != null){
      if(formGameData['progression'].runtimeType != double)
        formGameData['progression'] = double.parse(formGameData['progression']);
    }
    formGameData['platforms'] = (formGameData['platforms'] != null) ? formGameData['platforms'].cast<String>() : null;
    formGameData['genres'] = (formGameData['genres'] != null) ? formGameData['platforms'].cast<String>() : null;

    print(appBarTitle);
    if(appBarTitle == 'Create Games'){
      Provider.of<GameProvider>(context, listen: false).createNewGameHome(formGameData);
      Provider.of<GameProvider>(context, listen: false).createNewGameDiscover(formGameData);
      print(GameProvider);
    } else if(appBarTitle == 'Modify Games'){
      Provider.of<GameProvider>(context, listen: false).editNewGameHome(formGameData);
      print(GameProvider);
      print("HIIIIIIIIIII");
      Navigator.pop(context, '/');
    }

    print("Haep~Gyeok");
    Navigator.pushNamed(context, '/');
    _resetForm();
  }

  void _resetForm(){
    formGameKey.currentState!.reset();
    setState((){
      formGameData['title'] = '';
      formGameData['images'] = [];
      imageURL = [''];
      // ImageURL.add(gameSelect.images[0]);
      
      formGameData['platforms'] = [];
      formGameData['genres'] = [];
      formGameData['releaseDate'] = '';
      formGameData['releaseYear'] = '';
      formGameData['releaseMonth'] = '';
      formGameData['releaseDay'] = '';
      formGameData['description'] = '';
      // formGameData['releaseYear'] = gameSelect.releaseDate.year.toString();
      // formGameData['releaseMonth'] = gameSelect.releaseMonth;
      // formGameData['releaseDay'] = 
      // formGameData['releaseDate'] = gameSelect.releaseDate;
    });
  }
}