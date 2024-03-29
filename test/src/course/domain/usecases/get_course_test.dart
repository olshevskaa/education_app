import 'package:dartz/dartz.dart';
import 'package:educational_app/src/course/domain/repos/course_repo.dart';
import 'package:educational_app/src/course/domain/usecases/get_courses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repo.mock.dart';

void main() {
  late CourseRepo repo;
  late GetCourses usecase;

  setUp(() {
    repo = MockCourseRepo();
    usecase = GetCourses(repo);
  });

  test('should get courses by calling repo', () async {
    when(() => repo.getCourses())
        .thenAnswer((_) async => const Right([]));

    await usecase();

    verify(() => repo.getCourses()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
