import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/failure/failure.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

FutureEither<T> handleApplicationException<T>(
    Future<T> Function() operation) async {
  try {
    final result = await operation();
    return Right(result);
  } on AuthException catch (e) {
    return Left(FailureWithMsg(e.message));
  } on SocketException {
    return Left(FailureWithMsg("Network error"));
  } on TimeoutException {
    return Left(FailureWithMsg("Request timed out. Please try again."));
  } on FormatException {
    return Left(FailureWithMsg("Invalid format. Please check your input."));
  } on PostgrestException catch (e) {
    Logger().d(e.message);
    return Left(FailureWithMsg(e.message));
  } catch (e) {
    Logger().d(e.toString());

    return Left(FailureWithMsg("Unexpected error: ${e.toString()}"));
  }
}
