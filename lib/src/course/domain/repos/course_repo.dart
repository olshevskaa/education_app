import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';

abstract class CourseRepo {
  const CourseRepo();

  ResultFuture<List<Course>> getCourses();

  ResultFuture<void> addCourse(Course course);
}
