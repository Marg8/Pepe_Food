

import 'package:flutter/material.dart';
import 'package:pepe_food/Models/categoryModel.dart';
import 'package:http/http.dart' as http;

import '../Models/item.dart';
import '../Models/item.dart';

final _URL_NEWS = "https://newsapi.org/v2";
final _APIKEY = "3d23610fbc734294b364c48b4a2fe553";

class NewsService with ChangeNotifier {

  List<ItemModel> headlines = [];
  String _selectedCategory = "Comida";

  bool _isLoading = true;

  List<Category> categories =[

    Category(Icons.fastfood, "Comida"),
    Category(Icons.local_drink, "Bebida"),
    Category(Icons.cake, "Postre"),
   
    
      
  ];

  Map<String, List<ItemModel>> categoryArticles = {};

  NewsService(){
    
    this.getTopHeadLines();

    categories.forEach((item) {
      this.categoryArticles[item.name] = new List<ItemModel>.empty(growable: true);
     });

     this.getArticleByCategory( this._selectedCategory );

  }

  bool get isLoading => this._isLoading;

  

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor){
    this._selectedCategory = valor;

    this._isLoading = true;
    this.getArticleByCategory(valor);
    notifyListeners();
  }
  
  List<ItemModel> get getArticulosCategoriasSelecionada => this.categoryArticles[this.selectedCategory];

  


  getTopHeadLines() async{

    // final url = "$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us";
    // final resp = await http.get(url);

    // // final newsResponce = newsResponseFromJson(resp.body);

    // this.headlines.addAll(newsResponce.articles);
    notifyListeners();
  }

  getArticleByCategory(String category) async{

    if(this.categoryArticles[category].length > 0){
      this._isLoading = false;
      notifyListeners();
      return this.categoryArticles[category];
    }

    // final url ="$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us&category=$category";
    // final resp = await http.get(url);

    // final newsResponce = newsResponseFromJson(resp.body);

    // this.categoryArticles[category].addAll(newsResponce.articles);

    this._isLoading = false;
    notifyListeners();
  }

  
  
}