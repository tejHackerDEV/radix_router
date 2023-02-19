import 'package:radix_router/src/extensions/string.dart';

import 'enum/node_type.dart';

class Node<T> {
  final String pathSection;
  T? value;
  final Map<String, Node<T>> staticChildren = {};
  final List<Node<T>> parametricChildren = [];
  Node<T>? wildcardChild;
  final Node<T>? parentNode;

  Node({
    required this.pathSection,
    this.value,
    this.wildcardChild,
    this.parentNode,
  });

  NodeType get type => pathSection.nodeType;

  String get parameterName {
    if (type != NodeType.parametric) {
      throw AssertionError('$this is not a parametric path');
    }
    return pathSection.substring(1, pathSection.length - 1);
  }

  StringBuffer _writeChildrenBufferData(
    StringBuffer? stringBuffer, {
    required String title,
    required Iterable<Node<T>> children,
    required bool shouldAddTrailingComma,
  }) {
    stringBuffer ??= StringBuffer();
    stringBuffer.write('"$title": ');
    if (children.isEmpty) {
      stringBuffer.write(null);
    } else {
      stringBuffer.write('[');
      for (int i = 0; i < children.length; ++i) {
        final childNode = children.elementAt(i);
        stringBuffer.write(childNode);
        if (i != children.length - 1) {
          stringBuffer.write(', ');
        }
      }
      stringBuffer.write(']');
    }
    if (shouldAddTrailingComma) {
      stringBuffer.write(',');
    }
    return stringBuffer;
  }

  @override
  String toString() {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('{"$pathSection": {');
    stringBuffer.write('"value": ${value is! num ? '"$value"' : value}, ');
    _writeChildrenBufferData(
      stringBuffer,
      title: 'staticChildren',
      children: staticChildren.values,
      shouldAddTrailingComma: true,
    );
    _writeChildrenBufferData(
      stringBuffer,
      title: 'parametricChildren',
      children: parametricChildren,
      shouldAddTrailingComma: true,
    );
    stringBuffer.write(
      '"wildcardChild": $wildcardChild, "parentNode": ${parentNode == null ? null : '"${parentNode!.pathSection}"'}',
    );
    stringBuffer.write('}}');
    return stringBuffer.toString();
  }
}
