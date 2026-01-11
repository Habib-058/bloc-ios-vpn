import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';

class SelectedServer {
  final String? countryName;
  final ServerModel? server;
  final String? flagUrl;

  SelectedServer({
    required this.countryName,
    required this.server,
    required this.flagUrl,
  });
}