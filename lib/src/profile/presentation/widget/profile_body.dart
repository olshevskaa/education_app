import 'package:educational_app/core/common/app/providers/user_provider.dart';
import 'package:educational_app/core/extensions/context_extension.dart';
import 'package:educational_app/core/res/app_colors.dart';
import 'package:educational_app/core/res/media_res.dart';
import 'package:educational_app/core/services/injection_container.dart';
import 'package:educational_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:educational_app/src/course/presentation/widgets/add_course_sheet.dart';
import 'package:educational_app/src/profile/presentation/widget/admin_button.dart';
import 'package:educational_app/src/profile/presentation/widget/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: UserInfoCard(
                    infoThemeColor: AppColors.physicsTileColour,
                    infoIcon: const Icon(IconlyLight.document),
                    infoTitle: 'Courses',
                    infoValue: user!.enrolledCourseIds.length.toString(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: UserInfoCard(
                    infoThemeColor: AppColors.languageTileColour,
                    infoIcon: Image.asset(
                      MediaRes.scoreboard,
                      width: 24,
                      height: 24,
                    ),
                    infoTitle: 'Score',
                    infoValue: user.points.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: UserInfoCard(
                    infoThemeColor: AppColors.biologyTileColour,
                    infoIcon: const Icon(
                      IconlyLight.user,
                      color: Color(0xFF56AEFF),
                    ),
                    infoTitle: 'Followers',
                    infoValue: user.followers.length.toString(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: UserInfoCard(
                    infoThemeColor: AppColors.chemistryTileColour,
                    infoIcon: const Icon(
                      IconlyLight.user,
                      color: Color(0xFFFF84AA),
                    ),
                    infoTitle: 'Following',
                    infoValue: user.following.length.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (context.currentUser!.isAdmin) ...[
              AdminButton(
                label: 'Add Course',
                icon: IconlyLight.paper_upload,
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (_) => BlocProvider(
                      create: (_) => sl<CourseCubit>(),
                      child: const AddCourseSheet(),
                    ),
                  );
                },
              )
            ],
          ],
        );
      },
    );
  }
}
