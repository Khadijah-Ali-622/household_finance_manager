import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'backup_models.dart';

/// Uses the access token from Google Sign-In. That plugin does not hand back
/// a refresh token, so each Drive call builds a new client with a fresh token.
http.Client createDriveClient(String accessToken) {
  final credentials = AccessCredentials(
    AccessToken(
      'Bearer',
      accessToken,
      DateTime.now().toUtc().add(const Duration(minutes: 50)),
    ),
    null,
    const [BackupPayload.driveAppDataScope],
  );
  return authenticatedClient(
    http.Client(),
    credentials,
    closeUnderlyingClient: true,
  );
}
