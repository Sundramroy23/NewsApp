import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  

class NewsService{ 
  final String _baseUrl = 'https://newsapi.org/v2/';
  final String _apiKey = 'f9e7b33a4c35482599a59012aeb7c807';

  Future<List<dynamic>> getTopNews() async {
    final String url = '${_baseUrl}top-headlines?country=us&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data['articles']);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<dynamic>> getSearchNews(String search) async {
    final String url = '${_baseUrl}everything?q=$search&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data['articles']);
      return data['articles']; 

    }
    else{
      throw Exception('Failed to load news');
    }
  }
}

