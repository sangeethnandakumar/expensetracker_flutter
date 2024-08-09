import 'package:expences/bl/repos/config_repo.dart';
import 'package:expences/models/config_model.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ConfigModel?>(
        future: _fetchConfig(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading devices'));
          } else if (!snapshot.hasData || snapshot.data?.devices == null) {
            return Center(child: Text('No devices found'));
          }

          final devices = snapshot.data!.devices;
          final user = snapshot.data!.user;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                UserInfoSection(user: user),
                const SizedBox(height: 30),
                const ButtonSection(),
                const SizedBox(height: 20),
                const SettingsSection(),
                const SizedBox(height: 20),
                DevicesList(devices: devices),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<ConfigModel?> _fetchConfig() async {
    final ConfigRepository _configRepository = ConfigRepository();
    return await _configRepository.getById('defaultInstance');
  }
}

class UserInfoSection extends StatelessWidget {
  final User? user;
  const UserInfoSection({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            'https://media.licdn.com/dms/image/C5603AQFN3Vjr3F8xtw/profile-displayphoto-shrink_200_200/0/1629784008587?e=2147483647&v=beta&t=ewCM9CRQn2XL5K37ro0W5_GtvBodRefShjeS6T8Mi78',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${user?.firstName} ${user?.lastName}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${user?.email}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ButtonSection extends StatefulWidget {
  const ButtonSection({Key? key}) : super(key: key);

  @override
  _ButtonSectionState createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  List<bool> isSelected = [true, false]; // Initial state of buttons

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        isSelected: isSelected,
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
            // Add your functionality based on the selected index
            if (index == 0) {
              // Manage Data selected
            } else {
              // Logout selected
            }
          });
        },
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.white,
        fillColor: Colors.blueAccent,
        color: Colors.blueAccent,
        constraints: BoxConstraints(
          minHeight: 40.0,
          minWidth: 100.0,
        ),
        children: [
          Text('Manage Data', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}



class SettingsSection extends StatelessWidget {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSettingsCard(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'Tweek App Settings',
          onTap: () {
            // Navigate to settings
          },
        ),
        _buildSettingsCard(
          icon: Icons.upgrade,
          title: 'Upgrade',
          subtitle: 'Premium Features',
          onTap: () {
            // Navigate to upgrade options
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DevicesList extends StatelessWidget {
  final List<Device>? devices;

  const DevicesList({Key? key, required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Registered Sync Devices',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        ...?devices?.map((device) => DeviceItem(
          name: device.model ?? 'Unknown Model',
          brand: device.brand ?? 'Unknown Brand',
          icon: Icons.phone_android,
        ))
      ],
    );
  }
}

class DeviceItem extends StatelessWidget {
  final String name;
  final String brand;
  final IconData icon;

  const DeviceItem({
    Key? key,
    required this.name,
    required this.brand,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blueGrey),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          brand,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}