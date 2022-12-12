import 'package:dio/dio.dart';
import 'package:flutter_cnblogs/models/version_model.dart';

/// 通用的请求
class CommonRequest {
  /// 检查更新
  Future<VersionModel> checkUpdate() async {
    var result = await Dio().get(
      "https://cdn.jsdelivr.net/gh/xiaoyaocz/flutter_cnblogs@master/document/version.json",
      queryParameters: {
        "ts": DateTime.now().millisecondsSinceEpoch,
      },
      options: Options(
        responseType: ResponseType.json,
      ),
    );
    return VersionModel.fromJson(result.data);
  }
}
