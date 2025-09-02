import "package:aim_test/res/dimens.dart";
import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const CustomShimmer({
    super.key,
    this.width = double.infinity,
    this.height = Dimens.shimmerHeightMedium,
    this.radius = Dimens.shimmerCardRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey[200] ?? Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(radius))),
      ),
    );
  }
}
