import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/buku_page.dart';
import '../pages/profile_page.dart';
import '../pages/peminjaman_page.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.blue[700],
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("assets/profile.jpg"),
          ),
          SizedBox(height: 10),
          Text("aminssmile", style: TextStyle(color: Colors.white)),
          Text("salisahmad@gmail.com", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 30),
          menuItem(Icons.home, "Dashboard", HomePage(), context),
          menuItem(Icons.book, "Buku", BukuPage(), context),
          menuItem(Icons.person, "Profile", ProfilePage(), context),
          menuItem(Icons.assignment, "Peminjaman", PeminjamanPage(), context),
        ],
      ),
    );
  }

  Widget menuItem(IconData icon, String title, Widget page, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(title, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
