class CapVPNConnectionStatus {
  final DateTime? startedAt;
  final String? duration;
  final String? lastPacketReceive;
  final String? startTime;
  final String? mbIn;
  final String? mbOut;
  final String? packetsIn;
  final String? packetsOut;
  final String? endTime;

  CapVPNConnectionStatus({
    this.startedAt,
    this.startTime,
    this.lastPacketReceive,
    this.duration,
    this.mbIn,
    this.mbOut,
    this.packetsIn,
    this.packetsOut,
    this.endTime,
  });

  Map<String, dynamic> toJson() => {
    "started_at": startedAt,
    "duration": duration,
    "byte_in": mbIn,
    "byte_out": mbOut,
    "packets_in": packetsIn,
    "packets_out": packetsOut,
  };

  factory CapVPNConnectionStatus.fromJson(Map<String, dynamic> data) {
    // print("dataForAndroid ${data.toString()}");
    return CapVPNConnectionStatus(
      lastPacketReceive: data["lastPacketReceive"],
      startTime: data["startTime"],
      mbIn: getByte(data["byteIn"].toString()),
      mbOut: getByte(data["byteOut"].toString()),
    );
  }

  // N O     U S E
  factory CapVPNConnectionStatus.fromIosChannelString(dynamic data) {
    // print("helloStatus $data");
    if (data == null) {
      return CapVPNConnectionStatus();
    }

    List<String> dataList = data.split("_");
    if (dataList.length != 5) {
      return CapVPNConnectionStatus();
    }
    String startTime = dataList[0];

    String byteIn = (int.parse(dataList[1])).toString();

    String byteOut = (int.parse(dataList[2])).toString();

    String packetsIn = dataList[3];
    String packetsOut = dataList[4];

    String formattedTimestamp = getOnly24HourTime(startTime);

    return CapVPNConnectionStatus(
      startTime: formattedTimestamp,
      mbIn: getByte(byteIn),
      mbOut: getByte(byteOut),
      packetsIn: packetsIn,
      packetsOut: packetsOut,
    );
  }

  // copy with
  CapVPNConnectionStatus copyWith({
    DateTime? startedAt,
    String? duration,
    String? lastPacketReceive,
    String? startTime,
    String? mbIn,
    String? mbOut,
    String? packetsIn,
    String? packetsOut,
    String? endTime,
  }) {
    return CapVPNConnectionStatus(
      startedAt: startedAt ?? this.startedAt,
      duration: duration ?? this.duration,
      lastPacketReceive: lastPacketReceive ?? this.lastPacketReceive,
      startTime: startTime ?? this.startTime,
      mbIn: mbIn ?? this.mbIn,
      mbOut: mbOut ?? this.mbOut,
      packetsIn: packetsIn ?? this.packetsIn,
      packetsOut: packetsOut ?? this.packetsOut,
      endTime: endTime ?? this.endTime,
    );
  }

  static String getByte(String byte) {
    // print("hitByte ${byte.split('.').first}");
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;
    if (byte == "" || byte == null) {
      return "0 B";
    }
    try {
      int byteData = int.parse(byte.split('.').first);
      // print("byteDataGot ${byteData.toString()}");

      // if (byteData < 1024) {
      //   return "$byteData B";
      // } else if (byteData < 1024 * 1024) {
      //   return "${(byteData / 1024).toStringAsFixed(2)} KB";
      // } else if (byteData < 1024 * 1024 * 1024) {
      //   return "${(byteData / (1024 * 1024)).toStringAsFixed(2)} MB";
      // } else {
      //   return "${(byteData / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";

      if (byteData >= gb) {
        double result = byteData / gb;
        return '${result.toStringAsFixed(2)} GB';
      } else if (byteData >= mb) {
        double result = byteData / mb;
        return '${result.toStringAsFixed(2)} MB';
      } else if (byteData >= kb) {
        double result = byteData / kb;
        return '${result.toStringAsFixed(2)} KB';
      } else {
        return '$byteData B';
      }

      // }
    } catch (e) {
      return "0 B";
    }
  }

  static String getOnly24HourTime(String date) {
    String extractValue = date;
    bool containsPM = date.toUpperCase().contains("PM");
    if (containsPM) {
      extractValue = date.replaceAll(" PM", "");
      extractValue = extractValue.replaceAll("PM", "");
    } else {
      bool containsAM = date.toUpperCase().contains("AM");
      if (containsAM) {
        extractValue = date.replaceAll(" AM", "");
        extractValue = extractValue.replaceAll("AM", "");
      }
    }

    if (containsPM) {
      var dateArray = extractValue.split(" ");
      var getTimeOnly = dateArray[1];
      var getDateOnly = dateArray[0];

      var timeArray = getTimeOnly.split(":");
      var getHour = get24FormatHourData(timeArray[0]);
      var seconds = timeArray[2].replaceAll(" ", "");
      var getTime = "$getHour:${timeArray[1]}:$seconds";
      var finalDateTime = "$getDateOnly $getTime";
      extractValue = finalDateTime;
    }

    return extractValue;
  }

  static String get24FormatHourData(String data) {
    var expected = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"];
    var returned = [
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      "23"
    ];
    var expIndex = expected.indexOf(data);
    var resultValue = returned[expIndex];
    return resultValue.toString();
  }

  @override
  String toString() {
    return 'NagorikVpnConnectionStatus(startedAt: $startedAt, duration: $duration, lastPacketReceive: $lastPacketReceive, startTime: $startTime, mbIn: $mbIn, mbOut: $mbOut, packetsIn: $packetsIn, packetsOut: $packetsOut, endTime: $endTime)';
  }
}
