import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  final UserEntity user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final bool hasLocation = user.latitude != 0.0 && user.longitude != 0.0;
    final double lat = hasLocation ? user.latitude : 10.762622;
    final double lng = hasLocation ? user.longitude : 106.660172;

    final LatLng userLocation = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin chi tiết'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.deepPurple.shade100,
              child: const Icon(Icons.person, size: 50, color: Colors.deepPurple),
            ),
            const SizedBox(height: 12),
            Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(user.role.toUpperCase(), style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: const Text('Số điện thoại'),
                    subtitle: Text(user.phone.isEmpty ? 'Chưa cập nhật' : user.phone),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Địa chỉ'),
                    subtitle: Text(user.address.isEmpty ? 'Chưa cập nhật' : user.address),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Vị trí bản đồ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: userLocation,
                    zoom: hasLocation ? 16 : 10,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('user_location'),
                      position: userLocation,
                      infoWindow: InfoWindow(
                        title: user.name,
                        snippet: hasLocation ? user.address : 'Vị trí mặc định (Chưa cập nhật)',
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    )
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}