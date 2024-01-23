import 'package:dartz/dartz.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';
import 'package:educational_app/src/course/domain/repos/course_repo.dart';
import 'package:educational_app/src/course/domain/usecases/add_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repo.mock.dart';

void main() {
  late CourseRepo repo;
  late AddCourse usecase;

  final tCourse = Course.empty();

  setUp(() {
    repo = MockCourseRepo();
    usecase = AddCourse(repo);
  });

  test('should add course by calling repo', () async {
    when(() => repo.addCourse(tCourse))
        .thenAnswer((_) async => const Right(null));

    await usecase(tCourse);

    verify(() => repo.addCourse(tCourse)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
