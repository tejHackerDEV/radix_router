import '../enum/node_type.dart';

extension StringExtension on String {
  NodeType get nodeType {
    if (this[0] == '{' && this[length - 1] == '}') {
      return NodeType.parametric;
    }
    return NodeType.static;
  }
}
