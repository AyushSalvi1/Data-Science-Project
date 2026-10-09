// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ecommerce/core/blocs/user_local_data/user_local_data_bloc.dart';

class AuthWidgetHandler extends StatelessWidget {
  const AuthWidgetHandler({
    super.key,
    this.unAuthWidget,
    required this.authWidget,
  });
  final Widget? unAuthWidget;
  final Widget authWidget;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLocalDataBloc, UserLocalDataState>(
      builder: (context, state) {
        return state.maybeWhen(
            orElse: () => unAuthWidget ?? SizedBox.shrink(),
            loaded: (_) => authWidget);
      },
    );
  }
}
