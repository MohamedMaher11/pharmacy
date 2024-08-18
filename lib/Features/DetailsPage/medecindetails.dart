import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Model/medecinmodel.dart';

class MedicineDetailPage extends StatefulWidget {
  final Medicine medicine;

  MedicineDetailPage({required this.medicine});

  @override
  _MedicineDetailPageState createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  int _quantity = 1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isFavorited = false;

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _updateCart(bool add) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final cartCollection = _firestore.collection('cart');
    final querySnapshot = await cartCollection
        .where('userId', isEqualTo: userId)
        .where('name', isEqualTo: widget.medicine.name)
        .get();

    if (querySnapshot.docs.isEmpty) {
      if (add) {
        try {
          await cartCollection.add({
            'userId': userId,
            'name': widget.medicine.name,
            'imageUrl': widget.medicine.imageUrl,
            'price': widget.medicine.price * _quantity,
            'description': widget.medicine.description,
            'quantity': _quantity,
          });
          _showSnackBar('${widget.medicine.name} أضيف إلى السلة');
        } catch (e) {
          print('فشل في إضافة إلى السلة: $e');
          _showSnackBar('فشل في إضافة إلى السلة');
        }
      }
    } else {
      final docId = querySnapshot.docs.first.id;
      final doc = querySnapshot.docs.first;

      try {
        final existingData = doc.data() as Map<String, dynamic>;
        final existingQuantity = existingData['quantity'] ?? 0;
        final newQuantity = existingQuantity + _quantity;
        final newPrice = widget.medicine.price * newQuantity;

        await cartCollection.doc(docId).update({
          'quantity': newQuantity,
          'price': newPrice,
        });

        _showSnackBar('${widget.medicine.name} تم تحديث الكمية في السلة');
      } catch (e) {
        print('فشل في تحديث السلة: $e');
        _showSnackBar('فشل في تحديث السلة');
      }
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      isFavorited = !isFavorited;
    });

    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final favoritesCollection = _firestore.collection('favorites');
    final querySnapshot = await favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('name', isEqualTo: widget.medicine.name)
        .get();

    try {
      if (isFavorited && querySnapshot.docs.isEmpty) {
        await favoritesCollection.add({
          'userId': userId,
          'name': widget.medicine.name,
          'imageUrl': widget.medicine.imageUrl,
          'price': widget.medicine.price,
          'description': widget.medicine.description,
        });
      } else if (!isFavorited && querySnapshot.docs.isNotEmpty) {
        await favoritesCollection.doc(querySnapshot.docs.first.id).delete();
      }
    } catch (e) {
      print(isFavorited
          ? 'فشل في إضافة إلى المفضلة: $e'
          : 'فشل في إزالة من المفضلة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.yellow[700]!, Colors.deepPurple[700]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Hero(
                        tag: 'medicine-${widget.medicine.name}',
                        child: Image.network(
                          widget.medicine.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: IconButton(
                      icon: Icon(
                        isFavorited
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: isFavorited ? Colors.red : Colors.white,
                        size: 30,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medicine.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${(widget.medicine.price * _quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.medicine.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildQuantityButton(
                            icon: FontAwesomeIcons.minus,
                            color: Colors.red[600]!,
                            onTap: _decreaseQuantity,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '$_quantity',
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(width: 10),
                          _buildQuantityButton(
                            icon: FontAwesomeIcons.plus,
                            color: Colors.blue[800]!,
                            onTap: _increaseQuantity,
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _updateCart(true),
                        icon: Icon(FontAwesomeIcons.cartPlus),
                        label: Text('أضف إلى السلة'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple[700],
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 370,
                    child: ElevatedButton(
                      onPressed: () {
                        // انتقل إلى صفحة الدفع أو اشترِ مباشرة
                      },
                      child: Text('اشتر الآن'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
