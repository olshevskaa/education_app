import 'package:educational_app/core/common/widgets/app_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          AppField(
            controller: widget.emailController,
            hintText: 'Email Adress',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          AppField(
            controller: widget.passwordController,
            hintText: 'Password',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
              onPressed: () => setState(() {
                obscureText = !obscureText;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
