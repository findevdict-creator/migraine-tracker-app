import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:migraine_tracker/features/routines/domain/routine.dart';

/// The routine's artwork. Decorative: the title next to it says the same.
class RoutineIllustration extends StatelessWidget {
  const RoutineIllustration(this.routine, {this.size = 56, super.key});

  final Routine routine;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SvgPicture.asset(
      routine.illustration,
      width: size,
      height: size,
      placeholderBuilder: (_) => SizedBox.square(dimension: size),
    ),
  );
}
