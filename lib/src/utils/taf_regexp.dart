part of utils;

class TafRegExp {
  static final RegExp AMD_COR = RegExp(r'^(?<mod>COR|AMD)$');

  static final RegExp NIL = RegExp(r'^NIL$');

  static final RegExp VALID = RegExp(r'^(?<fmday>0[1-9]|[12][0-9]|3[01])'
      r'(?<fmhour>[0-1]\d|2[0-3])/'
      r'(?<tlday>0[1-9]|[12][0-9]|3[01])'
      r'(?<tlhour>[0-1]\d|2[0-4])$');
}
