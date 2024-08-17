import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamo_pharmacy/Features/Chat/lastseen.dart';
import 'package:hamo_pharmacy/Features/DetailsPage/medecindetails.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/category.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/discount.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/doctor_consult.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/widgets/offersection.dart';
import 'package:hamo_pharmacy/Model/medecinmodel.dart';
import 'package:hamo_pharmacy/Features/Cart/cartpage.dart';
import 'package:hamo_pharmacy/Features/Favourate/favouratepage.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _searchQuery = '';
  List<Medicine> _medicines = [];
  List<Medicine> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  void _fetchMedicines() {
    // افتراضياً نقوم بتحميل الأدوية من البيانات الموجودة لديك
    _medicines = categories.expand((category) => category.medicines).toList();
    _filteredMedicines = _medicines;
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredMedicines = [];
      } else {
        _filteredMedicines = _medicines.where((medicine) {
          return medicine.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              'صيدلية',
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            _buildCartIcon(),
            SizedBox(width: 15),
            _buildFavoritesIcon(),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            if (_searchQuery.isNotEmpty)
              _buildMedicineGrid()
            else
              _buildDefaultContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (query) => _updateSearchQuery(query),
      decoration: InputDecoration(
        hintText: 'البحث عن علاج ....',
        prefixIcon: Icon(FontAwesomeIcons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildMedicineGrid() {
    return _filteredMedicines.isEmpty
        ? Center(child: Text('لا توجد نتائج'))
        : GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: _filteredMedicines.map((medicine) {
              return _buildMedicineCard(context, medicine);
            }).toList(),
          );
  }

  Widget _buildMedicineCard(BuildContext context, Medicine medicine) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineDetailPage(medicine: medicine),
          ),
        );
      },
      child: Hero(
        tag: 'medicine-${medicine.name}',
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(medicine.imageUrl, height: 80),
              SizedBox(height: 8),
              Text(medicine.name, style: TextStyle(fontSize: 14)),
              SizedBox(height: 4),
              Text('\$${medicine.price}',
                  style: TextStyle(fontSize: 12, color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDoctorConsultationSection(context),
        SizedBox(height: 20),
        buildHealthCategorySection(context),
        SizedBox(height: 20),
        buildOffersSection(),
        SizedBox(height: 20),
        buildDiscountCarousel(),
      ],
    );
  }

  Widget _buildCartIcon() {
    return StreamBuilder<int>(
      stream: _firestore
          .collection('cart')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.length),
      builder: (context, snapshot) {
        final cartCount = snapshot.data ?? 0;
        return Stack(
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.shoppingCart, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
            ),
            if (cartCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Center(
                    child: Text(
                      '$cartCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFavoritesIcon() {
    return StreamBuilder<int>(
      stream: _firestore
          .collection('favorites')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.length),
      builder: (context, snapshot) {
        final favoritesCount = snapshot.data ?? 0;
        return Stack(
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.heart, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              },
            ),
            if (favoritesCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Center(
                    child: Text(
                      '$favoritesCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('اسم المستخدم'),
            accountEmail: Text(_auth.currentUser?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://example.com/user_image.png'), // يجب استبدال هذا برابط صورة المستخدم
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('الرئيسية'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.calendar),
            title: Text('موعدي'),
            onTap: () {
              Navigator.of(context).pushNamed('/user_appointment');
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('المفضلة'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.message),
            title: Text('الرسائل'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LastSeenPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('تسجيل الخروج'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/sign_in');
            },
          ),
        ],
      ),
    );
  }
}
