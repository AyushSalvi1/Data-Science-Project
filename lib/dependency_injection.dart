import 'package:flutter_ecommerce/core/blocs/user_local_data/user_local_data_bloc.dart';
import 'package:flutter_ecommerce/core/repositories/image_uploader_repository.dart';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/core/services/offline_cache_service.dart';
import 'package:flutter_ecommerce/features/address/blocs/address_bloc/address_bloc.dart';
import 'package:flutter_ecommerce/features/address/blocs/current_shipping_address_bloc/current_shipping_address_bloc.dart';
import 'package:flutter_ecommerce/features/address/blocs/get_address_bloc/get_address_bloc.dart';
import 'package:flutter_ecommerce/features/address/repositories/address_repository.dart';
import 'package:flutter_ecommerce/features/ai_assistant/repositories/ai_assistant_repository.dart';
import 'package:flutter_ecommerce/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/auth/repositories/auth_repository.dart';
import 'package:flutter_ecommerce/features/cart/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/blocs/get_cart_bloc/get_cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/repositories/cart_repository.dart';
import 'package:flutter_ecommerce/features/category/blocs/category_bloc/category_bloc.dart';
import 'package:flutter_ecommerce/features/category/blocs/get_category_bloc/get_category_bloc.dart';
import 'package:flutter_ecommerce/features/category/repositories/category_repository.dart';
import 'package:flutter_ecommerce/features/multi_retailer/repositories/multi_retailer_repository.dart';
import 'package:flutter_ecommerce/features/order/blocs/get_order_bloc/get_order_bloc.dart';
import 'package:flutter_ecommerce/features/order/blocs/get_vendor_order_bloc/get_vendor_order_bloc.dart';
import 'package:flutter_ecommerce/features/order/blocs/order_bloc/order_bloc.dart';
import 'package:flutter_ecommerce/features/order/repositories/order_repository.dart';
import 'package:flutter_ecommerce/features/price_tracking/repositories/price_tracking_repository.dart';
import 'package:flutter_ecommerce/features/product/blocs/get_product_bloc/get_product_bloc.dart';
import 'package:flutter_ecommerce/features/product/blocs/product_bloc/product_bloc.dart';
import 'package:flutter_ecommerce/features/product/blocs/product_by_category_bloc/product_by_category_bloc.dart';
import 'package:flutter_ecommerce/features/product/repositories/product_repository.dart';
import 'package:flutter_ecommerce/features/review/repositories/review_repository.dart';
import 'package:flutter_ecommerce/features/search/blocs/search_bloc/search_bloc.dart';
import 'package:flutter_ecommerce/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_ecommerce/features/user/repositories/user_repository.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:flutter_ecommerce/features/wishlist/repositories/wishlist_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  // === CORE / EXTERNAL ===
  final SharedPreferences pref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => pref);
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<OfflineCacheService>(() => OfflineCacheService(pref: sl()));

  // === CORE REPOSITORIES ===
  sl.registerLazySingleton<UserLocalDataRepository>(
    () => UserLocalDataRepositoryI(pref: sl()),
  );
  sl.registerLazySingleton<ImageUploaderRepository>(
    () => ImageUploaderRepositoryI(client: sl()),
  );

  // === FEATURE REPOSITORIES ===
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryI(client: sl(), repo: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryI(repo: sl(), client: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryI(client: sl(), imageUploaderRepo: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryI(
      client: sl(),
      imageUploaderRepo: sl(),
      userRepository: sl(),
    ),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryI(client: sl(), userRepo: sl()),
  );
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryI(client: sl(), userRepo: sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryI(client: sl(), userRepo: sl()),
  );

  // === ENHANCED REPOSITORIES ===
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryI(
      client: sl(),
      cacheService: sl(),
      userRepo: sl(),
    ),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryI(client: sl(), userRepo: sl()),
  );
  sl.registerLazySingleton<PriceTrackingRepository>(
    () => PriceTrackingRepositoryI(client: sl()),
  );
  sl.registerLazySingleton<MultiRetailerRepository>(
    () => MultiRetailerRepositoryI(),
  );
  sl.registerLazySingleton<AIAssistantRepository>(
    () => AIAssistantRepositoryI(multiRetailerRepo: sl()),
  );

  // === CORE BLOCS ===
  sl.registerLazySingleton(() => UserLocalDataBloc(repo: sl()));

  // === FEATURE BLOCS ===
  sl.registerFactory(() => AuthBloc(repo: sl()));
  sl.registerLazySingleton(() => UserBloc(userRepo: sl()));
  sl.registerLazySingleton(() => CategoryBloc(repo: sl()));
  sl.registerLazySingleton(() => GetCategoryBloc(repo: sl()));
  sl.registerLazySingleton(() => ProductBloc(repo: sl()));
  sl.registerLazySingleton(() => GetProductBloc(repo: sl()));
  sl.registerLazySingleton(() => ProductByCategoryBloc(repo: sl()));
  sl.registerLazySingleton(() => GetCartBloc(repo: sl()));
  sl.registerFactory(() => CartBloc(repo: sl(), getCartBloc: sl()));
  sl.registerLazySingleton(() => AddressBloc(repo: sl()));
  sl.registerLazySingleton(() => GetAddressBloc(repo: sl()));
  sl.registerLazySingleton(() => CurrentShippingAddressBloc());
  sl.registerLazySingleton(() => GetOrderBloc(repo: sl()));
  sl.registerLazySingleton(() => GetVendorOrderBloc(repo: sl()));
  sl.registerFactory(() => OrderBloc(repo: sl(), bloc: sl()));
  sl.registerCachedFactory(() => SearchBloc(repo: sl()));

  // Enhanced Blocs
  sl.registerLazySingleton(() => WishlistBloc(repo: sl()));
}

Future<void> reset() async {
  await sl.reset();
  await init();
}
