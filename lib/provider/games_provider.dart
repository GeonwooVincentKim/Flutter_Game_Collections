import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/app_screens/Home/Home.dart';
import 'package:flutter_app/data/games.dart';
import 'package:flutter_app/model/game/game.dart';
import 'package:flutter_app/shared/helpers/helpers.dart';
import 'package:http/http.dart' as http;


class GameProvider with ChangeNotifier{
  // List<Game> _gameItems = DUMMY_GAMES.toList();
  List<Game> _gameItems = List<Game>();
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
  List<Game> _userItems = [];
  Game _selectedGame;
  
  List<Game> get gameItems => [..._gameItems];
  List<Game> get userItems => [..._userItems];
  Game get selectedGame => _selectedGame != null ? Game.from(_selectedGame) : null;
  
  void createNewGameHome(Map<String, dynamic> data){
    data['id'] = getRandomString(2);
    print(data['id']);
    final Game newGame = Game.fromJSON(data);
    _userItems.add(newGame);
    notifyListeners();
  }

  void createNewGameDiscover(Map<String, dynamic> data){
    data['id'] = getRandomString(2);
    final Game newGame = Game.fromJSON(data);
    _gameItems.add(newGame);
    notifyListeners();
  }
  
  void editNewGameHome(Map<String, dynamic> data){
    final Game updatedGame = Game.fromJSON(data);
    final int index = _userItems.indexWhere((g) => g.id == data['id']);
    if(index >= 0){
      _selectedGame = updatedGame;
      _userItems[index] = updatedGame;
    }
    notifyListeners();
  }

  void editNewGameDisover(Map<String, dynamic> data){
    final Game updatedGame = Game.fromJSON(data);
    final int index = _userItems.indexWhere((g) => g.id == data['id']);
    if(index >= 0){
      _selectedGame = updatedGame;
      _userItems[index] = updatedGame;
    }
    notifyListeners();
  }

  void changeProgression(Game selectedGame, double progression){
    final int index = _userItems.indexWhere((game) => game.id == selectedGame.id);

    if(index != 1){
      final Game newGame = Game.from(selectedGame);
      newGame.progression = progression;
      _userItems[index] = newGame;
    }
    notifyListeners();
  }

  void changeFavorite(bool isFavorite){_selectedGame.isFavorite = isFavorite; notifyListeners();}
  void selectGame(Game game){_selectedGame = game; notifyListeners();}
  void addGameList(Game game){_userItems.add(game); notifyListeners();}
}
