import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  const SignUp(this._authRepo);

  final AuthRepo _authRepo;

  @override
  ResultFuture<void> call(SignUpParams params) => _authRepo.signUp(
        email: params.email,
        fullName: params.fullName,
        password: params.password,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.fullName,
    required this.password,
  });

  const SignUpParams.empty()
      : this(
          email: '',
          fullName: '',
          password: '',
        );

  final String email;
  final String fullName;
  final String password;

  @override
  List<Object?> get props => [email, fullName, password];
}
