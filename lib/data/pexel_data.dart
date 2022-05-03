import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Pexeldata with ChangeNotifier {
  Map<String, dynamic> _map = {};
  bool _error = false;
  String _errormessage = "";
  String _search = "wallpaper";
  late Pexel pexel;
  int _page = 1;

  Future<void> get fetchdata async {
    final response = await http.get(
      Uri.parse(
          "https://api.pexels.com/v1/search?query=$_search&orientation=portrait&per_page=30&page=$_page"),
      headers: {
        'Authorization':
            '{{ADD YOUR APIKEY HERE}}',
      },
    );
    if (response.statusCode == 200) {
      try {
        _map = jsonDecode(response.body);
        _error = false;
        print("Gotten Data");
        pexel = Pexel.fromJson(_map);
      } catch (e) {
        _error = true;
        _errormessage = e.toString();
      }
    } else {
      _error = true;
      _errormessage = "Check Internet Connection";
    }
    notifyListeners();
  }

  void initialvalues() {
    _map = {};
    _error = false;
    _errormessage = "";
    notifyListeners();
  }

  void search(String txt) {
    this._search = txt;
    revertsett();
  }

  void incrementpage() {
    _page += 1;
  }

  void revertsett() {
    this._page = 1;
  }

  int get page => _page;
  Map<String, dynamic> get map => _map;
  bool get error => _error;
  String get errormessage => _errormessage;
  String getsearch() {
    return this._search;
  }
}

class Pexel {
  int page = 0;
  int perPage = 0;
  List<Photos> photos = [];
  int totalResults = 0;
  String nextPage = "";

  Pexel(
      {required this.page,
      required this.perPage,
      required this.photos,
      required this.totalResults,
      required this.nextPage});

  Pexel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    if (json['photos'] != null) {
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    totalResults = json['total_results'];
    nextPage = json['next_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    data['total_results'] = this.totalResults;
    data['next_page'] = this.nextPage;
    return data;
  }
}

class Photos {
  int? id;
  int? width;
  int? height;
  String? url;
  String? photographer;
  String? photographerUrl;
  int? photographerId;
  String? avgColor;
  late Src src;
  bool? liked;

  Photos(
      {required this.id,
      required this.width,
      required this.height,
      required this.url,
      required this.photographer,
      required this.photographerUrl,
      required this.photographerId,
      required this.avgColor,
      required this.src,
      required this.liked});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    photographer = json['photographer'];
    photographerUrl = json['photographer_url'];
    photographerId = json['photographer_id'];
    avgColor = json['avg_color'];
    src = (json['src'] != null ? new Src.fromJson(json['src']) : null)!;
    liked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['width'] = this.width;
    data['height'] = this.height;
    data['url'] = this.url;
    data['photographer'] = this.photographer;
    data['photographer_url'] = this.photographerUrl;
    data['photographer_id'] = this.photographerId;
    data['avg_color'] = this.avgColor;
    if (this.src != null) {
      data['src'] = this.src.toJson();
    }
    data['liked'] = this.liked;
    return data;
  }
}

class Src {
  String? original;
  String? large2x;
  String? large;
  String? medium;
  String? small;
  String? portrait;
  String? landscape;
  String? tiny;

  Src(
      {this.original,
      this.large2x,
      this.large,
      this.medium,
      this.small,
      this.portrait,
      this.landscape,
      this.tiny});

  Src.fromJson(Map<String, dynamic> json) {
    original = json['original'];
    large2x = json['large2x'];
    large = json['large'];
    medium = json['medium'];
    small = json['small'];
    portrait = json['portrait'];
    landscape = json['landscape'];
    tiny = json['tiny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original'] = this.original;
    data['large2x'] = this.large2x;
    data['large'] = this.large;
    data['medium'] = this.medium;
    data['small'] = this.small;
    data['portrait'] = this.portrait;
    data['landscape'] = this.landscape;
    data['tiny'] = this.tiny;
    return data;
  }
}
