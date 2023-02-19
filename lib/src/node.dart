class Node<T> {
  final String pathSection;
  T? value;
  final Map<String, Node<T>> children = {};
  final Node<T>? parentNode;

  Node({
    required this.pathSection,
    this.value,
    this.parentNode,
  });

  @override
  String toString() {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('{"$pathSection": {');
    stringBuffer.write('"value": ${value is! num ? '"$value"' : value}, ');
    stringBuffer.write('"children": ');
    if (children.isEmpty) {
      stringBuffer.write(null);
    } else {
      stringBuffer.write('[');
      final childrenEntry = children.entries;
      for (int i = 0; i < childrenEntry.length; ++i) {
        final childEntry = childrenEntry.elementAt(i);
        stringBuffer.write(childEntry.value);
        if (i != childrenEntry.length - 1) {
          stringBuffer.write(', ');
        }
      }
      stringBuffer.write(']');
    }
    stringBuffer.write('}}');
    return stringBuffer.toString();
  }
}
