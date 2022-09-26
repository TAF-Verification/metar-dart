# Metar-Dart Documentation

## Introduction

Metar-Dart is a package for Dart programming language designed for parsing aerinautical and
meteorological information from land stations (airports and meteorological offices).

It is strongly influenced by [Python-Metar][python-metar] package, authored by [Tom Pollard][tom-pollard]. 
But, this package is designed to go further in parsing more than METAR reports.

[python-metar]: https://github.com/python-metar/python-metar
[tom-pollard]: https://github.com/tomp

Going through this documentation will take you about an hour, and by the end of it you will have pretty much 
learned the entire API provided to interact with the objects and its methods and properties.

## Installing

The best way of installing the latest version of `Metar-Dart` is running:

For Dart:

```
dart pub add metar_dart
```

For Flutter:

```
flutter pub add metar_dart
```

This will add a line like this to your package's pubspec.yaml (and run an implicit `dart pub get`):

```
dependencies:
  metar_dart: ^0.2.1
```

# Table of contents

<table>
<tr><td width=33% valign=top>

- [Metar-Dart Documentation](#metar-dart-documentation)
  - [Introduction](#introduction)
  - [Installing](#installing)
- [Table of contents](#table-of-contents)
  - [Metar](#metar)
    - [Raw Code](#raw-code)
    - [Sections](#sections)
    - [Unparsed Groups](#unparsed-groups)
    - [The `GroupList` object](#the-grouplist-object)
    - [Type](#type)
    - [Station](#station)
    - [Time](#time)
    - [Modifier](#modifier)
    - [Wind](#wind)
    - [Wind Variation](#wind-variation)
    - [Prevailing Visibility](#prevailing-visibility)
    - [Minimum Visibility](#minimum-visibility)
    - [Runway Ranges](#runway-ranges)
      - [Runway Range](#runway-range)
    - [Weathers](#weathers)
      - [Weather](#weather)
    - [Clouds](#clouds)
      - [Cloud](#cloud)
    - [Temperatures](#temperatures)
    - [Pressure](#pressure)
    - [Recent Weather](#recent-weather)
    - [Windshears](#windshears)
      - [Windshear](#windshear)
    - [Sea State](#sea-state)
    - [Runway State](#runway-state)
  - [Weather Trend](#weather-trend)
    - [Change Period](#change-period)
  - [Remark](#remark)

</td>
<td width=33% valign=top>

- [Taf](#taf)

</td>
<!-- <td valign=top>
</td> -->
</tr>
</table>

## Metar

All features of the `Metar` report are represented as objects in the package. So, these objects have inside
of them another objects as fields, properties and methods. In the next sections you have a tour across all of 
that characteristics. 

Import the `Metar-Dart` package and instantiate the `Metar` object with the following syntax:

```dart
import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
        'KMIA 130053Z COR 25005KT 10SM FEW030 FEW045 BKN250 29/23 A2994 RMK AO2 SLP140 T02940233';
  final metar = Metar(code);
}
```

Because of the codification of the reports doesn't have the month and year, you can give it to the instance
as shown in the following example:

```dart
// ... snip ....

  final metar = Metar(code, year: 2022, month: 3);

// ... snip ...
```

If you do not give this arguments, `Metar` object is instantiated with the current year and month.

By default the parser do not raise any error when find a group that can't be parsed. For anulate this
behavior provide the argument `truncate`, so it can throws a `ParserError` showing the unparsed groups
as follows:

```dart
// ... snip ...

  final code_with_bad_group =
        'KMIA 130053Z 00000KT 10SM FEWT030 FEW045 BKN250 29/23 A2994 RMK AO2 SLP140 T02940233';
  final metar = Metar(code_with_bad_group, truncate: True);

// ... snip ...

// Throws the following error
// ParserError: failed while processing FEWT030 from: KMIA 130053Z 00000KT 10SM FEWT030 FEW045 BKN250 29/23
// A2994 RMK AO2 SLP140 T02940233
```

Now that you have a `Metar` object, you can extract all the relevant information.

### Raw Code

Get the raw code as its received in the instance. Type `String`.

```dart
// ... snip ...

  print(metar.rawCode)

// ... snip ...


// prints...
// KMIA 130053Z 00000KT 10SM FEWT030 FEW045 BKN250 29/23 A2994 RMK AO2 SLP140 T02940233
```

### Sections

Get the `Metar` separated in its sections. Type `List<String>`.

```dart
// ... snip ...

  print(metar.sections)

// ... snip ...

// prints...
// [KMIA 130053Z 00000KT 10SM FEW030 FEW045 BKN250 29/23 A2994, , RMK AO2 SLP140 T02940233]
```

Where the first element is the body, the second is the trend and the last one is the remark.

### Unparsed Groups

Get the unparsed groups of the report. Type `List<String>`.

```dart
// ... snip ...

  final code_with_bad_group =
        'KMIA 130053Z 00000KT 10SM FEWT030 FEW045 BKN250 29/23 A2994 RMK AO2 SLP140 T02940233';
  final metar = Metar(code_with_bad_group);
  print(metar.unparsedGroups);

// ... snip ...

// prints...
// [FEWT030]
```

As you can see, the parser is very strict. This is because we can't take in count every case of bad 
digitation in land station where the work is completely manual. Human errors are inevitable. Try to
parse bad groups may incur us to have bad data to make calculations, we don't want this in our
climatology.

## Methods asMap() and toJson()

Starting from here, all the properties contains this list of methods:

* asMap() -> `Map<String, Object>`: Returns the object data as a map like `Map<String, Object>`. In some
  cases the `Object` type is replaced by a especific type.
* toJson() -> `String`: Returns the object data as a string in JSON format.

Of course, the `Metar` object also containes this same methods.

### The `GroupList` object

Some groups may appear several times in the `METAR` report, but representing different data.
For example, the weather or the cloud layers. So, we can group these in one object to manipulate
them more easily.

The `GroupList` object is a class that contains other objects of the same type like a list.
You can iterate using the `items` field in a `for` loop:

```dart
for (var group in groupListInstance.items) {
  print(group.some_property);
}

// Can be indexed too
final group = group_list_instance[0];
print(group.some_property);
```

We will use the `GroupList` object for the first time in [Runway Ranges](#runway-ranges)
section.

Fields:
* codes `List<String>`: The codes of every group found in report as a `List<String>`.
* items `List<T>`: The groups found in report.

### Type

Get the type of the report. Type `ReportType`.

Fields:
* code `String`: The code present in the `Metar`. Defaults to `METAR`.
* type `String`: The report type name, e.g. `Meteorological Aerodrome Report`.

```dart
// ... snip ...

  print(metar.type.code);
  print(metar.type.type);

// ... snip ...

// prints...
// METAR
// Meteorological Aerodrome Report
```

### Station

Get the station information of the report. Type `Station`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `KJFK`.
* name `String?`: The name of the land station.
* country `String?`: The country to which the land station belongs.
* elevation `String?`: The elevation in meters above sea level of the station.
* longitude `String?`: The longitude of the station.
* latitude `String?`: The latitude of the station.
* icao `String?`: The ICAO code of the station.
* iata `String?`: The IATA code of the station.
* synop `String?`: The SYNOP code of the station.

```dart
// ... snip ...

  print('Code: ${metar.station.code}');
  print('Name: ${metar.station.name}');
  print('Country: ${metar.station.country}');
  print('Elevation: ${metar.station.elevation}');
  print('Longitude: ${metar.station.longitude}');
  print('Latitude: ${metar.station.latitude}');
  print('ICAO: ${metar.station.icao}');
  print('IATA: ${metar.station.iata}');
  print('SYNOP: ${metar.station.synop}');

// ... snip ...

// prints...
// Code: KJFK
// Name: NY NYC/JFK ARPT
// Country: United States of America (the)
// Elevation: 9
// Longitude: 073.46W
// Latitude: 40.38N
// ICAO: KJFK
// IATA: JFK
// SYNOP: 74486
```

### Time

Get the date and time of the report. Type `Time`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `130053Z`.
* time `DateTime`: The time of the report as a `DateTime` object.
* year `int`: The year of the report. Defaults to current year if not provided in the
  `Metar` instance.
* month `int`: The month of the report. Defaults to current month if not provided in the
  `Metar` instance.
* day `int`: The day of the report.
* hour `int`: The hour of the report.
* minute `int`: The minute of the report.

```dart
// ... snip ...

  print(metar.time.code);
  print(metar.time.day);
  print(metar.time.hour);
  print(metar.time.minute);

// ... snip ...

// prints...
// 130053Z
// 13
// 0
// 53
```

### Modifier

Get the modifier description of the report. Type `Modifier`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `AUTO`.
* description `String?`: The description of the modifier code.

Supported codes are:
* `COR`: Correction
* `CORR`: Correction
* `AMD`: Amendment
* `NIL`: Missing report
* `AUTO`: Automatic report
* `TEST`: Testing report
* `FINO`: Missing report

```dart
// ... snip ...

  print(metar.modifier.code);
  print(metar.modifier.description);

// ... snip ...

// prints...
// COR
// Correction
```

### Wind

Get the wind data of the report. Type `MetarWind`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `25005KT`.
* cardinalDirection `String?`: The cardinal direction associated to the wind direction,
  e.g. "NW" (north west).
* variable `bool`: Represents if the wind direction is variable (VRB).
* directionInDegrees `double?`: The wind direction in degrees.
* directionInRadians `double?`: The wind direction in radians.
* directionInGradians `double?`: The wind direction in gradians.
* speedInKnot `double?`: The wind speed in knot.
* speedInMps `double?`: The wind speed in meters per second.
* speedInKph `double?`: The wind speed in kilometers per hour.
* speedInMiph `double?`: The wind speed in miles per hour.
* gustInKnot `double?`: The wind gust in knot.
* gustInMps `double?`: The wind gust in meters per second.
* gustInKph `double?`: The wind gust in kilometers per hour.
* gustInMiph `double?`: The wind gust in miles per hour.

```dart
// ... snip ...

  print(metar.wind.code);
  print(metar.wind.cardinalDirection);
  print(metar.wind.variable);
  print(metar.wind.directionInDegrees);
  print(metar.wind.speedInMiph);
  print(metar.wind.gustInKph);

// ... snip ...

// prints...
// 25005KT
// WSW
// False
// 250.0
// 5.7539
// None
```

### Wind Variation

Get the wind variation directions from the report. Type `MetarWindVariation`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `250V140`.
* fromCardinalDirection `String?`: The `from` cardinal direction, e.g. "NW" (north west).
* fromInDegrees `double?`: The `from` direction in degrees.
* fromInRadians `double?`: The `from` direction in radians.
* fromInGradians `double?`: The `from` direction in gradians.
* toCardinalDirection `String?`: The `to` cardinal direction, e.g. "SE" (south est).
* toInDegrees `double?`: The `to` direction in degrees.
* toInRadians `double?`: The `to` direction in radians.
* toInGradians `double?`: The `to` direction in gradians.

```dart
// ... snip ...

  print(metar.windVariation.code);
  print(metar.windVariation.fromCardinalDirection);
  print(metar.windVariation.fromInDegrees);
  print(metar.windVariation.toCardinalDirection);
  print(metar.windVariation.toInDegrees);

// ... snip ...

// prints...
// 250V140
// WSW
// 250.0
// SE
// 140.0
```

### Prevailing Visibility

Get the prevailing visibility of the report. Type `MetarPrevailingVisibility`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `9999`.
* inMeters `double?`: The prevailing visibility in meters.
* inKilometers `double?`: The prevailing visibility in kilometers.
* inFeet `double?`: The prevailing visibility in feet.
* inSeaMiles `double?`: The prevailing visibility in sea miles.
* cardinalDirection `String?`: The cardinal direction associated to the visibility,
  e.g. "NW" (north west).
* directionInDegrees `double?`: The direction of the prevailing visibility in degrees.
* directionInRadians `double?`: The direction of the prevailing visibility in radians.
* directionInGradians `double?`: The direction of the prevailing visibility in gradians.
* cavok `bool`: True if CAVOK, False if not.

```dart
// ... snip ...

  print(metar.prevailingVisibility.code);
  print(metar.prevailingVisibility.inMeters);
  print(metar.prevailingVisibility.cavok);

// ... snip ...

// prints...
// 10SM
// 18520.0
// False
```

### Minimum Visibility

Get the minimum visibility of the report. Type `MetarMinimumVisibility`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `3000W`.
* inMeters `double?`: The minimum visibility in meters.
* inKilometers `double?`: The minimum visibility in kilometers.
* inFeet `double?`: The minimum visibility in feet.
* inSeaMiles `double?`: The minimum visibility in sea miles.
* cardinalDirection `String?`: The cardinal direction associated to the minimum visibility,
  e.g. "NW" (north west).
* directionInDegrees `double?`: The direction of the minimum visibility in degrees.
* directionInRadians `double?`: The direction of the minimum visibility in radians.
* directionInGradians `double?`: The direction of the minimum visibility in gradians.

```dart
// ... snip ...

  // New METAR code for this example
  final code = 'MROC 160700Z 09003KT 3000 1000SW BR SCT005 BKN015 19/19 A3007 NOSIG';
  final metar = Metar(code);

  print(metar.minimumVisibility.code);
  print(metar.minimumVisibility.inMeters);
  print(metar.minimumVisibility.cardinalDirection);
  print(metar.minimumVisibility.directionInDegrees);

// ... snip ...

// prints...
// 1000SW
// 1000.0
// SW
// 225.0
```

### Runway Ranges

Get the runway ranges data of the METAR if provided. Type `GroupList<MetarRunwayRange>`.

#### Runway Range

The individual runway range data by group provided in the METAR. Type `MetarRunwayRange`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `R07L/M0150V0600U`.
* name `String?`: The runway name.
* lowRange `String?`: The runway low range as a string.
* lowInMeters `double?`: The runway low range in meters.
* lowInKilometers `double?`: The runway low range in kilometers.
* lowInFeet `double?`: The runway low range in feet.
* lowInSeaMiles `double?`: The runway low range in sea miles.
* highRange `String?`: The runway high range as a string.
* highInMeters `double?`: The runway high range in meters.
* highInKilometers `double?`: The runway high range in kilometers.
* highInFeet `double?`: The runway high range in feet.
* highInSeaMiles `double?`: The runway high range in sea miles.
* trend `String?`: The trend of the runway range.

```dart
// ... snip ...

  // New METAR code for this example
  final code = 'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U TSRA FEW020 20/13 Q1014 NOSIG';
  final metar = Metar(code);

  print(metar.runwayRanges.codes);

  for (var runwayRange in metar.runwayRanges.items) {
    print(runwayRange.name);
    print(runwayRange.low_range);
    print(runwayRange.high_in_sea_miles);
  }

// ... snip ...

// prints...
// [R07L/M0150V0600U]
// 07 left
// below of 150.0 m
// 0.3239740820734341
```

### Weathers

Get the weathers data of the METAR if provided. Type `GroupList<MetarWeather>`.

#### Weather

The individual weather data by group provided in the METAR. Type `MetarWeather`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `+TSRA`.
* intensity `String?`: The intensity translation of the weather, e.g. `+ -> heavy`.
* description `String?`: The description translation of the weather, e.g. `TS -> thunder storm`.
* precipitation `String?`: The precipitation translation of the weather, e.g. `RA -> rain`.
* obscuration `String?`: The obscuration translation of the weather, e.g. `BR -> mist`.
* other `String?`: The other translation of the weather, e.g. `FC -> funnel cloud`.

```dart
// ... snip ...

  // New METAR code for this example
  final metarCode =
      'METAR BIBD 191100Z 03002KT 5000 +RA BR VCTS SCT008CB OVC020 04/03 Q1013';
  final metar = Metar(metarCode);

  var code = 'code'.padLeft(13);
  var intensity = 'intensity'.padLeft(13);
  var description = 'description'.padLeft(13);
  var precipitation = 'precipitation'.padLeft(13);
  var obscuration = 'obscuration'.padLeft(13);
  var other = 'other'.padLeft(13);

  for (var weather in metar.weathers.items) {
    code += '${weather.code}'.padLeft(14);
    intensity += '${weather.intensity}'.padLeft(14);
    description += '${weather.description}'.padLeft(14);
    precipitation += '${weather.precipitation}'.padLeft(14);
    obscuration += '${weather.obscuration}'.padLeft(14);
    other += '${weather.other}'.padLeft(14);
  }

  print(code);
  print(intensity);
  print(description);
  print(precipitation);
  print(obscuration);
  print(other);

// ... snip ...

// prints...
//          code           +RA            BR          VCTS
//     intensity         heavy          null        nearby
//   description          null          null  thunderstorm
// precipitation          rain          null          null
//   obscuration          null          mist          null
//         other          null          null          null
```

### Clouds

Get the clouds data of the report. Type `CloudList` which extends `GroupList<Cloud>`.

Fields:
* ceiling `bool`: True if there is ceiling, False if not. If the cover of someone of the
  cloud layers is broken (BKN) or overcast (OVC) and its height is less than or equal to
  1500.0 feet, there is ceiling; there isn't otherwise.

#### Cloud

The individual cloud data by group provided in the report. Type `Cloud`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `SCT015CB`.
* cover `String?`: The cover translation of the cloud layer, e.g. `SCT -> scattered`.
* cloud_type `String?`: The type of cloud translation of the cloud layer, e.g. `CB -> cumulonimbus`.
* oktas `String`: The oktas amount of the cloud layer, e.g. `SCT -> 3-4`.
* height_in_meters `double?`: The height of the cloud base in meters.
* height_in_kilometers `double?`: The height of the cloud base in kilometers.
* height_in_sea_miles `double?`: The height of the cloud base in sea miles.
* height_in_feet `double?`: The height of the cloud base in feet.

```dart
// ... snip ...

  final metarCode =
      'METAR BIBD 191100Z 03002KT 5000 +RA BR VCTS FEW010CB SCT020 BKN120 04/03 Q1013';
  final metar = Metar(metarCode);

  print(metar.clouds.codes);
  print(metar.clouds.ceiling);

// ... snip ...

// prints...
// [FEW010CB, SCT020, BKN120]
// false

// ... snip ...

  var code = 'code'.padLeft(12);
  var cover = 'cover'.padLeft(12);
  var oktas = 'oktas'.padLeft(12);
  var cloudType = 'cloudType'.padLeft(12);
  var height = 'height (ft)'.padLeft(12);

  for (var cloud in metar.clouds.items) {
    code += '${cloud.code}'.padLeft(14);
    cover += '${cloud.cover}'.padLeft(14);
    oktas += '${cloud.oktas}'.padLeft(14);
    cloudType += '${cloud.cloudType}'.padLeft(14);
    height += '${"${cloud.heightInFeet!.toStringAsFixed(1)}"}'.padLeft(14);
  }

  print(code);
  print(cover);
  print(oktas);
  print(cloudType);
  print(height);

// ... snip ...

// prints...
//        code      FEW010CB        SCT020        BKN120
//       cover         a few     scattered        broken
//       oktas           1-2           3-4           5-7
//   cloudType  cumulonimbus          null          null
// height (ft)        1000.0        2000.0       12000.0
```

### Temperatures

Get the temperatures of the report. Type `MetarTemperatures`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `29/23`.
* temperature_in_celsius `double?`: The temperature in °Celsius.
* temperature_in_kelvin `double?`: The temperature in °Kelvin.
* temperature_in_fahrenheit `double?`: The temperature in °Fahrenheit.
* temperature_in_rankine `double?`: The temperature in Rankine.
* dewpoint_in_celsius `double?`: The dewpoint in °Celsius.
* dewpoint_in_kelvin `double?`: The dewpoint in °Kelvin.
* dewpoint_in_fahrenheit `double?`: The dewpoint in °Fahrenheit.
* dewpoint_in_rankine `double?`: The dewpoint in Rankine.

```dart
// ... snip ...

  print(metar.temperatures.temperature_in_celsius);
  print(metar.temperatures.temperature_in_fahrenheit);
  print(metar.temperatures.dewpoint_in_celsius);
  print(metar.temperatures.dewpoint_in_fahrenheit);

// ... snip ...

// prints...
// 29.0
// 84.2
// 23.0
// 73.4
```

### Pressure

Get the pressure of the report. Type `MetarPressure`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `A2994`.
* inAtm `double?`: The pressure in atmospheres.
* inBar `double?`: The pressure in bars.
* inMbar `double?`: The pressure in millibars.
* inHPa `double?`: The pressure in hecto pascals.
* inInHg `double?`: The pressure in mercury inches.
* value `double?`: The default stored value of the pressure in hecto pascals.

```dart
// ... snip ...

  print(metar.pressure.code);
  print(metar.pressure.inAtm);
  print(metar.pressure.inHPa);
  print(metar.pressure.inInHg);

// ... snip ...

// prints...
// A2994
// 1.000626
// 1013.884186
// 29.940000
```

### Recent Weather

Get the recent weather data of the report. Type `MetarRecentWeather`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `RERA`.
* description `String?`: The description translation of the recent weather, e.g. `TS -> thunder storm`.
* precipitation `String?`: The precipitation translation of the recent weather, e.g. `RA -> rain`.
* obscuration `String?`: The obscuration translation of the recent weather, e.g. `FG -> fog`.
* other `String?`: The other translation of the recent weather, e.g. `FC -> funnel cloud`.

```dart
// ... snip ...

  // New METAR code for this example
  final metarCode =
      'METAR BIBD 191100Z 03002KT 9999 VCTS FEW010CB SCT020 BKN120 04/03 Q1013 RETSRA NOSIG';
  final metar = Metar(metarCode);

  print(metar.recentWeather.code);
  print(metar.recentWeather.description);
  print(metar.recentWeather.precipitation);
  print(metar.recentWeather.obscuration);
  print(metar.recentWeather.other);

// ... snip ...

// prints...
// RETSRA
// thunderstorm
// rain
// null
// null
```

### Windshears

Get the windshear data of the report. Type `MetarWindshearList` which
extends `GroupList<MetarWindshearRunway>`.

Fields:
* names `List<String>`: The names of runways with windshear reported.
* allRunways `bool`: True if all runways have windshear, False if not.

#### Windshear

The individual windshear data by group provided in the report. Type `MetarWindshearRunway`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `WS R07`.
* all `bool`: True if `ALL` is found in the group, False if not, e.g. `WS ALL RWY`.
* name `String?`: The name of the runway that has being reported with windshear.

```dart
// ... snip ...

  // New METAR code for this example
  final metarCode =
      'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07L WS R25C NOSIG';
  final metar = Metar(metarCode);

  print(metar.windshears.codes);
  print(metar.windshears.names);
  print(metar.windshears.allRunways);

// ... snip ...

// prints...
// [WS R07L, WS R25C]
// [07 left, 25 center]
// false

// ... snip ...

  var code = 'code'.padLeft(5);
  var all = 'all'.padLeft(5);
  var name = 'name'.padLeft(5);

  for (var ws in metar.windshears.items) {
    code += '${ws.code}'.padLeft(11);
    all += '${ws.all}'.padLeft(11);
    name += '${ws.name}'.padLeft(11);
  }

  print(code);
  print(all);
  print(name);

// ... snip ...

// prints...
// code    WS R07L    WS R25C
//  all      false      false
// name    07 left  25 center
```

### Sea State

Get the sea state data of the report. Type `MetarSeaState`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `W20/S5`.
* state `String?`: The sea state if provided.
* temperatureInCelsius `double?`: The temperature of the sea in Celsius.
* temperatureInKelvin `double?`: The temperature of the sea in Kelvin.
* temperatureInFahrenheit `double?`: The temperature of the sea in Fahrenheit.
* temperatureInRankine `double?`: The temperature of the sea in Rankine.
* heightInMeters `double?`: The height of the significant wave in meters.
* heightInCentimeters `double?`: The height of the significant wave in centimeters.
* heightInDecimeters `double?`: The height of the significant wave in decimeters.
* heightInFeet `double?`: The height of the significant wave in feet.
* heightInInches `double?`: The height of the significant wave in inches.

```dart
// ... snip ...

// New METAR code for this example
  final metarCode =
      'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA W20/S5';
  final metar = Metar(metarCode);

  print(metar.seaState.code);
  print(metar.seaState.state);
  print(metar.seaState.temperatureInCelsius);
  print(metar.seaState.temperatureInKelvin);
  print(metar.seaState.temperatureInFahrenheit);
  print(metar.seaState.heightInInches);

// ... snip ...

// prints...
// W20/S5
// rough
// 20.0
// 293.15
// 68.0
// null
```

### Runway State

Get the runway state data of the report. Type `MetarRunwayState`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `R10R/527650`.
* name `String?`: The name of the runway that has being reported.
* deposits `String?`: The deposits type on the runway.
* contamination `String?`: The contamination quantity of the deposits.
* depositsDepth `String?`: The deposits depth.
* surfaceFriction `String?`: The surface friction index of the runway.
* snoclo `bool`: True: aerodrome is closed due to extreme deposit of snow.
  False: aerodrome is open.
* clrd `String?`: Get if contamination have ceased to exists in some runway.

```dart
// ... snip ...

  // New METAR code for this example
  final metarCode =
      'METAR PANC 210353Z 01006KT 10SM FEW045 BKN070 OVC100 M05/M17 A2965 R10R/527650';
  final metar = Metar(metarCode);

  print('${"Code:".padLeft(18)} ${metar.runwayState.code}');
  print('${"Name:".padLeft(18)} ${metar.runwayState.name}');
  print('${"Deposits:".padLeft(18)} ${metar.runwayState.deposits}');
  print('${"Deposits depth:".padLeft(18)} ${metar.runwayState.depositsDepth}');
  print('${"Contamination:".padLeft(18)} ${metar.runwayState.contamination}');
  print(
      '${"Surface friction:".padLeft(18)} ${metar.runwayState.surfaceFriction}');
  print('${"SNOCLO:".padLeft(18)} ${metar.runwayState.snoclo}');
  print('${"CLRD:".padLeft(18)} ${metar.runwayState.clrd}');

// ... snip ...

// prints...
//             Code: R10R/527650
//             Name: 10 right
//         Deposits: wet snow
//   Deposits depth: 76 mm
//    Contamination: 11%-25% of runway
// Surface friction: 0.50
//           SNOCLO: false
//             CLRD: null
```

## Weather Trend

Get the weather trends of the report if provided. Type `MetarWeatherTrends`
which extends `GroupList<ChangePeriods>`.

The weather trends are change periods forecasted for the next two hours from the
report. May be one or two, and they can have wind, prevailing visibility, weather and
clouds, but not all are strictly required. All of this fields are the same
as in the [Metar](#metar) object, so, you can access them as in the previous examples
for every change period.

### Change Period

The change period forecasted for the next two hours. Type `ChangePeriod`.

Fields:
* code `String?`: The code present in the `Metar`, e.g. `BECMG 25005KT 5000 RA`.
* wind `MetarWind`: The wind forecasted, see [Wind](#wind) for more details.
* prevailing_visibility `MetarPrevailingVisibility`: The prevailing visibility
  forecasted, see [Prevailing Visibility](#prevailing-visibility) for more details.
* weathers `GroupList[MetarWeather]`: the weather forecasted, see [Weathers](#weathers)
  for more details.
* clouds `CloudList`: the clouds forecasted, see [Clouds](#clouds) for more details.

```dart
// ... snip ...

  // New METAR code for this example
  final metarCode =
      'METAR BIAR 190800Z 20015KT 9999 FEW049 BKN056 10/03 Q1016 BECMG 5000 RA SCT010 BKN015';
  final metar = Metar(metarCode);
  final weatherTrends = metar.weatherTrends;

  print(weatherTrends.codes);

// ... snip ...

// prints...
// [BECMG 5000 RA SCT010 BKN015]

// ... snip ...

  for (var changePeriod in weatherTrends.items) {
    print("Wind's code: ${changePeriod.wind.code}");
    print(
        "Prevailing visibility's code: ${changePeriod.prevailingVisibility.code}");
    print("Weather's codes: ${changePeriod.weathers.codes}");
    print("Clouds' codes: ${changePeriod.clouds.codes}");
  }

// ... snip ...

// prints...
// Wind's code: null
// Prevailing visibility's code: 5000
// Weather's codes: [RA]
// Clouds' codes: [SCT010, BKN015]
```

## Remark

There is no support for remark at this time, but we hope add it soon. Sorry.

# Taf

All features of the `Taf` report are represented as objects in the package as like the `Metar`.
So, in the same way as the `Metar`, the `Taf` object can be intantiated as follows: 

```dart
import 'package:metar_dart/metar_dart.dart';

void main() {
  final code = (
    '''KATL 251958Z 2520/2624 27009KT P6SM VCSH FEW040 BKN120
    FM260100 28005KT P6SM SCT060 SCT120
    FM260800 32004KT P6SM FEW150
    FM261500 32011G18KT P6SM SKC''';
  )
  final taf = Taf(code);
}
```

Because of the codification of the reports doesn't have the month and year, you can give it to the instance
as shown in the following example:

```dart
// ... snip ...

  final taf = Taf(code, year=2022, month=3);

// ... snip ...
```

If you do not give this arguments, `Taf` object is instantiated with the current year and month.

By default the parser do not raise any error when find a group that can't be parsed. For anulate this
behavior provide the argument `truncate`, so it can raises a `ParserError` showing the unparsed groups
as follows:

```dart
// ... snip ...

  final code_with_bad_groups =
      '''KATL 251958Z 2520/2624 27009KT P6SM VCHS FEW040 BKN120
    FM260100 28005KT P6SM SCT060 SCT120
    FM260800 32004KT P6SM FEW150
    FM261500 32011G18KT P6SM SKC''';
  final taf = Taf(code_with_bad_groups, truncate: true);

// ... snip ...

// Raises the following error
// ParserError: failed while processing VCHS SKC from: KATL 251958Z 2520/2624 27009KT P6SM VCHS
// FEW040 BKN120 FM260100 28005KT P6SM SCT060 SCT120 FM260800 32004KT P6SM FEW150 FM261500
// 32011G18KT P6SM SKC
```

As you can see, the parser is very strict. This is because we can't take in count every case of bad 
digitation in land station where the work is completely manual. Human errors are inevitable. Try to
parse bad groups may incur us to have bad data to make TAF verification, we don't want this in our
analysis.

The `Taf` and `Metar` objects share some of its properties and methods. So, the use of these fields
is the same.

Fields:
* rawCode `String`: See [Raw Code](#raw-code) for more details.
* sections `List<String>`: See [Sections](#sections) for more details. In the case of `Taf`, the
  `sections` field returns a list of two elements, the first one is the body and the second one
  the change periods if provided.
* unparsedGroups `List<String>`: See [Unparsed Groups](#unparsed-groups) for more details.
* asMap() and toJson(): See [Methods asMap() and toJson()](#methods-asmap-and-tojson) for
  more details.
* type `ReportType`: See [Type](#type) for more details.
* station `Station`: See [Station](#station) for more details.
* time `Time`: See [Time](#time) for more details.
* modifier `Modifier`: See [Modifier](#modifier) for more details.
* wind `MetarWind`: See [Wind](#wind) for more details.
* prevailingVisibility `MetarPrevailingVisibility`: See
  [Prevailing Visibility](#prevailing-visibility) for more details.
* weathers `GroupList<MetarWeather>`: See [Weathers](#weathers) for more details.
* clouds `CloudList`: See [Clouds](#clouds) for more details.

## Missing

Get the missing information of the report if provided. Type `Missing`.

Fields:
* code `String?`: The code present in the `Taf`, which is `NIL`.
* description `String?`: The description of the missing code.
* isMissing `bool`: True if `NIL` group is found, False if not.

```dart
// ... snip ...

  // New TAF code for this example
  final code = 'TAF SKBO 261630Z NIL';
  final taf = Taf(code);

  print(taf.missing.code);
  print(taf.missing.description);
  print(taf.missing.isMissing);

// ... snip ...

// prints...
// NIL
// Missing report
// true
```