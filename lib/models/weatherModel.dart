class ICurrently {
  double? time;
  dynamic summary;
  dynamic icon;
  double? precipIntensity;
  double? precipProbability;
  dynamic precipType;
  double? temperature;
  double? apparentTemperature;
  double? dewPoint;
  double? humidity;
  double? pressure;
  double? windSpeed;
  double? windGust;
  double? windBearing;
  double? cloudCover;
  double? uvIndex;
  double? visibility;
  double? ozone;

  ICurrently({
    this.apparentTemperature,
    this.cloudCover,
    this.dewPoint,
    this.humidity,
    this.icon,
    this.ozone,
    this.precipIntensity,
    this.precipProbability,
    this.precipType,
    this.pressure,
    this.summary,
    this.temperature,
    this.time,
    this.uvIndex,
    this.visibility,
    this.windBearing,
    this.windGust,
    this.windSpeed,
  });

  factory ICurrently.fromJson(Map<String, dynamic> json) {
    return ICurrently(
      time: (json["time"] as num?)?.toDouble(),
      summary: json["summary"],
      icon: json["icon"],
      precipIntensity: (json["precipIntensity"] as num?)?.toDouble(),
      precipProbability: (json["precipProbability"] as num?)?.toDouble(),
      precipType: json["precipType"],
      temperature: (json["temperature"] as num?)?.toDouble(),
      apparentTemperature: (json["apparentTemperature"] as num?)?.toDouble(),
      dewPoint: (json["dewPoint"] as num?)?.toDouble(),
      humidity: (json["humidity"] as num?)?.toDouble(),
      pressure: (json["pressure"] as num?)?.toDouble(),
      windSpeed: (json["windSpeed"] as num?)?.toDouble(),
      windGust: (json["windGust"] as num?)?.toDouble(),
      windBearing: (json["windBearing"] as num?)?.toDouble(),
      cloudCover: (json["cloudCover"] as num?)?.toDouble(),
      uvIndex: (json["uvIndex"] as num?)?.toDouble(),
      visibility: (json["visibility"] as num?)?.toDouble(),
      ozone: (json["ozone"] as num?)?.toDouble(),
    );
  }
}

class IHourly {
  dynamic summary;
  dynamic icon;
  List<ICurrently>? data;

  IHourly({this.summary, this.icon, this.data});

