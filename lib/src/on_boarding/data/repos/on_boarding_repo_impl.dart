import 'package:dartz/dartz.dart';
import 'package:educational_app/core/common/errors/exeptions.dart';
import 'package:educational_app/core/common/errors/failures.dart';
import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:educational_app/src/on_boarding/domain/repos/on_boarding_repo.dart';

class OnBoardingRepoImpl implements OnBoardingRepo {
  const OnBoardingRepoImpl(this._localeDataSource);

  final OnBoardingLocalDataSource _localeDataSource;

  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {

    
    await _localeDataSource.cacheFirstTimer();
    return const Right(null);
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTimer() async {
    try {
      final isFirstTimer = await _localeDataSource.checkIfUserIsFirstTimer();
      return Right(isFirstTimer);
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }
   
}
