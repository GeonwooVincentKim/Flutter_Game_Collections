import 'package:flutter/material.dart';
import 'package:flutter_app/model/game/game.dart';
import 'package:flutter_app/shared/helpers/helpers.dart';

class Filters with ChangeNotifier{
  final Map<String, dynamic> _homeFilter = {
    'publisher': '',
    'platforms': [],
    'genres': [],
    'releaseDate': '',
    'releaseYear': '',
    'releaseMonth': '',
  };

  final Map<String, dynamic> _discoverFilter = {
    'publisher': '',
    'platforms': [],
    'genres': [],
    'releaseDate': '',
    'releaseYear': '',
    'releaseMonth': '', 
  };

  Map<String, dynamic> get homeFilters => {..._homeFilter};
  Map<String, dynamic> get discoverFilters => {..._discoverFilter};

  void changeHomeFilter(Map<String, dynamic> currentFilter){
    _homeFilter['publisher'] = currentFilter['publisher'];
    _homeFilter['platforms'] = currentFilter['platforms'];
    _homeFilter['genres'] = currentFilter['genres'];
    _homeFilter['releaseDate'] = currentFilter['releaseDate'];
    _homeFilter['releaseYear'] = currentFilter['releaseYear'];
    _homeFilter['releaseMonth'] = currentFilter['releaseMonth'];
    notifyListeners();
  }

  void changeDiscoverFilter(Map<String, dynamic> currentFilter){
    _homeFilter['publisher'] = currentFilter['publisher'];
    _homeFilter['platforms'] = currentFilter['platforms'];
    _homeFilter['genres'] = currentFilter['genres'];
    _homeFilter['releaseDate'] = currentFilter['releaseDate'];
    _homeFilter['releaseYear'] = currentFilter['releaseYear'];
    _homeFilter['releaseMonth'] = currentFilter['releaseMonth'];
    notifyListeners();
  }

  void resetHomeFilter(){
    _homeFilter['publisher'] = '';
    _homeFilter['platforms'] = [];
    _homeFilter['genres'] = [];
    _homeFilter['releaseDate'] = '';
    _homeFilter['releaseYear'] = null;
    _homeFilter['releaseMonth'] = null;
    notifyListeners();
  }

  void resetDiscoverFilter(){
    _homeFilter['publisher'] = '';
    _homeFilter['platforms'] = [];
    _homeFilter['genres'] = [];
    _homeFilter['releaseDate'] = '';
    _homeFilter['releaseYear'] = null;
    _homeFilter['releaseMonth'] = null;
    notifyListeners();
  }
}

bool isFilter(Game game, Map<String, dynamic> filter){
    final DateTime? releaseDate = game.releaseDate != '' ? getDateTimeFormat(game.releaseDate) : null;
    if((filter['publisher'] == '' || filter['publisher'] == game.publisher) && 
    (filter['releaseYear'] == null || filter['releaseYear'] == releaseDate!.year.toString()) &&
    (filter['releaseMonth'] == null || filter['releaseMonth'] == releaseDate!.month.toString()) &&
    (filter['platforms'].length == 0 || checkGameListID(filter['platforms'], game.platforms)) &&
    (filter['genres'].length == 0 || checkGameListID(filter['genres'], game.genres))) {
      return true;
    }
    return false;
  }

  bool checkGameListID(List<dynamic> filterListID, List<dynamic> listID){
    if(filterListID.length > 0 && listID.length > 0){
      for(var i = 0; i < filterListID.length; i++){
        if(listID.contains(filterListID[i])) return true;
      }
      return false;
    }
    return true;
  }