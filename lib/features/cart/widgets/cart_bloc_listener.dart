// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ecommerce/common/utils/loading_dialog.dart';
import 'package:flutter_ecommerce/common/utils/toast_msg.dart';
import 'package:flutter_ecommerce/features/cart/blocs/cart_bloc/cart_bloc.dart';

class CartBlocListener extends StatelessWidget {
  const CartBlocListener({
    super.key,
    required this.child,
    required this.bloc,
  });
  final Widget child;
  final CartBloc bloc;
  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      bloc: bloc,
      listener: (context, state) {
        state.whenOrNull(
            loading: () async =>
                await AppProgressIndicator.showWithContainer(context),
            loaded: (data) {
           
              AppProgressIndicator.hide(context);
              AppToast.success(context, data);
            },
            failure: (failure) => AppToast.error(context, failure.toString()));
      },
      child: child,
    );
  }
}
