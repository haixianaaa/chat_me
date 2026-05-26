import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  String apiKey;
  String baseUrl;
  String model;

  AiService({
    required this.apiKey,
    this.baseUrl = 'https://token-plan-sgp.xiaomimimo.com/v1',
    this.model = 'mimo-v2.5-pro',
  });

  Stream<String> chat({
    required List<Map<String, String>> messages,
  }) async* {
    if (apiKey.isEmpty) {
      yield '请先在设置中配置 API Key';
      return;
    }

    final uri = Uri.parse('$baseUrl/chat/completions');
    final body = jsonEncode({
      'model': model,
      'messages': messages,
      'stream': true,
    });

    try {
      final request = http.Request('POST', uri);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'api-key': apiKey,
      });
      request.body = body;

      final client = http.Client();
      final response = await client.send(request);

      if (response.statusCode != 200) {
        final respBody = await response.stream.bytesToString();
        yield '请求失败 (${response.statusCode}): $respBody';
        client.close();
        return;
      }

      String buffer = '';
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        buffer += chunk;
        while (buffer.contains('\n')) {
          final index = buffer.indexOf('\n');
          final line = buffer.substring(0, index).trim();
          buffer = buffer.substring(index + 1);

          if (line.isEmpty || !line.startsWith('data: ')) continue;
          final data = line.substring(6);
          if (data == '[DONE]') {
            client.close();
            return;
          }

          try {
            final json = jsonDecode(data);
            final content = json['choices']?[0]?['delta']?['content'];
            if (content != null) {
              yield content;
            }
          } catch (_) {
            // 忽略解析错误
          }
        }
      }
      client.close();
    } catch (e) {
      yield '连接失败: $e';
    }
  }
}
