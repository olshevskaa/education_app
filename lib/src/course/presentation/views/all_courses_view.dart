import 'package:educational_app/core/common/widgets/gradient_background.dart';
import 'package:educational_app/core/res/media_res.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';
import 'package:flutter/material.dart';

class AllCoursesView extends StatelessWidget {
  const AllCoursesView({required this.courses, super.key});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
