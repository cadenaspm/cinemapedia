
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends SliverPersistentHeaderDelegate {

  final double minExtents;
  final double maxExtents;

  CustomAppbar({
    required this.minExtents, 
    required this.maxExtents
  });
  
  @override
  double get maxExtent => maxExtents;
  
  @override
  double get minExtent => minExtents;
  
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final color = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    final isCollapsed = shrinkOffset > (maxExtents - minExtents - 10) ;

    return Container(
      color: Colors.red[100],
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if(!isCollapsed)
              FadeIn(child: Text('Esta es una info de prueba')),
            Row(
              children: [
                Icon(Icons.movie_creation_outlined, color: color.primary),
                const SizedBox(width: 5),
                Text('Cinemapedia', style: titleStyle),
                const Spacer(),
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.search, color: color.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

}

  
  