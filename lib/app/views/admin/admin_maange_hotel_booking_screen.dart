import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHotelBookingsScreen extends StatefulWidget {
  const AdminHotelBookingsScreen({super.key});

  @override
  _AdminHotelBookingsScreenState createState() => _AdminHotelBookingsScreenState();
}

class _AdminHotelBookingsScreenState extends State<AdminHotelBookingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking $status')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - All Bookings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('bookings').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          var bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];
              var data = booking.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('${data['fullName']} - ${data['hotelName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in: ${data['checkIn']}'),
                      Text('Check-out: ${data['checkOut']}'),
                      Text('Guests: ${data['guests']}'),
                      Text('Status: ${data['status']}'),
                    ],
                  ),
                  trailing: data['status'] == 'pending'
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateBookingStatus(booking.id, 'accepted'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Accept'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _updateBookingStatus(booking.id, 'declined'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Decline'),
                      ),
                    ],
                  )
                      : Text(
                    'Status: ${data['status']}',
                    style: TextStyle(
                      color: data['status'] == 'accepted' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
