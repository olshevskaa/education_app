import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';
import 'package:educational_app/src/course/domain/repos/course_repo.dart';

class AddCourse extends UsecaseWithParams<void, Course> {
  const AddCourse(this._repository);

  final CourseRepo _repository;

  @override
  ResultFuture<void> call(Course params) async => _repository.addCourse(params);
}
