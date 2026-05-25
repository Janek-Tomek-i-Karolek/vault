class ServerConnection {
  final String serverUrl;
  final String apiKey;

  ServerConnection({required this.serverUrl, required this.apiKey});

  Map<String, String> get jsonHeaders => {
    "x-api-key": apiKey,
    "content-type": "application/json",
  };
}