  factory IHourly.fromJson(Map<String, dynamic> json) {
    return IHourly(
      summary: json["summary"],
      icon: json["icon"],
      data: (json["data"] as List<dynamic>?)
          ?.map((e) => ICurrently.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IDailyObject {
  double? time;
  dynamic summary;
  dynamic icon;
  double? sunriseTime;
  double? sunsetTime;
  double? moonPhase;
  double? precipIntensity;
  double? precipIntensityMax;
  double? precipIntensityMaxTime;
  double? precipProbability;
  dynamic precipType;
  double? temperatureHigh;
  double? temperatureHighTime;
  double? temperatureLow;
  double? temperatureLowTime;
  double? apparentTemperatureHigh;
  double? apparentTemperatureHighTime;
  double? apparentTemperatureLow;
  double? apparentTemperatureLowTime;
  double? dewPoint;
  double? humidity;
  double? pressure;
  double? windSpeed;
  double? windGust;
  double? windGustTime;
  double? windBearing;
  double? cloudCover;
  double? uvIndex;
  double? uvIndexTime;
  double? visibility;
  double? ozone;
  double? temperatureMin;
  double? temperatureMinTime;
  double? temperatureMax;
  double? temperatureMaxTime;
  double? apparentTemperatureMin;
  double? apparentTemperatureMinTime;
  double? apparentTemperatureMax;
  double? apparentTemperatureMaxTime;

  IDailyObject({
    this.icon,
    this.summary,
    this.windSpeed,
    this.windGust,
    this.windBearing,
    this.visibility,
    this.uvIndex,
    this.time,
    this.pressure,
    this.precipType,
    this.precipProbability,
    this.precipIntensity,
    this.ozone,
    this.humidity,
    this.dewPoint,
    this.cloudCover,
    this.apparentTemperatureHigh,
    this.apparentTemperatureHighTime,
    this.apparentTemperatureLow,
    this.apparentTemperatureLowTime,
    this.apparentTemperatureMax,
    this.apparentTemperatureMaxTime,
    this.apparentTemperatureMin,
    this.apparentTemperatureMinTime,
    this.moonPhase,
    this.precipIntensityMax,
    this.precipIntensityMaxTime,
    this.sunriseTime,
    this.sunsetTime,
    this.temperatureHigh,
    this.temperatureHighTime,
    this.temperatureLow,
    this.temperatureLowTime,
    this.temperatureMax,
    this.temperatureMaxTime,
    this.temperatureMin,
    this.temperatureMinTime,
    this.uvIndexTime,
    this.windGustTime,
  });

  factory IDailyObject.fromJson(Map<String, dynamic> json) {
    return IDailyObject(
      time: (json["time"] as num?)?.toDouble(),
      summary: json["summary"],
      icon: json["icon"],
      sunriseTime: (json["sunriseTime"] as num?)?.toDouble(),
      sunsetTime: (json["sunsetTime"] as num?)?.toDouble(),
      moonPhase: (json["moonPhase"] as num?)?.toDouble(),
      precipIntensity: (json["precipIntensity"] as num?)?.toDouble(),
      precipIntensityMax: (json["precipIntensityMax"] as num?)?.toDouble(),
      precipIntensityMaxTime: (json["precipIntensityMaxTime"] as num?)?.toDouble(),
      precipProbability: (json["precipProbability"] as num?)?.toDouble(),
      precipType: json["precipType"],
      temperatureHigh: (json["temperatureHigh"] as num?)?.toDouble(),
      temperatureHighTime: (json["temperatureHighTime"] as num?)?.toDouble(),
      temperatureLow: (json["temperatureLow"] as num?)?.toDouble(),
      temperatureLowTime: (json["temperatureLowTime"] as num?)?.toDouble(),
      apparentTemperatureHigh: (json["apparentTemperatureHigh"] as num?)?.toDouble(),
      apparentTemperatureHighTime: (json["apparentTemperatureHighTime"] as num?)?.toDouble(),
      apparentTemperatureLow: (json["apparentTemperatureLow"] as num?)?.toDouble(),
      apparentTemperatureLowTime: (json["apparentTemperatureLowTime"] as num?)?.toDouble(),
      dewPoint: (json["dewPoint"] as num?)?.toDouble(),
      humidity: (json["humidity"] as num?)?.toDouble(),
      pressure: (json["pressure"] as num?)?.toDouble(),
      windSpeed: (json["windSpeed"] as num?)?.toDouble(),
      windGust: (json["windGust"] as num?)?.toDouble(),
      windGustTime: (json["windGustTime"] as num?)?.toDouble(),
      windBearing: (json["windBearing"] as num?)?.toDouble(),
      cloudCover: (json["cloudCover"] as num?)?.toDouble(),
      uvIndex: (json["uvIndex"] as num?)?.toDouble(),
      uvIndexTime: (json["uvIndexTime"] as num?)?.toDouble(),
      visibility: (json["visibility"] as num?)?.toDouble(),
      ozone: (json["ozone"] as num?)?.toDouble(),
      temperatureMin: (json["temperatureMin"] as num?)?.toDouble(),
      temperatureMinTime: (json["temperatureMinTime"] as num?)?.toDouble(),
      temperatureMax: (json["temperatureMax"] as num?)?.toDouble(),
      temperatureMaxTime: (json["temperatureMaxTime"] as num?)?.toDouble(),
      apparentTemperatureMin: (json["apparentTemperatureMin"] as num?)?.toDouble(),
      apparentTemperatureMinTime: (json["apparentTemperatureMinTime"] as num?)?.toDouble(),
      apparentTemperatureMax: (json["apparentTemperatureMax"] as num?)?.toDouble(),
      apparentTemperatureMaxTime: (json["apparentTemperatureMaxTime"] as num?)?.toDouble(),
    );
  }
}

class IDaily {
  dynamic summary;
  dynamic icon;
  List<IDailyObject>? data;

  IDaily({this.summary, this.icon, this.data});

  factory IDaily.fromJson(Map<String, dynamic> json) {
    return IDaily(
      summary: json["summary"],
      icon: json["icon"],
      data: (json["data"] as List<dynamic>?)
          ?.map((e) => IDailyObject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IFlags {
  List<dynamic>? sources;
  double? nearest_station;
  dynamic units;

  IFlags({this.nearest_station, this.sources, this.units});

  factory IFlags.fromJson(Map<String, dynamic> json) {
    return IFlags(
      nearest_station: (json["nearest_station"] as num?)?.toDouble(),
      sources: json["sources"] as List<dynamic>?,
      units: json["units"],
    );
  }
}

class WeatherModel {
  dynamic id;
  ICurrently? currently;
  IDaily? daily;
  IFlags? flags;
  IHourly? hourly;
  double? latitude;
  double? longitude;
  double? offset;
  dynamic timezone;
  dynamic createDate;
  dynamic province_id;

  WeatherModel({
    this.longitude,
    this.latitude,
    this.province_id,
    this.id,
    this.createDate,
    this.currently,
    this.daily,
    this.flags,
    this.hourly,
    this.offset,
    this.timezone,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      province_id: json["province_id"],
      createDate: json["createDate"],
      currently: json["currently"] != null
          ? ICurrently.fromJson(json["currently"])
          : null,
      daily: json["daily"] != null ? IDaily.fromJson(json["daily"]) : null,
      flags: json["flags"] != null ? IFlags.fromJson(json["flags"]) : null,
      hourly: json["hourly"] != null ? IHourly.fromJson(json["hourly"]) : null,
      id: json["id"],
      latitude: (json["latitude"] as num?)?.toDouble(),
      longitude: (json["longitude"] as num?)?.toDouble(),
      offset: (json["offset"] as num?)?.toDouble(),
      timezone: json["timezone"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "currently": currently,
      "daily": daily,
      "flags": flags,
      "hourly": hourly,
      "id": id,
      "latitude": latitude,
      "longitude": longitude,
      "offset": offset,
      "timezone": timezone,
      "province_id": province_id,
      "createDate": createDate,
    };
  }
}
