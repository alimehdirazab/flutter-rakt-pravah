import 'package:flutter/material.dart';
import 'package:rakt_pravah/data/models/blood_request_list_response.dart'; // Update with your correct path

class BloodRequestTile extends StatelessWidget {
  final BloodRequestList request;

  const BloodRequestTile({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('${request.patientFirstName} ${request.patientLastName}'),
        subtitle: Text('Blood Group: ${request.bloodGroup}'),
        trailing: Text('Units: ${request.numberOfUnits}'),
        onTap: () {
          // Handle tile tap (e.g., navigate to a detailed view)
        },
      ),
    );
  }
}
