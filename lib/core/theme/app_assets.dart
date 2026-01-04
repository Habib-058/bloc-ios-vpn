class _CommonAssets {
  static const String _path = '';
  final String splashBackground = '$_path/';
  final String emptyState = '$_path/';
}

class _LightAssets {
  static const String _path = 'assets/images';
  final String cap = '$_path/cap.png';
  final String capSvg = '$_path/svg/cap.svg';
  final String appLogo = '$_path/logo.png';
  final String google = '$_path/google.png';
  final String apple = '$_path/apple.png';
  final String map = '$_path/map.png';
  final String menu = '$_path/menu.png';
  final String menuSvg = '$_path/svg/menu.svg';
  final String disConnected = '$_path/disconnected.png';
  final String connecting = '$_path/connecting.png';
  // final String connecting = '$_path/connecting.gif';
  final String connected = '$_path/connected.png';
  final String flag = '$_path/flag.png';
  final String home = '$_path/home.png';
  final String privacy = '$_path/privacy.png';
  final String server = '$_path/server.png';
  final String email = '$_path/email.png';
  final String share = '$_path/share.png';
  final String diamond = '$_path/diamond.png';
  final String whiteDiamond = '$_path/white_diamond.png';
  final String crown = '$_path/crown.png';
  final String worldBg = '$_path/world_bg.png';
  final String back = '$_path/back.png';
  final String homeCap = '$_path/home_cap.png';
  final String homeCapSvg = '$_path/svg/home_cap.svg';
  final String arrowDown = '$_path/arrow_down.png';
  final String capCircle = '$_path/cap_circle.png';
  final String bag = '$_path/bag.png';
  final String profile = '$_path/profile.png';
  final String congratulations = '$_path/congatulations.png';
  final String star = '$_path/star.png';
}

class _DarkAssets {
  static const String _path = '';
  final String logo = '$_path/';
  final String bgGradient = '$_path/';
  final String calendar = '$_path/';
  final String analytics = '$_path/';
  final String settings = '$_path/';
}

abstract class AppAssets {
  static final common = _CommonAssets();
  static final light = _LightAssets();
  static final dark = _DarkAssets();
}