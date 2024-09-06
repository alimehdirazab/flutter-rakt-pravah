import 'package:flutter/material.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';

class RequestsCard extends StatelessWidget {
  final String bloodGroup;
  final String name;
  final String units;
  final String address;
  final String date;
  final void Function()? onAcceptPressed;

  const RequestsCard({
    super.key,
    required this.bloodGroup,
    required this.name,
    required this.units,
    required this.address,
    required this.date,
    required this.onAcceptPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.9, // Slightly increased width for better layout
      height: 200,
      margin: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 16.0), // Add margin for spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          // Add shadow for a more card-like appearance
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
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
                padding: const EdgeInsets.only(top: 14, left: 3),
                child: Text(
                  bloodGroup,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0, // Adjust font size for better visibility
                    fontWeight: FontWeight.bold, // Bold text for emphasis
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16.0), // Add spacing between image and text
          Expanded(
            // Use Expanded to allow the text to fill the available space
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Distribute space between text and buttons
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyles.body2.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0, // Larger font for the name
                        ),
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis, // Ensure ellipsis for long names
                      ),
                      const SizedBox(height: 4.0), // Add vertical spacing
                      Text(
                        '$units unit(s) required', // Clarify units with label
                        style: TextStyles.body3.copyWith(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0), // Add vertical spacing
                      Text(
                        address,
                        maxLines: 1, // Set maxLines to 1 for ellipsis effect
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.body3.copyWith(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 4.0), // Add vertical spacing
                      Text(
                        date,
                        style: TextStyles.body3.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis, // Ensure ellipsis for long dates
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align buttons to the start
                    children: [
                      IconButton.outlined(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.keyboard_double_arrow_up_sharp,
                          color: Colors.blueAccent,
                        ),
                        iconSize: 20, // Adjust icon size for better appearance
                        style: IconButton.styleFrom(
                          minimumSize: const Size(
                              32, 32), // Ensure enough space for tap area
                        ),
                      ),
                      const GapWidget(size: -12),
                      IconButton.outlined(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          color: Colors.greenAccent,
                        ),
                        iconSize: 20,
                        style: IconButton.styleFrom(
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                      const GapWidget(
                          size:
                              8), // Corrected GapWidget size for proper spacing
                      ElevatedButton(
                        onPressed: onAcceptPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(80, 36), // Adjust button size
                          shape: RoundedRectangleBorder(
                            // Add rounded corners
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
