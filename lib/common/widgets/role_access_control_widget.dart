import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/blocs/user_local_data/user_local_data_bloc.dart';

class RoleBasedWidget extends StatelessWidget {
  const RoleBasedWidget({
    super.key,
    this.generalUser,
    this.vendorUser,
    this.adminUser,
    this.sharedAdminVendor,
  });

  final Widget? generalUser;
  final Widget? vendorUser;
  final Widget? sharedAdminVendor;
  final Widget? adminUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLocalDataBloc, UserLocalDataState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => generalUser ?? const SizedBox.shrink(),
          loaded: (user) {
            switch (user.role) {
              case "admin":
                return _buildAdminContent();
              case "vendor":
                return _buildVendorContent();
              default:
                return generalUser ?? const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildAdminContent() {
    final children = <Widget>[];
    if (sharedAdminVendor != null) children.add(sharedAdminVendor!);
    if (adminUser != null) children.add(adminUser!);
    return children.isNotEmpty
        ? Column(children: children)
        : const SizedBox.shrink();
  }

  Widget _buildVendorContent() {
    final children = <Widget>[];
    if (sharedAdminVendor != null) children.add(sharedAdminVendor!);
    if (vendorUser != null) children.add(vendorUser!);
    return children.isNotEmpty
        ? Column(children: children)
        : const SizedBox.shrink();
  }
}
