# Metar-Dart

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![codecov][coverage-shield]][coverage-url]
[![MIT License][license-shield]][license-url]

[coverage-shield]: https://codecov.io/gh/TAF-Verification/metar-dart/branch/main/graph/badge.svg?token=3LFEI3SQ0W
[coverage-url]: https://codecov.io/gh/TAF-Verification/metar-dart
[contributors-shield]: https://img.shields.io/github/contributors/TAF-Verification/metar-dart.svg
[contributors-url]: https://github.com/TAF-Verification/metar-dart/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/TAF-Verification/metar-dart.svg
[forks-url]: https://github.com/TAF-Verification/metar-dart/network/members
[stars-shield]: https://img.shields.io/github/stars/TAF-Verification/metar-dart.svg
[stars-url]: https://github.com/TAF-Verification/metar-dart/stargazers
[issues-shield]: https://img.shields.io/github/issues/TAF-Verification/metar-dart.svg
[issues-url]: https://github.com/TAF-Verification/metar-dart/issues
[license-shield]: https://img.shields.io/github/license/TAF-Verification/metar-dart.svg
[license-url]: https://github.com/TAF-Verification/metar-dart/blob/master/LICENSE

Inspired from python-metar, a library writed in Python language to parse Meteorological Aviation Weather Reports (METAR and SPECI).

This library will parse meteorological information of aeronautical land stations.
Supported report types:
* METAR
* SPECI
* TAF

## Current METAR reports

The current report for a station is available at the URL

```
http://tgftp.nws.noaa.gov/data/observations/metar/stations/<station>.TXT
```

where `station` is the ICAO station code of the airport. This is a four-letter code. For all stations at any cycle (i.e., hour) in the last  hours the reports are available at the URL

```
http://tgftp.nws.noaa.gov/data/observations/metar/cycles/<cycle>Z.TXT
```

where `cycle` is the 2-digit cycle number (`00` to `23`).

## Usage

A simple usage example:

```dart
import 'package:metar_dart/metar_dart.dart';

main() {
  String code = 'METAR MROC 071200Z 10018KT 3000 R07/P2000N BR VV003 17/09 A2994 RESHRA NOSIG';
  final metar = Metar(code);

  // Get the type of the report
  print('${metar.type}'); // Meteorological Aerodrome Report

  // Get the wind speed in knots and direction in degrees
  print('${metar.wind.speedInKnot} kt');       // 18.0 kt 
  print('${metar.wind.directionInDegrees}°');  // 100.0°

  // Get the pressure in hecto pascals
  print('${metar.pressure.inHPa} hPa');  // 1014.0 hPa

  // Get the temperature in Celsius
  print('${metar.temperatures.temperatureInCelsius}°C');  // 17.0°C
}
```

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create.
Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request.
You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)

## Roadmap

- [x] Add parsers for TAF and METAR reports
- [ ] Add functions to verificate the TAF with the observations
- [ ] Add a CLI API to interact with the verification functions
- [ ] Add parser for SYNOPTIC reports
- [ ] Add functions to verificate reports with rules of [Annex 3][annex3]
- [ ] Multi-language Support
    - [ ] Portuguese
    - [ ] Spanish

[annex3]: https://www.icao.int/airnavigation/IMP/Documents/Annex%203%20-%2075.pdf

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/TAF-Verification/metar-dart/issues

## Current Sources

The most recent version of this package is always available via git, only run the following
command on your terminal:

```
git clone https://github.com/TAF-Verification/metar-dart
```

## Authors

The `python-metar` library was originaly authored by [Tom Pollard][TomPollard] in january 2005. This package `metar-dart` for Dart Language is inspired from his work in 2020 by [Diego Garro][DiegoGarro].

[TomPollard]: https://github.com/tomp
[DiegoGarro]: https://github.com/diego-garro

## Versioning

This project uses [Cider][cider] tool for versioning, so, if you fork this repository remember run
the following command in your terminal to activate it

[cider]: https://pub.dev/packages/cider

```
pub global activate cider
```

## License

Distributed under the MIT License. See `LICENSE` for more information.