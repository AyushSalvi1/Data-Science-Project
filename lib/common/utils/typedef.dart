import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/core/failure/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
