import 'package:flutter/material.dart';
import 'package:photo_bucket/models/photo.dart';

class PhotoRow extends StatelessWidget {
  final Photo photo;
  final Function() onTap;

  const PhotoRow({
    required this.photo,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.image),
            trailing: const Icon(Icons.chevron_right),
            title: Text(
              photo.title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
