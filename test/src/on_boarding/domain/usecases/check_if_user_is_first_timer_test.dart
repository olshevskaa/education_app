import 'package:dartz/dartz.dart';
import 'package:educational_app/core/common/errors/failures.dart';
import 'package:educational_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:educational_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    repo = MockBoardingRepo();
    usecase = CheckIfUserIsFirstTimer(repo);
  });

  test(
    'should call the [OnBoardingRepo.checkIfUserIsFirstTimer] '
    'and return the right data',
    () async {
      when(() => repo.checkIfUserIsFirstTimer()).thenAnswer(
        (_) async => const Right(true),
      );

      final result = await usecase();

      expect(result, equals(const Right<Failure, bool>(true)));

      verify(() => repo.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
