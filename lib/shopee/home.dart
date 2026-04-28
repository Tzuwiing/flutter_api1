import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopeeHome extends StatefulWidget {
  const ShopeeHome({super.key});

  @override
  State<ShopeeHome> createState() => _ShopeeHomeState();
}

class _ShopeeHomeState extends State<ShopeeHome> {
  List<dynamic> data = [];
  bool isLoading = true;

  Future ambilData() async {
    var response = await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      var hasil = jsonDecode(response.body);
      setState(() {
        data = hasil['products'];
        isLoading = false;
      });
    } else {
      throw Exception("Gagal mengambil data users");
    }
  }

  String formatRupiah(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: SafeArea(
          child: Container(
            color: Colors.deepOrange,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.search, color: Colors.deepOrange),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Search',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                        Icon(Icons.camera_alt_outlined, color: Colors.grey),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                SizedBox(width: 15),
                Icon(Icons.chat_outlined, color: Colors.white, size: 28),
                SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFEE4D2D)),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.62,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var product = data[index];
                var hargaRupiah = (product['price'] * 15000).round();
                int diskon = product['discountPercentage'].round();

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              product['images'][0],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFEAEA),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              child: Text(
                                "-$diskon%",
                                style: TextStyle(
                                  color: Color(0xFFEE4D2D),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(color: Colors.orange),
                              child: Text(
                                "PROMO XTRA",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["title"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                              Row(
                                children: [
                                  Text(
                                    product["brand"] ?? "Shopee Official",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    product["category"] ?? "Lifestyles",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ],
                              ),

                              Spacer(),
                              Text(
                                "Rp${formatRupiah(hargaRupiah)}",
                                style: const TextStyle(
                                  color: Color(0xFFEE4D2D),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 12,
                                  ),
                                  Text(
                                    "${product['rating']}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "${product['stock']}0+ terjual",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFEE4D2D),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: "Deals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: "Live & Video",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),

            label: "Notifikasi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Saya",
          ),
        ],
      ),
    );
  }
}
