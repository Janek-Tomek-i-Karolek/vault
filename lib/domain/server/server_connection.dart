class ServerConnection {
  final String serverUrl;
  final String apiKey;

  const ServerConnection({required this.serverUrl, required this.apiKey});

  Map<String, String> get jsonHeaders => {
    "x-api-key": apiKey,
    "content-type": "application/json",
  };

  factory ServerConnection.fromJson(Map<String, dynamic> json) =>
      ServerConnection(
        serverUrl: json['serverUrl'] as String,
        apiKey: json['apiKey'] as String,
      );

  Map<String, dynamic> toJson() => {'serverUrl': serverUrl, 'apiKey': apiKey};
}
