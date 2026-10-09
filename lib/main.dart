import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ecommerce/common/theme/app_theme.dart';
import 'package:flutter_ecommerce/core/app/restart_widget.dart';
import 'package:flutter_ecommerce/core/blocs/user_local_data/user_local_data_bloc.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/address/blocs/address_bloc/address_bloc.dart';
import 'package:flutter_ecommerce/features/address/blocs/current_shipping_address_bloc/current_shipping_address_bloc.dart';
import 'package:flutter_ecommerce/features/address/blocs/get_address_bloc/get_address_bloc.dart';
import 'package:flutter_ecommerce/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/cart/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/blocs/get_cart_bloc/get_cart_bloc.dart';
import 'package:flutter_ecommerce/features/category/blocs/category_bloc/category_bloc.dart';
import 'package:flutter_ecommerce/features/category/blocs/get_category_bloc/get_category_bloc.dart';
import 'package:flutter_ecommerce/features/order/blocs/get_order_bloc/get_order_bloc.dart';
import 'package:flutter_ecommerce/features/order/blocs/get_vendor_order_bloc/get_vendor_order_bloc.dart';
import 'package:flutter_ecommerce/features/order/blocs/order_bloc/order_bloc.dart';
import 'package:flutter_ecommerce/features/product/blocs/get_product_bloc/get_product_bloc.dart';
import 'package:flutter_ecommerce/features/product/blocs/product_bloc/product_bloc.dart';
import 'package:flutter_ecommerce/features/product/blocs/product_by_category_bloc/product_by_category_bloc.dart';
import 'package:flutter_ecommerce/features/search/blocs/search_bloc/search_bloc.dart';
import 'package:flutter_ecommerce/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load();
  } catch (_) {}

  final url = dotenv.maybeGet('SUPABASE_URL') ?? 'https://xyzcompany.supabase.co';
  final annonKey = dotenv.maybeGet('SUPABASE_ANNONKEY') ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.fake_key';

  try {
    await Supabase.initialize(
      url: url,
      anonKey: annonKey,
    );
  } catch (_) {}

  await init();
  runApp(const RestartWidget(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<CategoryBloc>()),
        BlocProvider(create: (context) => sl<ProductBloc>()),
        BlocProvider(create: (context) => sl<CartBloc>()),
        BlocProvider(create: (context) => sl<AddressBloc>()),
        BlocProvider(create: (context) => sl<OrderBloc>()),
        BlocProvider(create: (context) => sl<CurrentShippingAddressBloc>()),
        BlocProvider(create: (context) => sl<ProductByCategoryBloc>()),
        BlocProvider(create: (context) => sl<SearchBloc>()),
        BlocProvider(
          create: (context) => sl<WishlistBloc>()..add(const LoadWishlistEvent()),
        ),
        BlocProvider(
            create: (context) =>
                sl<GetVendorOrderBloc>()..add(GetVendorOrderEvent.get())),
        BlocProvider(
            create: (context) => sl<GetOrderBloc>()..add(GetOrderEvent.get())),
        BlocProvider(
            create: (context) =>
                sl<GetAddressBloc>()..add(GetAddressEvent.get())),
        BlocProvider(
            create: (context) => sl<GetCartBloc>()..add(GetCartEvent.get())),
        BlocProvider(
            create: (context) =>
                sl<GetProductBloc>()..add(GetProductEvent.get())),
        BlocProvider(
            create: (context) =>
                sl<GetCategoryBloc>()..add(GetCategoryEvent.get())),
        BlocProvider(
            create: (context) =>
                sl<UserLocalDataBloc>()..add(UserLocalDataEvent.get())),
        BlocProvider(
            create: (context) =>
                sl<UserBloc>()..add(UserEvent.getCurrentUserData())),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "ShopWave",
        routerConfig: AppRoute.route,
        theme: lightTheme(context),
        // darkTheme: darkTheme(context),
      ),
    );
  }
}
