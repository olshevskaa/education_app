import 'package:educational_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:educational_app/core/common/views/loading_view.dart';
import 'package:educational_app/core/common/widgets/not_found_text.dart';
import 'package:educational_app/core/utils/core_utils.dart';
import 'package:educational_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:educational_app/src/home/presentation/widgets/home_header.dart';
import 'package:educational_app/src/home/presentation/widgets/home_subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void getCourses() {
    context.read<CourseCubit>().getCourses();
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (BuildContext _, state) {
        if (state is CourseError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is CoursesLoaded && state.courses.isNotEmpty) {
          final courses = state.courses..shuffle();
          final courseOfTheDay = courses.first;
          context
              .read<CourseOfTheDayNotifier>()
              .setCourseOfTheDay(courseOfTheDay);
        }
      },
      builder: (context, state) {
        if (state is LoadingCourses) {
          return const LoadingView();
        } else if (state is CoursesLoaded && state.courses.isEmpty ||
            state is CourseError) {
          return const NotFoundText(
            text: 'No courses found\nPlease try again later',
          );
        } else if (state is CoursesLoaded) {
          final courses = state.courses..sort(
            (a, b) => b.updatedAt.compareTo(a.updatedAt),
          );

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              HomeSubjects(courses: courses),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
