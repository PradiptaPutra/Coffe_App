import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaffeineTrackingScreen extends StatefulWidget {
  final User user;

  CaffeineTrackingScreen({required this.user});

  @override
  _CaffeineTrackingScreenState createState() => _CaffeineTrackingScreenState();
}

class _CaffeineTrackingScreenState extends State<CaffeineTrackingScreen> {
  double _dailyCaffeine = 0;
  final double _dailyLimit = 400;

  void _addCaffeine(double amount) {
    setState(() {
      _dailyCaffeine += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Caffeine Tracker',
            style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserProfile(),
            _buildCupProgressIndicator(),
            _buildSearchBar(),
            _buildDrinksList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.user.photoURL ?? ''),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.displayName ?? 'No Name',
                style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.user.email ?? 'No Email',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCupProgressIndicator() {
    double progress = _dailyCaffeine / _dailyLimit;
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.white60.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[100]!, Colors.blue[300]!],
              ),
            ),
          ),
          ClipPath(
            clipper: CupClipper(progress),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orange[300]!, Colors.orange[600]!],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '${_dailyCaffeine.toInt()} / ${_dailyLimit.toInt()} mg',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search drinks...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
          ),
        ),
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _buildDrinksList() {
    final drinks = [
      ('Hot Espresso', 40.0, FontAwesomeIcons.mugHot),
      ('Cup of Tea', 27.0, FontAwesomeIcons.mugSaucer),
      ('Coca-Cola', 34.0, FontAwesomeIcons.bottleWater),
      ('Energy Drink', 80.0, FontAwesomeIcons.bolt),
      ('5-Hour Energy Shot', 200.0, FontAwesomeIcons.wineBottle),
      ('Espresso', 63.0, FontAwesomeIcons.mugHot),
      ('Refreshing Energy', 114.0, FontAwesomeIcons.bottleWater),
      ('Black Tea', 42.0, FontAwesomeIcons.mugSaucer),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: drinks.length,
      itemBuilder: (context, index) {
        final (name, caffeine, icon) = drinks[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: Icon(icon, color: Colors.orange[700], size: 20),
            ),
            title: Text(name, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
            subtitle: Text('$caffeine mg', style: TextStyle(color: Colors.grey[600])),
            trailing: IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.blue[400]),
              onPressed: () => _addCaffeine(caffeine),
            ),
          ),
        );
      },
    );
  }
}

class CupClipper extends CustomClipper<Path> {
  final double fillPercentage;

  CupClipper(this.fillPercentage);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * (1 - fillPercentage));
    path.arcToPoint(
      Offset(size.width, size.height * (1 - fillPercentage)),
      radius: Radius.circular(size.width / 2),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CupClipper oldClipper) => fillPercentage != oldClipper.fillPercentage;
}