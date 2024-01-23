import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/course/data/models/course_model.dart';
import 'package:educational_app/src/course/domain/entities/course_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1589800000,
    '_nanoseconds': 123456000,
  };

  final date =
      DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!).add(
    Duration(microseconds: timestampData['_nanoseconds']!),
  );

  final timestamp = Timestamp.fromDate(date);

  final tCourseModel = CourseModel.empty();

  final tMap = jsonDecode(fixture('course.json')) as DataMap;
  tMap['createdAt'] = timestamp;
  tMap['updatedAt'] = timestamp;

  test('should be a subclass of a [Course] entity', () {
    expect(tCourseModel, isA<Course>());
  });

  group('empty', () {
    test('should return a [CourseModel] with empty data', () {
      final result = CourseModel.empty();

      expect(result.id, '_empty.id');
      expect(result.title, '_empty.title');
      expect(result.description, '_empty.description');
    });
  });

  group('fromMap', () {
    test('should return a [CourseModel with correct data]', () {
      final result = CourseModel.fromMap(tMap);
      expect(result, tCourseModel);
    });
  });

  group('copyWith', () {
    test('should return a [CourseModel] with updated data', () {
      final result = tCourseModel.copyWith(
        title: 'new title',
      );

      expect(result.title, 'new title');
    });
  });

  group('toMap', () {
    test('should return a [DataMap] with correct data', () {
      final result = tCourseModel.toMap()
        ..remove('createdAt')
        ..remove('updatedAt');

      final map = DataMap.from(tMap)
        ..remove('createdAt')
        ..remove('updatedAt');

      expect(result, map);
    });
  });
}
