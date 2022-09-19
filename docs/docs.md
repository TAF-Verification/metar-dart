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
    - [Type](#type)
    - [Station](#station)
    - [Time](#time)
    - [Modifier](#modifier)
    - [Wind](#wind)
    - [Wind Variation](#wind-variation)
    - [Prevailing Visibility](#prevailing-visibility)
    - [Minimum Visibility](#minimum-visibility)

</td>
<!-- <td width=33% valign=top>
</td>
<td valign=top>
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

Starting from here, all the properties contains this list of methods:

* asMap() -> `Map<String, Object>`: Returns the object data as a map like `Map<String, Object>`. In some
  cases the `Object` type is replaced by a especific type.
* toJson() -> `String`: Returns the object data as a string in JSON format.

Of course, the `Metar` object also containes this same methods.

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