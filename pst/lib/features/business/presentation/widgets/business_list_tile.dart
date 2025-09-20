import 'package:flutter/material.dart';
import 'package:pst/features/business/data/business_model.dart';

class BusinessListTile extends StatelessWidget {
  final BusinessModel business;

  const BusinessListTile({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                business.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.business, color: Colors.grey, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${business.category} - ${business.address.split(',').first}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingStars(rating: business.averageRating),
                      const SizedBox(width: 4.0),
                      Text(
                        business.averageRating.toString(),
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '(${business.reviewCount} avis)',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 18.0,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index >= rating) {
          return Icon(Icons.star_border, color: color, size: size);
        } else if (index > rating - 1 && index < rating) {
          return Icon(Icons.star_half, color: color, size: size);
        } else {
          return Icon(Icons.star, color: color, size: size);
        }
      }),
    );
  }
}
