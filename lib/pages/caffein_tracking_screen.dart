import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CaffeineTrackingScreen extends StatefulWidget {
  final User user;

  CaffeineTrackingScreen({required this.user});

  @override
  _CaffeineTrackingScreenState createState() => _CaffeineTrackingScreenState();
}


class _CaffeineTrackingScreenState extends State<CaffeineTrackingScreen> {
  double _dailyCaffeine = 0;
  final double _dailyLimit = 400; // 400mg is a common recommended limit

  void _addCaffeine(double amount) {
    setState(() {
      _dailyCaffeine += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[700],
      appBar: AppBar(
        title: Text('Prevent caffeine overdose, track it easily!',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.brown[800],
      ),
      body: Column(
        children: [
          _buildUserProfile(),
          _buildCupProgressIndicator(),
          _buildSearchBar(),
          Expanded(
            child: _buildDrinksList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.user.email ?? 'No Email',
                style: TextStyle(fontSize: 14, color: Colors.white70),
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
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.brown[400]!, Colors.brown[700]!],
              ),
            ),
          ),
          ClipPath(
            clipper: CupClipper(progress),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange[300]!, Colors.orange[600]!],
                ),
              ),
            ),
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
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
          fillColor: Colors.brown[600],
          hintText: 'Search drinks...',
          hintStyle: TextStyle(color: Colors.brown[200]),
          prefixIcon: Icon(Icons.search, color: Colors.brown[200]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.white),
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
      itemCount: drinks.length,
      itemBuilder: (context, index) {
        final (name, caffeine, icon) = drinks[index];
        return ListTile(
          leading: Icon(icon, color: Colors.orange),
          title: Text(name, style: TextStyle(color: Colors.white)),
          subtitle: Text('$caffeine mg', style: TextStyle(color: Colors.orange[200])),
          trailing: Icon(Icons.add_circle_outline, color: Colors.orange),
          onTap: () => _addCaffeine(caffeine),
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

