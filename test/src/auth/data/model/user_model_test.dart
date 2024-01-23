import 'dart:convert';

import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/auth/data/models/user_model.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();

  test('should be a subclass of LocalUser entity', () async {
    // assert
    expect(tLocalUserModel, isA<LocalUser>());
  });

  final tMap = jsonDecode(fixture('user.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [LocalUserModel] from the map', () {
      // act
      final result = LocalUserModel.fromMap(tMap);

      // assert
      expect(result, isA<LocalUserModel>());
      expect(result, tLocalUserModel);
    });

    test('should throw an [Error] when map is invalid', () {
      // arrange
      final map = DataMap.from(tMap)..remove('uid');
      // act
      const call = LocalUserModel.fromMap;

      // assert
      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from a valid model', () {
      final result = tLocalUserModel.toMap();

      expect(result, tMap);
    });
  });

  group('copyWith', () {
    test('should return a valid [LocalUserModel] with updated values', () {
      final result = tLocalUserModel.copyWith(uid: '2222');

      expect(result.uid, '2222');
    });
  });
}
