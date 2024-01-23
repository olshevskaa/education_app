import 'package:dartz/dartz.dart';
import 'package:educational_app/core/common/errors/failures.dart';
import 'package:educational_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:educational_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usecase;

  setUp(() {
    repo = MockBoardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  test(
    'should call the [OnBoardingRepo.cacheFirstTimer] '
    'and return the right data',
    () async {
      when(() => repo.cacheFirstTimer()).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase();

      expect(result, equals(const Right<Failure, void>(null)));

      verify(() => repo.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
