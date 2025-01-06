import 'package:flutter/material.dart';

class BusinessListingCard extends StatelessWidget {
  final String businessName;
  final double rating;
  final int reviewCount;
  final String businessType;
  final String distance;

  const BusinessListingCard({
    Key? key,
    required this.businessName,
    required this.rating,
    required this.reviewCount,
    required this.businessType,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Business Logo
            Container(
              width: 60,
              height: 60,
              color: Colors.green.shade200,
              child: Center(
                child: Text(
                  businessName.split(' ').map((word) => word[0]).join(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Business Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        rating.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      Icon(Icons.star_half, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '(${reviewCount.toString()})',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$businessType • $distance',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            // View on Map button
            TextButton(
              onPressed: () {
                // Implement map view functionality
              },
              child: Text('View on Map'),
            ),
          ],
        ),
      ),
    );
  }
}
