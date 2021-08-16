import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:wallpaper/data/pexel_data.dart';

class Detail extends StatelessWidget {
  const Detail({Key? key, required this.photos, required this.context})
      : super(key: key);
  final Photos photos;
  final BuildContext context;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wallpaper'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Wallpaper set Successfully.'),
                Text('Continue'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> setWallpaperFromFile(String url) async {
    String result;
    var file = await DefaultCacheManager().getSingleFile(url);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await WallpaperManager.setWallpaperFromFile(
          file.path, WallpaperManager.HOME_SCREEN);
      _showMyDialog();
    } on PlatformException {
      result = 'Failed to get wallpaper.';
      print(result);
    }
  }

  Future<void> setWallpaperFromFileLock(String url) async {
    String result;
    var file = await DefaultCacheManager().getSingleFile(url);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await WallpaperManager.setWallpaperFromFile(
          file.path, WallpaperManager.LOCK_SCREEN);
      _showMyDialog();
    } on PlatformException {
      result = 'Failed to get wallpaper.';
      print(result);
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Hero(
          tag: 'imageHero',
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(photos.src.portrait.toString()),
                  fit: BoxFit.fill),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.only(top: 50, left: 20),
                    decoration: BoxDecoration(
                      color: HexColor(photos.avgColor.toString()),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: HexColor(photos.avgColor.toString()),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        setWallpaperFromFile(photos.src.portrait.toString());
                      },
                      icon: Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Homescreen',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: HexColor(photos.avgColor.toString()),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        setWallpaperFromFileLock(
                            photos.src.portrait.toString());
                      },
                      icon: Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Lockscreen',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
