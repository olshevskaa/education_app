import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';
import 'package:educational_app/src/course/domain/repos/course_repo.dart';

class GetCourses extends UsecaseWithoutParams<List<Course>> {
  const GetCourses(this._repository);

  final CourseRepo _repository;

  @override
  ResultFuture<List<Course>> call() async => _repository.getCourses();
}
