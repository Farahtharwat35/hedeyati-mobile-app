import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hedeyati/app_theme.dart';
import 'package:hedeyati/gift_page.dart';
import 'package:hedeyati/models/gift.dart';

List<String> gifts_names = ["car" , "sunglasses", "watch", "shoes", "bag", "jacket", "dress", "shirt", "pants", "hat", "gloves", "scarf", "socks", "shoes", "boots", "sneakers", "heels", "flats", "sandals", "slippers", "shorts", "skirt", "suit", "tie", "belt", "wallet", "backpack", "earrings", "necklace", "bracelet", "ring", "cufflinks", "brooch", "hairpin", "hairband", "hairclip", "hairtie", "headband", "headscarf", "headwrap", "headpiece", "headwear", "headgear", "headphones", "earmuffs", "earplugs", "earcuffs", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "earstuds", "earcrawlers", "earstuds", "earhoops", "earjackets", "earchains", "earpendants", "earthreaders", "earwraps", "earhuggies", "earclimbers", "earhooks", "eardangles", "eardrops", "ear"];

class GiftsListPage extends StatefulWidget {


 const GiftsListPage({super.key});

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
      Future.delayed(const Duration(milliseconds: 5), () {
        Random random = Random();
        add(
          gifts_names[random.nextInt(gifts_names.length)],
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          "https://image.similarpng.com/very-thumbnail/2022/02/Geft-box-with-red-bow-isolated-on-transparent-background-PNG.png"
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0,20, 0, 0),
          itemCount: gifts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Gift ${index + 1}" , style: myTheme.textTheme.headlineMedium),
              leading: Image.network(gifts[index].imageUrl),
              trailing: Text(gifts[index].price),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftPage(giftIdx: index),
                  ),
                );
              },
            );
          },
        ),
      ),
      backgroundColor: myTheme.colorScheme.secondary,
    );
  }
}
class DetailPage extends StatelessWidget {

   const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift details'),
      ),
      body: const Center(
        child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
      ),
    );
  }
}
