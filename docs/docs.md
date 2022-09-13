# Metar-Dart Documentation

## Introduction

Metar-Dart is a package for Dart programming language designed for parsing aerinautical and
meteorological information from land stations (airports and meteorological offices).

It is strongly influenced by [Python-Metar][python-metar] package, authored by [Tom Pollard][tom-pollard]. 
But, this package is designed to go further in parsing more than METAR reports.

[python-metar]: https://github.com/python-metar/python-metar
[tom-pollard]: https://github.com/tomp

Going through this documentation will take you about an hour, and by the end of it you will have pretty much 
learned the entire API provided to interact with the objects ands its methods and properties.

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

</td>
<td width=33% valign=top>
</td>
<td valign=top>
</td>
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
        'KMIA 130053Z 00000KT 10SM FEW030 FEW045 BKN250 29/23 A2994 RMK AO2 SLP140 T02940233';
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

Get the unparsed groups of the report. Type `List[str]`.

```dart
// ... snip ...

  final code_with_bad_group =
        'KMIA 130053Z 00000KT 10SM FEWT030 FEW045 BKN250 29/23 A2994 RMK AO2 SLP140 T02940233';
  final metar = Metar(code_with_bad_group);
  print(metar.unparsedGroups);

// ... snip ...

// prints...
// ['FEWT030']
```

As you can see, the parser is very strict. This is because we can't take in count every case of bad 
digitation in land station where the work is completely manual. Human errors are inevitable. Try to
parse bad groups may incur us to have bad data to make calculations, we don't want this in our
climatology.