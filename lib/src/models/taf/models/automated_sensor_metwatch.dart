part of models;

/// Basic structure for missing TAF.
class AutomatedSensorMetwatch extends Modifier {
  DateTime? from, to;

  AutomatedSensorMetwatch(String? code, RegExpMatch match) : super(null) {
    _code = code;

    final fd = match.namedGroup('df')!;
    final fh = match.namedGroup('hf')!;
    final td = match.namedGroup('dt')!;
    final th = match.namedGroup('ht')!;

    final n = DateTime.now().toUtc();
    from = DateTime(n.year, n.month, int.parse(fd), int.parse(fh), 0, 0);
    to = DateTime(n.year, n.month, int.parse(td), int.parse(th), 0, 0);
  }

  @override
  String toString() {
    return 'Automated Sensor Metwatch from ${from!.hour}:00 UTC on the ${from!.day}${daySuffix(from!.day)} to ${to!.hour}:00 UTC on the ${to!.day}${daySuffix(to!.day)}';
  }
}
