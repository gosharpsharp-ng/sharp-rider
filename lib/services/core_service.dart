import 'dart:io';

import 'package:dio/dio.dart' as dio_pack;
import 'package:dio/dio.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class CoreService extends GetConnect {
  final _dio = dio_pack.Dio();

  CoreService() {
    // _dio.options.baseUrl = dotenv.env['BASE_URL']!;
    _dio.options.baseUrl = "https://logistics.gosharpsharp.com/api/v1";
    setConfig();
  }
  final getStorage = GetStorage();

  Map<String, String> multipartHeaders = {};

  setConfig() {
    _dio.interceptors.add(
      dio_pack.InterceptorsWrapper(
        onRequest: (options, handler) {
          var token = getStorage.read('token');
          options.headers['content-Type'] = 'application/json';
          if (token != null) {
            options.headers['Authorization'] = "Bearer $token";
          }
          return handler.next(options); //continue
        },
      ),
    );
  }

  // login post
  Future<APIResponse> sendLogin(
    String url,
    payload,
  ) async {
    try {
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        await getStorage.write("id", payload['id']);
        await getStorage.write("password", payload['password']);
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong ");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general post
  Future<APIResponse> send(
    String url,
    payload,
  ) async {
    try {
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
            "*****************************************************************************************888");
        print(e.response!.data.toString());
        print(
            "*****************************************************************************************888");
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong ");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general upload
  Future<APIResponse> upload(String url, String path) async {
    try {
      dio_pack.MultipartFile file = await dio_pack.MultipartFile.fromFile(path);
      dio_pack.FormData payload =
          dio_pack.FormData.fromMap({'attach_file': file});
      final res = await _dio.post(
        url,
        data: payload,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general get
  Future<APIResponse> fetch(String url) async {
    try {
      final res = await _dio.get(url);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
            "*****************************************************************************************888");
        print("URL: $url");
        print(e.response!.data.toString());
        print(
            "*****************************************************************************************888");
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general get by params
  Future<APIResponse> fetchByParams(
      String url, Map<String, dynamic> params) async {
    try {
      final res = await _dio.get(url, queryParameters: params);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general put
  Future<APIResponse> update(String url, data) async {
    try {
      final res = await _dio.put(url, data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // form put
  Future<APIResponse> formUpdate(String url, Map<String, dynamic> data) async {
    try {
      // Build the FormData payload dynamically
      final Map<String, dynamic> formDataMap = {};

      for (var entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value != null) {
          // If the value is a file path, convert it to MultipartFile
          if (key == 'avatar' && value is File) {
            formDataMap[key] =
                await dio_pack.MultipartFile.fromFile(value.path);
          } else {
            formDataMap[key] = value;
          }
        }
      }

      dio_pack.FormData payload = dio_pack.FormData.fromMap(formDataMap);
      // Perform the PUT request
      final res = await _dio.put(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    }

    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // general delete
  Future<APIResponse> remove(String url, data) async {
    try {
      final res = await _dio.delete(url);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }
}
