part of models;

class GroupHandler {
  final RegExp regexp;
  final void Function(String) handler;

  GroupHandler(this.regexp, this.handler);
}
