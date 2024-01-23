import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:educational_app/core/common/errors/failures.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';
import 'package:educational_app/src/course/domain/usecases/add_course.dart';
import 'package:educational_app/src/course/domain/usecases/get_courses.dart';
import 'package:educational_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddCourse extends Mock implements AddCourse {}

class MockGetCourses extends Mock implements GetCourses {}

void main() {
  late CourseCubit courseCubit;
  late AddCourse addCourse;
  late GetCourses getCourses;

  final tCourse = Course.empty();
  final tFailure = ServerFailure(
    message: 'Server Failure',
    statusCode: '500',
  );

  setUp(() {
    addCourse = MockAddCourse();
    getCourses = MockGetCourses();
    courseCubit = CourseCubit(
      addCourse: addCourse,
      getCourses: getCourses,
    );
  });

  tearDown(() => courseCubit.close());

  test('initial state should be [CourseInitial]', () async {
    expect(courseCubit.state, equals(const CourseInitial()));
  });

  group('addCourse', () {
    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseAdded] when addCourse is called',
      build: () {
        when(() => addCourse(any())).thenAnswer((_) async => const Right(null));
        return courseCubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => const [
        AddingCourse(),
        CourseAdded(),
      ],
      verify: (_) {
        verify(() => addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseError] when addCourse is called',
      build: () {
        when(() => addCourse(any()))
            .thenAnswer((_) async => Left(tFailure));
        return courseCubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => const [
        AddingCourse(),
        CourseError('500 Error: Server Failure'),
      ],
      verify: (_) {
        verify(() => addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );
  });

  group('getCourses', () {
    blocTest<CourseCubit, CourseState>(
      'emits [LoadingCourses, CoursesLoaded] when getCourses is called',
      build: () {
        when(() => getCourses()).thenAnswer((_) async => Right([tCourse]));
        return courseCubit;
      },
      act: (cubit) => cubit.getCourses(),
      expect: () => [
        const LoadingCourses(),
        CoursesLoaded([tCourse]),
      ],
      verify: (_) {
        verify(() => getCourses()).called(1);
        verifyNoMoreInteractions(getCourses);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [LoadingCourses, CourseError] when getCourses is called',
      build: () {
        when(() => getCourses()).thenAnswer((_) async => Left(tFailure));
        return courseCubit;
      },
      act: (cubit) => cubit.getCourses(),
      expect: () => const [
        LoadingCourses(),
        CourseError('500 Error: Server Failure'),
      ],
      verify: (_) {
        verify(() => getCourses()).called(1);
        verifyNoMoreInteractions(getCourses);
      },
    );
  });
}
