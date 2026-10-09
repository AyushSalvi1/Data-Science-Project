import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/theme/app_theme.dart';
import 'package:flutter_ecommerce/common/utils/loading_dialog.dart';
import 'package:flutter_ecommerce/common/utils/toast_msg.dart';
import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/user/model/user.dart';
import 'package:flutter_ecommerce/features/user/widgets/settings_list.dart';
import 'package:flutter_ecommerce/features/user/widgets/user_information_card.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class UserAccountBody extends StatefulWidget {
  const UserAccountBody({super.key, required this.user});
  final UserModel user;

  @override
  State<UserAccountBody> createState() => _UserAccountBodyState();
}

class _UserAccountBodyState extends State<UserAccountBody> {
  final AuthBloc _authBloc = sl<AuthBloc>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      children: [
        const Gap(40),
        AppCachedNetworkImage.circular(
            radius: 50, imageUrl: widget.user.profileImageUrl),
        const Gap(20),
        UserInformationCard(user: widget.user),
        const Gap(24),
        SettingsList(),
        const Gap(40),
        _buildLogoutButton(context),
        const Gap(40),
      ],
    );
  }

  BlocListener<AuthBloc, AuthState> _buildLogoutButton(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        state.whenOrNull(
          loading: () => AppProgressIndicator.show(context),
          failure: (failure) {
            AppProgressIndicator.hide(context);
            context.pop();
            AppToast.error(context, failure.toString());
          },
          loaded: (_) async {
            AppProgressIndicator.hide(context);

            // RestartWidget.restartApp(context);

            context.pop();
            context.goNamed(AppRouteName.signIn);
            AppToast.success(context, "Logout successful");
          },
        );
      },
      child: Center(
        child: TextButton(
          onPressed: () => _logoutDialog(context),
          child: Text(
            "Logout",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: secondarySeedColor,
                ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => _authBloc.add(const AuthEvent.signOut()),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
