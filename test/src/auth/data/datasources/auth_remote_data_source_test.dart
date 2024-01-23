import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educational_app/core/common/errors/exeptions.dart';
import 'package:educational_app/core/enums/update_user.dart';
import 'package:educational_app/core/utils/constants.dart';
import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:educational_app/src/auth/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseFirestore cloudFirestore;
  late FirebaseAuth auth;
  late MockFirebaseStorage storage;
  late AuthRemoteDataSource dataSource;
  late UserCredential userCredential;
  late MockUser mockUser;
  late DocumentReference<DataMap> documentReference;
  const tUser = LocalUserModel.empty();

  setUpAll(() async {
    cloudFirestore = FakeFirebaseFirestore();
    documentReference = cloudFirestore.collection('users').doc();
    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );
    auth = MockFirebaseAuth();
    storage = MockFirebaseStorage();
    mockUser = MockUser()..uid = documentReference.id;
    userCredential = MockUserCredential(mockUser);

    dataSource = AuthRemoteDataSourceImpl(
      auth: auth,
      firestore: cloudFirestore,
      storage: storage,
    );

    when(() => auth.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'Test password';
  const tEmail = 'testemail@mail.com';
  const tFullName = 'Test full name';

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'No user record for this identifier',
  );

  group('forgotPassword', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(
        () => auth.sendPasswordResetEmail(
          email: any(named: 'email'),
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      final call = dataSource.forgotPassword(tEmail);

      expect(call, completes);

      verify(() => auth.sendPasswordResetEmail(email: tEmail)).called(1);
      verifyNoMoreInteractions(auth);
    });

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => auth.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.forgotPassword;

        expect(() => call(tEmail), throwsA(isA<ServerException>()));

        verify(() => auth.sendPasswordResetEmail(email: tEmail)).called(1);
        verifyNoMoreInteractions(auth);
      },
    );
  });

  group('signIn', () {
    test('should return [LocalUserModel] when no [Exception] is thrown',
        () async {
      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => userCredential,
      );

      final result = await dataSource.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result.uid, userCredential.user!.uid);
      expect(result.points, 0);

      verify(
        () => auth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);

      verifyNoMoreInteractions(auth);
    });

    test('should throw [ServerException] when user is null', () async {
      final emptyUserCredential = MockUserCredential();

      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => emptyUserCredential,
      );

      final call = dataSource.signIn;

      expect(
        () => call(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<ServerException>()),
      );

      verify(
        () => auth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(auth);
    });

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.signIn;

        expect(
          () => call(
            email: tEmail,
            password: tPassword,
          ),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => auth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(auth);
      },
    );
  });

  group('signUp', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => auth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        when(() => userCredential.user?.updateDisplayName(any()))
            .thenAnswer((_) async => Future.value());

        when(() => userCredential.user?.updatePhotoURL(any()))
            .thenAnswer((_) async => Future.value());

        final call = dataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        );

        expect(call, completes);

        verify(
          () => auth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        await untilCalled(() => userCredential.user?.updateDisplayName(any()));

        verify(() => userCredential.user?.updateDisplayName(tFullName))
            .called(1);

        await untilCalled(() => userCredential.user?.updatePhotoURL(any()));

        verify(() => userCredential.user?.updatePhotoURL(kDefaultAvatar));
        verifyNoMoreInteractions(auth);
      },
    );
    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => auth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.signUp;

        expect(
          () => call(
            email: tEmail,
            fullName: tFullName,
            password: tPassword,
          ),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => auth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
      },
    );
  });

  group('updateUser', () {
    setUp(() {
      registerFallbackValue(MockAuthCredential());
    });
    test(
      'should update user displayName successfully when no [Exception] '
      'is thrown',
      () async {
        when(() => mockUser.updateDisplayName(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.displayName,
          userData: tFullName,
        );

        verify(() => mockUser.updateDisplayName(tFullName)).called(1);

        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final userData =
            await cloudFirestore.collection('users').doc(mockUser.uid).get();

        expect(userData.data()!['fullName'], tFullName);
      },
    );

    test(
      'should update user email successfully when no [Exception] '
      'is thrown',
      () async {
        when(() => mockUser.updateEmail(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.email,
          userData: tEmail,
        );

        final userData =
            await cloudFirestore.collection('users').doc(mockUser.uid).get();

        expect(userData.data()!['email'], tEmail);

        verify(() => mockUser.updateEmail(tEmail)).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));
      },
    );

    test(
      'should update user bio successfully when no [Exception] '
      'is thrown',
      () async {
        const newBio = 'Test bio';

        await dataSource.updateUser(
          action: UpdateUserAction.bio,
          userData: newBio,
        );

        final userData =
            await cloudFirestore.collection('users').doc(mockUser.uid).get();

        expect(userData.data()!['bio'], newBio);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateEmail(any()));
      },
    );

    test(
        'should update user password successfully when no [Exception] '
        'is thrown', () async {
      when(() => mockUser.updatePassword(any())).thenAnswer(
        (_) async => Future.value(),
      );

      when(() => mockUser.reauthenticateWithCredential(any()))
          .thenAnswer((_) async => userCredential);

      when(() => mockUser.email).thenReturn(tEmail);

      await dataSource.updateUser(
        action: UpdateUserAction.password,
        userData: jsonEncode({
          'oldPassword': 'oldPassword',
          'newPassword': tPassword,
        }),
      );

      final userData = await cloudFirestore
          .collection('users')
          .doc(documentReference.id)
          .get();

      expect(userData.data()!['password'], null);

      verify(() => mockUser.updatePassword(tPassword)).called(1);

      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateEmail(any()));
    });

    test(
      'should update user profilePic successfulluy when no [Exception] '
      'is thrown',
      () async {
        final newProfilePic = File('assets/images/onBoarding_background.png');
        when(() => mockUser.updatePhotoURL(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.profilePic,
          userData: newProfilePic,
        );

        expect(storage.storedFilesMap.isNotEmpty, isTrue);

        verify(() => mockUser.updatePhotoURL(any())).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateEmail(any()));
      },
    );
  });
}
