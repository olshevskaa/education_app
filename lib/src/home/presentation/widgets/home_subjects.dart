import 'package:educational_app/core/common/widgets/course_tile.dart';
import 'package:educational_app/core/extensions/context_extension.dart';
import 'package:educational_app/core/res/app_colors.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';
import 'package:educational_app/src/course/presentation/views/all_courses_view.dart';
import 'package:educational_app/src/home/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

class HomeSubjects extends StatelessWidget {
  const HomeSubjects({
    required this.courses,
    super.key,
  });

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          sectionTitle: 'Courses',
          seeAll: courses.length > 4,
          onPressed: () => context.push(
            AllCoursesView(courses: courses),
          ),
        ),
        const Text(
          'Explore our courses',
          style: TextStyle(
              fontWeight: FontWeight.w500, color: AppColors.neutralTextColour),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: courses
              .take(4)
              .map(
                (course) => CourseTile(
                  course: course,
                  onTap: () => Navigator.of(context).pushNamed(
                    '/course',
                    arguments: course,
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
