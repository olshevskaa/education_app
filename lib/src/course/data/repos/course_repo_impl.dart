import 'package:dartz/dartz.dart';
import 'package:educational_app/core/common/errors/exeptions.dart';
import 'package:educational_app/core/common/errors/failures.dart';
import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/course/data/datasources/course_remote_data_source.dart';
import 'package:educational_app/src/course/data/models/course_model.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';
import 'package:educational_app/src/course/domain/repos/course_repo.dart';

class CourseRepoImpl implements CourseRepo {
  const CourseRepoImpl(this._remoteDataSource);

  final CourseRemoteDataSource _remoteDataSource;
  @override
  ResultFuture<void> addCourse(Course course) async {
    try {
      await _remoteDataSource.addCourse(course);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<List<CourseModel>> getCourses() async {
    try {
      final result = await _remoteDataSource.getCourses();
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }
}
