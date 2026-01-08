enum CapVPNConnectionStage {
  preparing,
  authenticating,
  connecting,
  authenticated,
  connected,
  disconnected,
  disconnecting,
  denied,
  error,
  waitingConnection,
  generatingConfig,
  gettingConfig,
  tcpConnecting,
  udpConnecting,
  assigningIp,
  resolving,
  exiting,
  unknown;


  // final String value;

  // const NagorikVpnConnectionStage(this.value);

  //from value
  static CapVPNConnectionStage fromOpenVpnValue(String value) {
    switch (value) {
      case "preparing":
        return CapVPNConnectionStage.preparing;
      case "authenticating":
        return CapVPNConnectionStage.authenticating;
      case "connecting":
        return CapVPNConnectionStage.connecting;
      case "authenticated":
        return CapVPNConnectionStage.authenticated;
      case "connected":
        return CapVPNConnectionStage.connected;
      case "disconnected":
        return CapVPNConnectionStage.disconnected;
      case "disconnecting":
        return CapVPNConnectionStage.disconnecting;
      case "denied":
        return CapVPNConnectionStage.denied;
      case "error":
        return CapVPNConnectionStage.error;
      case "waitingConnection":
        return CapVPNConnectionStage.waitingConnection;
      case "wait_connection":
        return CapVPNConnectionStage.waitingConnection;
      case "generatingConfig":
        return CapVPNConnectionStage.generatingConfig;
      case "gettingConfig":
        return CapVPNConnectionStage.gettingConfig;
      case "get_config":
        return CapVPNConnectionStage.generatingConfig;
      case "tcpConnecting":
        return CapVPNConnectionStage.tcpConnecting;
      case "udpConnecting":
        return CapVPNConnectionStage.udpConnecting;
      case "assigningIp":
        return CapVPNConnectionStage.assigningIp;
      case "assign_ip":
        return CapVPNConnectionStage.assigningIp;
      case "resolving":
        return CapVPNConnectionStage.resolving;
      case "exiting":
        return CapVPNConnectionStage.exiting;
      case "unknown":
        return CapVPNConnectionStage.unknown;
      default:
        return CapVPNConnectionStage.unknown;
    }
  }

  static CapVPNConnectionStage fromWireguardValue(String value){
    // connected('connected'),
    // connecting('connecting'),
    // disconnecting('disconnecting'),
    // disconnected('disconnected'),
    // waitingConnection('wait_connection'),
    // authenticating('authenticating'),
    // reconnect('reconnect'),
    // noConnection('no_connection'),
    // preparing('prepare'),
    // denied('denied'),
    // exiting('exiting');

    switch (value) {
      case "connected":
        return CapVPNConnectionStage.connected;
      case "connecting":
        return CapVPNConnectionStage.connecting;
      case "disconnecting":
        return CapVPNConnectionStage.disconnecting;
      case "disconnected":
        return CapVPNConnectionStage.disconnected;
      case "wait_connection":
        return CapVPNConnectionStage.waitingConnection;
      case "authenticating":
        return CapVPNConnectionStage.authenticating;
      case "reconnect":
        return CapVPNConnectionStage.connecting; // Assuming reconnect maps to connecting
      case "no_connection":
        return CapVPNConnectionStage.disconnected; // Assuming no_connection maps to disconnected
      case "prepare":
        return CapVPNConnectionStage.preparing;
      case "denied":
        return CapVPNConnectionStage.denied;
      case "exiting":
        return CapVPNConnectionStage.exiting;
      case "unknown":
        return CapVPNConnectionStage.unknown;
      default:
        return CapVPNConnectionStage.unknown;
    }
  }
}
