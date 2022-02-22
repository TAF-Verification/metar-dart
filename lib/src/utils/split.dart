part of utils;

/// Add space to the left of word.
String _addSpaceLeft(String word) {
  return ' ' + word;
}

/// Add space to the right of word.
String _addSpaceRight(String word) {
  return word + ' ';
}

/// Add space to the left and right of words.
String _addSpaceBoth(String word) {
  word = _addSpaceLeft(word);
  return _addSpaceRight(word);
}

/// Split the `sentence` given by the list of `words` without
/// lost that words.
///
/// Args:
///     sentence (String): the sentence to split.
///     keywords (List<String>): the list of keywords where the sentence will be splitted.
///     count (int, optional): Number of splits of every coincidence. Defaults to 0.
///     space (String, optional): take spaces in count to the left or right of every word.
///       Defaults to ''. Options: `left`, `right`, `both`
///
/// Returns:
///     List<String>: the list of sentence splitted from the original.
List<String> splitSentence(String sentence, List<String> keywords,
    {bool all = false, String space = ''}) {
  for (var word in keywords) {
    switch (space) {
      case 'left':
        word = _addSpaceLeft(word);
        break;
      case 'right':
        word = _addSpaceRight(word);
        break;
      case 'both':
        word = _addSpaceBoth(word);
        break;
      default:
        break;
    }

    final replacement = '|' + word.trimLeft();
    if (all) {
      sentence = sentence.replaceAll(word, replacement);
    } else {
      sentence = sentence.replaceFirst(word, replacement);
    }
  }

  return sentence.split('|');
}
