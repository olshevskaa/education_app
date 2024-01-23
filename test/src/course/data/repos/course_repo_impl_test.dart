import 'package:dartz/dartz.dart';
import 'package:educational_app/core/common/errors/exeptions.dart';
import 'package:educational_app/core/common/errors/failures.dart';
import 'package:educational_app/src/course/data/datasources/course_remote_data_source.dart';
import 'package:educational_app/src/course/data/models/course_model.dart';
import 'package:educational_app/src/course/data/repos/course_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

void main() {
  late CourseRemoteDataSource remoteDataSource;
  late CourseRepoImpl courseRepoImpl;
  final tCourse = CourseModel.empty();

  setUp(() {
    remoteDataSource = MockCourseRemoteDataSource();
    courseRepoImpl = CourseRepoImpl(remoteDataSource);
    registerFallbackValue(tCourse);
  });

  const tException =
      ServerException(message: 'Something went wrong', statusCode: '500');

  group('addCourse', () {
    test(
        'should complete successfully when the call to remote data source '
        'is successful', () async {
      // arrange
      when(() => remoteDataSource.addCourse(any()))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await courseRepoImpl.addCourse(tCourse);
      // assert
      expect(result, const Right<dynamic, void>(null));
      verify(() => remoteDataSource.addCourse(tCourse)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [ServerFailure] when call to remote data source '
        'throw an [Exception]', () async {
      // arrange
      when(() => remoteDataSource.addCourse(any())).thenThrow(tException);
      // act
      final result = await courseRepoImpl.addCourse(tCourse);
      // assert
      expect(
        result,
        Left<dynamic, void>(
          ServerFailure(
            message: 'Something went wrong',
            statusCode: '500',
          ),
        ),
      );
      verify(() => remoteDataSource.addCourse(tCourse)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getCourses', () { 
    test('should return [List<CourseModel>] when call to remote data source '
    'is successful', () async {
      // arrange
      when(() => remoteDataSource.getCourses())
          .thenAnswer((_) async => Future.value([tCourse]));
      // act
      final result = await courseRepoImpl.getCourses();
      // assert
      expect(result, isA<Right<dynamic, List<CourseModel>>>());
      verify(() => remoteDataSource.getCourses()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return [ServerFailure] when call to remote source is '
    'unsuccessful', () async {
      // arrange
      when(() => remoteDataSource.getCourses()).thenThrow(tException);
      // act
      final result = await courseRepoImpl.getCourses();
      // assert
      expect(
        result,
        Left<Failure, dynamic>(
          ServerFailure.fromException(tException),
        ),
      );
      verify(() => remoteDataSource.getCourses()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
