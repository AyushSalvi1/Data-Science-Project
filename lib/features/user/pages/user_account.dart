import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/blocs/user_local_data/user_local_data_bloc.dart';
import 'package:flutter_ecommerce/common/utils/toast_msg.dart';
import 'package:flutter_ecommerce/common/widgets/app_loading.dart';
// import 'package:flutter_ecommerce/common/widgets/role_access_control_widget.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_ecommerce/features/user/widgets/user_account_body.dart';
// import 'package:flutter_ecommerce/routes.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:go_router/go_router.dart';

class UserAccountPage extends StatelessWidget {
  const UserAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: RoleBasedWidget(
      //     adminUser: SpeedDial(
      //   // animatedIcon: AnimatedIcons.menu_close,
      //   activeIcon: Icons.close,
      //   icon: Icons.add,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //   children: [
      //     SpeedDialChild(
      //       label: "Add Product",
      //       onTap: () => context.pushNamed(AppRouteName.productForm),
      //     ),
      //     SpeedDialChild(
      //         label: "Add Category",
      //         onTap: () => context.pushNamed(AppRouteName.categoryForm))
      //   ],
      // )),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          state.whenOrNull(
            failure: (failure) => AppToast.error(context, failure.toString()),
            loaded: (data) =>
                sl<UserLocalDataBloc>().add(UserLocalDataEvent.get()),
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
              orElse: () => SizedBox.shrink(),
              loading: () => AppLoading.center(),
              loaded: (user) => UserAccountBody(
                    user: user,
                  ));
        },
      ),
    );
  }
}
