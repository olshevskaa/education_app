import 'dart:convert';
import 'dart:io';

import 'package:educational_app/core/common/widgets/gradient_background.dart';
import 'package:educational_app/core/common/widgets/nested_backbutton.dart';
import 'package:educational_app/core/enums/update_user.dart';
import 'package:educational_app/core/extensions/context_extension.dart';
import 'package:educational_app/core/res/app_colors.dart';
import 'package:educational_app/core/res/media_res.dart';
import 'package:educational_app/core/utils/core_utils.dart';
import 'package:educational_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:educational_app/src/profile/presentation/widget/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get nameChanged =>
      fullNameController.text.trim() != context.currentUser!.fullName;

  bool get emailChanged => emailController.text.trim().isNotEmpty;

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get bioChanged => bioController.text.trim() != context.currentUser!.bio;

  bool get imageChanged => pickedImage != null;

  bool get nothingChanged =>
      !nameChanged &&
      !emailChanged &&
      !passwordChanged &&
      !bioChanged &&
      !imageChanged;

  @override
  void initState() {
    fullNameController.text = context.currentUser!.fullName;
    bioController.text = context.currentUser!.bio ?? '';
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    bioController.dispose();
    oldPasswordController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  File? pickedImage;

  Future<void> pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackBar(context, 'Profile updated successfully');
          context.pop();
        } else if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const NestedBackButton(),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (nothingChanged) context.pop();
                  final bloc = context.read<AuthBloc>();
                  if (passwordChanged) {
                    if (oldPasswordController.text.isEmpty) {
                      CoreUtils.showSnackBar(
                        context,
                        'Please enter your old password',
                      );
                      return;
                    }
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.password,
                        userData: jsonEncode({
                          'oldPassword': oldPasswordController.text.trim(),
                          'newPassword': passwordController.text.trim(),
                        }),
                      ),
                    );
                  }
                  if (nameChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.displayName,
                        userData: fullNameController.text.trim(),
                      ),
                    );
                  }

                  if (emailChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.email,
                        userData: emailController.text.trim(),
                      ),
                    );
                  }

                  if (bioChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.bio,
                        userData: bioController.text.trim(),
                      ),
                    );
                  }

                  if (imageChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.profilePic,
                        userData: pickedImage,
                      ),
                    );
                  }
                },
                child: state is AuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : StatefulBuilder(
                        builder: (_, refresh) {
                          fullNameController.addListener(() => refresh(() {}));
                          emailController.addListener(() => refresh(() {}));
                          bioController.addListener(() => refresh(() {}));
                          passwordController.addListener(() => refresh(() {}));
                          return Text(
                            'Done',
                            style: TextStyle(
                              color: nothingChanged
                                  ? Colors.grey
                                  : Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          body: GradientBackground(
            image: MediaRes.profileGradientBackground,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Builder(
                  builder: (context) {
                    final user = context.currentUser!;
                    final userImage =
                        user.profilePic == null || user.profilePic!.isEmpty
                            ? null
                            : user.profilePic!;
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: pickedImage != null
                          ? FileImage(pickedImage!)
                          : userImage != null
                              ? NetworkImage(userImage)
                              : const AssetImage(MediaRes.user)
                                  as ImageProvider,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          IconButton(
                            onPressed: pickImage,
                            icon: Icon(
                              (pickedImage != null || user.profilePic != null)
                                  ? Icons.edit
                                  : Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'We recommend an image of at least 400x400',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.neutralTextColour,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                EditProfileForm(
                  fullNameController: fullNameController,
                  emailController: emailController,
                  bioController: bioController,
                  oldPasswordController: oldPasswordController,
                  passwordController: passwordController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
