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

  Future<void> _addToCart(BuildContext context) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final cartCollection = _firestore.collection('cart');
      final querySnapshot = await cartCollection
          .where('userId', isEqualTo: userId)
          .where('name', isEqualTo: widget.medicine.name)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // العنصر غير موجود في السلة، قم بإضافته
        try {
          await cartCollection.add({
            'userId': userId,
            'name': widget.medicine.name,
            'imageUrl': widget.medicine.imageUrl,
            'price': widget.medicine.price * _quantity,
            'description': widget.medicine.description,
            'quantity': _quantity,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.medicine.name} أضيف إلى السلة')),
          );
        } catch (e) {
          print('فشل في إضافة إلى السلة: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل في إضافة إلى السلة')),
          );
        }
      } else {
        // العنصر موجود في السلة، قم بتحديث الكمية والسعر
        final docId = querySnapshot.docs.first.id;
        final doc = querySnapshot.docs.first;

        try {
          final existingData = doc.data() as Map<String, dynamic>;
          final existingQuantity = existingData['quantity'] ?? 0;
          final existingPrice = existingData['price'] ?? 0.0;

          // تحديث الكمية والسعر بناءً على الكمية المضافة فقط
          final newQuantity = existingQuantity + _quantity;
          final newPrice = widget.medicine.price * newQuantity;

          await cartCollection.doc(docId).update({
            'quantity': newQuantity,
            'price': widget.medicine.price *
                newQuantity, // حساب السعر بناءً على الكمية الجديدة
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('${widget.medicine.name} تم تحديث الكمية في السلة')),
          );
        } catch (e) {
          print('فشل في تحديث السلة: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل في تحديث السلة')),
          );
        }
      }
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      isFavorited = !isFavorited;
    });

    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final favoritesCollection = _firestore.collection('favorites');
      final querySnapshot = await favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('name', isEqualTo: widget.medicine.name)
          .get();

      if (isFavorited && querySnapshot.docs.isEmpty) {
        try {
          await favoritesCollection.add({
            'userId': userId,
            'name': widget.medicine.name,
            'imageUrl': widget.medicine.imageUrl,
            'price': widget.medicine.price,
            'description': widget.medicine.description,
          });
        } catch (e) {
          print('فشل في إضافة إلى المفضلة: $e');
        }
      } else if (!isFavorited && querySnapshot.docs.isNotEmpty) {
        try {
          await favoritesCollection.doc(querySnapshot.docs.first.id).delete();
        } catch (e) {
          print('فشل في إزالة من المفضلة: $e');
        }
      }
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
                      offset: Offset(0, 4))
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
                        color: Colors.blueGrey[800]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${(widget.medicine.price * _quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.medicine.description,
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.7)),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _decreaseQuantity,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Icon(FontAwesomeIcons.minus,
                                  size: 24, color: Colors.red[600]),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '$_quantity',
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: _increaseQuantity,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Icon(FontAwesomeIcons.plus,
                                  size: 24, color: Colors.blue[800]),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _addToCart(context),
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
}
