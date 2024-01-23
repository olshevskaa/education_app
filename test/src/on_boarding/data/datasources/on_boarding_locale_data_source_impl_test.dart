import 'package:educational_app/core/common/errors/exeptions.dart';
import 'package:educational_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSourceImpl localeDataSource;

  setUp(() {
    prefs = MockSharedPreferences();
    localeDataSource = OnBoardingLocalDataSourceImpl(prefs);
  });

  group('cacheFirstTimer', () {
    test('should call [SharedPreferences] to cache the data', () async {
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

      await localeDataSource.cacheFirstTimer();

      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test(
        'should throw a [CacheException] '
        'when there is an error caching the data', () async {
      when(
        () => prefs.setBool(any(), any()),
      ).thenThrow(Exception());

      final methodCall = localeDataSource.cacheFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));

      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    group('checkIfUserIsFirstTimer', () {
      test(
        'should call [SharedPreferences] to check if user is first timer '
        'and return right response from storage when data exists',
        () async {
          when(() => prefs.getBool(any())).thenReturn(false);

          final result = await localeDataSource.checkIfUserIsFirstTimer();

          expect(result, false);

          verify(() => prefs.getBool(kFirstTimerKey)).called(1);
          verifyNoMoreInteractions(prefs);
        },
      );

      test('should return true if there is no data i n the storage', () async {
        when(
          () => prefs.getBool(any()),
        ).thenReturn(null);

        final result = await localeDataSource.checkIfUserIsFirstTimer();

        expect(result, true);

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);
        verifyNoMoreInteractions(prefs);
      });

      test(
        'should throw a [CacheException] where is an error '
        'retrieving the data',
        () async {
          when(() => prefs.getBool(any()),).thenThrow(Exception());
          final call = localeDataSource.checkIfUserIsFirstTimer;

          expect(call, throwsA(isA<CacheException>()));
          verify(() => prefs.getBool(kFirstTimerKey)).called(1);
          verifyNoMoreInteractions(prefs);
        },
      );
    });
  });
}
