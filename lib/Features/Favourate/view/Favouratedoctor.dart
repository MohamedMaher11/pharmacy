import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hamo_pharmacy/core/valuenotifire.dart';
import 'package:hamo_pharmacy/Features/Doctor/view/doctor_profile.dart';

class MyFavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<FavoritesNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('المفضلة'),
        backgroundColor: Colors.deepPurple,
      ),
      body: notifier.favorites.isEmpty
          ? Center(child: Text('لا يوجد أطباء في المفضلة حالياً'))
          : ListView.builder(
              itemCount: notifier.favorites.length,
              itemBuilder: (context, index) {
                final doctorId = notifier.favorites.keys.elementAt(index);
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(doctorId)
                      .get(),
                  builder: (context, doctorSnapshot) {
                    if (!doctorSnapshot.hasData) return SizedBox.shrink();

                    final doctor = doctorSnapshot.data!;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doctor['imageUrl']),
                      ),
                      title: Text(doctor['name']),
                      subtitle: Text(doctor['specialty']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          notifier.toggleFavorite(doctorId);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DoctorProfilePage(doctor: doctor),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
