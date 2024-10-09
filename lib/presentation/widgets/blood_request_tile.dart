import 'package:flutter/material.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/data/models/blood_request_list_response.dart'; // Update with your correct path

class BloodRequestTile extends StatelessWidget {
  final String type;
  final BloodRequestList request;

  const BloodRequestTile(
      {super.key, required this.request, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to the card
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the start
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 100,
                      child: Image.asset('assets/icons/icon-3.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(
                        '${request.bloodGroup}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${request.patientFirstName} ${request.patientLastName}',
                      style: TextStyles.body2.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0, // Larger font for the name
                      ),
                      maxLines: 1,
                      overflow: TextOverflow
                          .ellipsis, // Ensure ellipsis for long names
                    ),
                    Text(
                      '${request.numberOfUnits} unit(s) required', // Clarify units with label
                      style: TextStyles.body3.copyWith(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    type == 'close'
                        ? Text(
                            'Phone No: ${request.attendeeMobile}',
                            style: TextStyles.body3.copyWith(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const SizedBox(),
                    Text(
                      'Blood Type: ${request.requestType}',
                      style: TextStyles.body3.copyWith(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (type == 'open') ...[
                      Text(
                        'Phone: ${request.attendeeMobile}',
                        style: TextStyles.body3.copyWith(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Location: ${request.locationForDonation}',
                        style: TextStyles.body3.copyWith(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Hospital: ${request.hospitalName}',
                        style: TextStyles.body3.copyWith(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    Text(
                      'Date: ${request.requiredDate}', // Assuming requestDate is a string. Format it if needed.
                      style: TextStyles.body3.copyWith(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
