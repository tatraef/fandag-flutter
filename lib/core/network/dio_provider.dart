import 'package:dio/dio.dart';
import 'package:fandag/config.dart';
import 'package:fandag/core/constants/constants.dart';
import 'package:fandag/core/inspector/inspector.dart';
import 'package:fandag/core/network/api_client.dart';
import 'package:fandag/core/network/api_exception_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:mad_inspector_dio/mad_inspector_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: AppDurations.connectionTimeout,
      receiveTimeout: AppDurations.receiveTimeout,
      // On web, dio throws if sendTimeout is set for requests without a body
      // (e.g. GET). Disable it there and keep it on native platforms.
      sendTimeout: kIsWeb ? null : AppDurations.sendTimeout,
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll(<Interceptor>[
    if (isInspectorOnDebugMode) MadDioModule.interceptor,
  ]);

  return dio;
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);

  return ApiClient(dio: dio, errorInterceptor: ApiExceptionConverter.convert);
}
