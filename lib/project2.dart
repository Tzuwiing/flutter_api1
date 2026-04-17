import 'dart:convert';
import 'dart:ui'; // Diperlukan untuk efek Glassmorphism (BackdropFilter)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Coba2 extends StatefulWidget {
  const Coba2({super.key});

  @override
  State<Coba2> createState() => _Coba2State();
}

class _Coba2State extends State<Coba2> {
  Map<String, dynamic>? productData;
  bool isLoading = true;

  // Palet Warna Mewah
  final Color primaryDark = const Color(0xFF111111); // Hitam pekat elegan
  final Color textMuted = const Color(
    0xFF757575,
  ); // Abu-abu lembut untuk teks bacaan
  final Color goldAccent = const Color(0xFFD4AF37); // Emas klasik

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products/1'),
      );
      if (response.statusCode == 200) {
        setState(() {
          productData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Gagal memuat data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih murni
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryDark))
          : productData == null
          ? const Center(child: Text("Gagal memuat data produk."))
          : Stack(
              children: [
                // KONTEN UTAMA DENGAN SLIVER (SCROLLING ELEGAN)
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // 1. SLIVER APP BAR (Gambar Utama Parallax)
                    SliverAppBar(
                      expandedHeight: 400.0,
                      pinned: true,
                      stretch: true,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      leading: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                        onPressed: () {},
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: const [StretchMode.zoomBackground],
                        background: Container(
                          color: const Color(0xFFFAFAFA),
                          child: Image.network(
                            productData!['images'][0] ??
                                productData!['thumbnail'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // 2. KONTEN DETAIL PRODUK
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            24,
                            30,
                            24,
                            120,
                          ), // Padding bawah 120 agar tidak tertutup tombol Beli
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeaderSection(),
                              _buildDivider(),
                              _buildDescriptionSection(),
                              _buildDivider(),
                              _buildSpesifikasiSection(),
                              _buildDivider(),
                              _buildReviewSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // 3. FLOATING GLASSMORPHISM BOTTOM BAR (Tombol Beli Melayang)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildFloatingBottomBar(),
                ),
              ],
            ),
    );
  }

  // --- WIDGET HELPER DESAIN MEWAH ---

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Divider(color: Colors.grey.shade200, thickness: 1),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              productData!['brand'].toString().toUpperCase(),
              style: TextStyle(
                color: textMuted,
                letterSpacing:
                    2.0, // Memberi jarak antar huruf agar terkesan mahal
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Icon(Icons.star_rounded, color: goldAccent, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${productData!['rating']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          productData!['title'],
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300, // Font tipis elegan
            color: primaryDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${productData!['price']}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: primaryDark,
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                '-${productData!['discountPercentage']}% OFF',
                style: TextStyle(
                  color: goldAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ABOUT THIS ITEM', style: _sectionTitleStyle()),
        const SizedBox(height: 16),
        Text(
          productData!['description'],
          style: TextStyle(
            color: textMuted,
            height: 1.8, // Line height luas agar enak dibaca
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10.0,
          children: (productData!['tags'] as List).map<Widget>((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(30), // Bentuk Pill membulat
              ),
              child: Text(
                tag.toString().toUpperCase(),
                style: TextStyle(
                  color: primaryDark,
                  fontSize: 11,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSpesifikasiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SPECIFICATIONS', style: _sectionTitleStyle()),
        const SizedBox(height: 16),
        _buildCleanRow('Category', productData!['category']),
        _buildCleanRow('SKU', productData!['sku']),
        _buildCleanRow('Weight', '${productData!['weight']} oz'),
        _buildCleanRow('Availability', productData!['availabilityStatus']),
        _buildCleanRow('Warranty', productData!['warrantyInformation']),
        _buildCleanRow('Shipping', productData!['shippingInformation']),
      ],
    );
  }

  Widget _buildReviewSection() {
    List reviews = productData!['reviews'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CUSTOMER REVIEWS', style: _sectionTitleStyle()),
            Text(
              'View All',
              style: TextStyle(
                color: textMuted,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['reviewerName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryDark,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 14,
                          color: index < review['rating']
                              ? primaryDark
                              : Colors.grey.shade300, // Bintang hitam elegan
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '"${review['comment']}"',
                  style: TextStyle(
                    color: textMuted,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Baris Info Minimalis
  Widget _buildCleanRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(color: textMuted, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: primaryDark,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Style standar untuk judul bagian
  TextStyle _sectionTitleStyle() {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      color: primaryDark,
    );
  }

  // Tombol Beli dengan efek Kaca (Glassmorphism)
  Widget _buildFloatingBottomBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ), // Efek Blur pada latar belakang
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85), // Putih transparan
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Tombol Simpan/Favorite
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.favorite_border, color: primaryDark),
                ),
                const SizedBox(width: 16),
                // Tombol Add to Cart Ekstra Mewah (Hitam Pekat)
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: primaryDark,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: primaryDark.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'ADD TO CART',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 14,
                          ),
                        ),
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
