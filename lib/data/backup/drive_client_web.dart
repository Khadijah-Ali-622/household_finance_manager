import 'package:http/http.dart' as http;

http.Client createDriveClient(String accessToken) {
  return _BearerClient(accessToken);
}

class _BearerClient extends http.BaseClient {
  _BearerClient(this._token) : _inner = http.Client();

  final String _token;
  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_token';
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
