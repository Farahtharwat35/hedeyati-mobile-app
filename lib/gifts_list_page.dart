import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hedeyati/app_theme.dart';



class Gift {
  final String description;
  final String imageUrl;
  final String price;
  final isPledged = false;

  Gift({
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

List<String> gifts_names = ["car" , "sunglasses", "watch", "shoes", "bag", "jacket", "dress", "shirt", "pants", "hat", "gloves", "scarf", "socks", "shoes", "boots", "sneakers", "heels", "flats", "sandals", "slippers", "shorts", "skirt", "suit", "tie", "belt", "wallet", "backpack", "earrings", "necklace", "bracelet", "ring", "cufflinks", "brooch", "hairpin", "hairband", "hairclip", "hairtie", "headband", "headscarf", "headwrap", "headpiece", "headwear", "headgear", "headphones", "earmuffs", "earplugs", "earcuffs", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "ear"];

class GiftsListPage extends StatefulWidget {


 const GiftsListPage({Key? key}) : super(key: key);

  @override
  _GiftsListPageState createState() => _GiftsListPageState();
}

class _GiftsListPageState extends State<GiftsListPage> {

  List<Gift> gifts = [];

  void add(String name, String description ,String imageUrl) {
    final newGift = Gift(
        description: description,
        imageUrl: imageUrl,
        price: "100 EGP",
    );
    gifts.add(newGift);
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 15; i++) {
      Future.delayed(Duration(milliseconds: 5), () {
        Random random = Random();
        add(
          gifts_names[random.nextInt(gifts_names.length)],
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          "https://img.freepik.com/free-photo/3d-render-blue-gift-box-with-ribbon-male-package_107791-16197.jpg?t=st=1729882225~exp=1729885825~hmac=46d8dc7b187a6f6c2f54a83998c82ef659c83dd324e5b903b35c44c7db4bd99c&w=1060"
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Gifts List')),
        titleTextStyle: myTheme.textTheme.headlineMedium,
        backgroundColor: myTheme.colorScheme.primary,
      ),
      body: InkWell(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0,20, 0, 0),
          itemCount: gifts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Gift ${index + 1}"),
              leading: Image.network(gifts[index].imageUrl),
              trailing: Text(gifts[index].price),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(),
            ),
          );
        },
      ),
    );
  }
}
class DetailPage extends StatelessWidget {

   const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift details'),
      ),
      body: Center(
        child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
      ),
    );
  }
}
