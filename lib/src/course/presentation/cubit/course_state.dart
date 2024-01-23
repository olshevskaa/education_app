part of 'course_cubit.dart';

sealed class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

final class CourseInitial extends CourseState {
  const CourseInitial();
}

final class LoadingCourses extends CourseState {
  const LoadingCourses();
}

final class CoursesLoaded extends CourseState {
  const CoursesLoaded(this.courses);

  final List<Course> courses;
}

final class CourseError extends CourseState {
  const CourseError(this.message);

  final String message;
}

final class AddingCourse extends CourseState {
  const AddingCourse();
}

final class CourseAdded extends CourseState {
  const CourseAdded();
}
