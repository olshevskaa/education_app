import 'package:educational_app/core/extensions/context_extension.dart';
import 'package:educational_app/core/extensions/string_extension.dart';
import 'package:educational_app/src/profile/presentation/widget/edit_profile_form_field.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.fullNameController,
    required this.emailController,
    required this.bioController,
    required this.oldPasswordController,
    required this.passwordController,
    super.key,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final TextEditingController oldPasswordController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileFormField(
          title: 'FULL NAME',
          controller: fullNameController,
        ),
        EditProfileFormField(
          title: 'EMAIL',
          controller: emailController,
          hintText: context.currentUser!.email.obscureEmail,
        ),
        EditProfileFormField(
          title: 'CURRENT PASSWORD',
          controller: oldPasswordController,
          hintText: '********',
        ),
        StatefulBuilder(
          builder: (_, setState) {
            oldPasswordController.addListener(() => setState(() {}));
            return EditProfileFormField(
              title: 'NEW PASSWORD',
              controller: passwordController,
              hintText: '********',
              readOnly: oldPasswordController.text.isEmpty,
            );
          },
        ),
        EditProfileFormField(
          title: 'BIO',
          controller: bioController,
        ),
      ],
    );
  }
}
