import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wallpaper/data/pexel_data.dart';
import 'package:wallpaper/screens/detailpage.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<Pexeldata>().fetchdata;
    return new MaterialApp(
      home: maincontents(context),
    );
  }

  Widget maincontents(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<Pexeldata>().incrementpage();
          context.read<Pexeldata>().fetchdata;
        },
        icon: const Icon(Icons.refresh_outlined),
        label: Text("Next Page"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            topappbar(context),
            //dropdown(context),
            wallpaperlist(),
          ],
        ),
      ),
    );
  }

  Widget dropdown(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 20),
          child: Text(
            "Categories",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 50),
          child: DropdownButton<String>(
            value: 'wallpaper',
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.green),
            underline: Container(
              height: 2,
              color: Colors.greenAccent,
            ),
            onChanged: (String? newValue) {
              context.read<Pexeldata>().search(newValue.toString());
            },
            items: <String>['wallpaper', 'Space', 'Technology', 'Movie']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget wallpaperlist() {
    return Consumer<Pexeldata>(builder: (context, value, child) {
      return value.map.length == 0 && !value.error
          ? Text("Loading...")
          : value.error
              ? Text("Oops ${value.errormessage}")
              : GridView.count(
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  //Width and height
                  childAspectRatio: (112 / 200),
                  shrinkWrap: true,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    value.map['photos'].length,
                    (index) {
                      return InkResponse(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Detail(
                                    photos: value.pexel.photos[index],
                                    context: context,
                                  );
                                },
                              ),
                            );
                          },
                          child:
                              OneWallpaper(map: value.pexel.photos[index].src));
                    },
                  ),
                );
    });
  }

  Widget topappbar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 290,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new AssetImage("images/bg.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 40)),
          Text(
            "Looking for high",
            style: GoogleFonts.pacifico(
              fontSize: 35,
              color: Colors.white,
            ),
          ),
          Text(
            "Quality free Wallpapers?",
            style: GoogleFonts.pacifico(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: TextField(
              onSubmitted: (String value) {
                context.read<Pexeldata>().search(value);
                context.read<Pexeldata>().fetchdata;
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'Search for wallpaper',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OneWallpaper extends StatelessWidget {
  const OneWallpaper({Key? key, required this.map}) : super(key: key);
  final Src map;
  Widget build(BuildContext context) {
    String url = map.portrait.toString();
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: FittedBox(
        child: Image.network(url),
        fit: BoxFit.fill,
      ),
    );
  }
}
