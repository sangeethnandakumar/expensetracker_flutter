import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.pink
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(icon:Icons.analytics, label:'Analytics', onTap: ()=> {}),
            _buildMenuButton(icon:Icons.add_circle, label:'Add', onTap: ()=> {}),
            _buildMenuButton(icon:Icons.monetization_on, label:'Add Expence', onTap: ()=> {}, isMain: true),
            _buildMenuButton(icon:Icons.sync, label:'Cloud Sync', onTap: ()=> {}),
            _buildMenuButton(icon:Icons.tab, label:'Settings', onTap: ()=> {})
        ]
      ),
    );
  }

  Widget _buildMenuButton({required IconData icon, required String label, required VoidCallback onTap, bool isMain = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: isMain? 8 : 16),
              child: Container(
                child: Column(
                  children: [
                    Icon(icon, size: isMain? 45 : 35, color: isMain? Colors.white : Colors.white70,),
                    SizedBox(height: 2),
                    Text(
                      label,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    SizedBox(height: isMain? 8 : 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
