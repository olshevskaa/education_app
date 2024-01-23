import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedefs.dart';
import 'package:educational_app/src/auth/domain/repos/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  const ForgotPassword(this._authRepo);

  final AuthRepo _authRepo;
  
  @override
  ResultFuture<void> call(String params) => _authRepo.forgotPassword(params);
}
