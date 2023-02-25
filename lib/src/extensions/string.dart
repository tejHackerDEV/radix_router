import '../enum/node_type.dart';
import '../enum/parametric_node_type.dart';

extension StringExtension on String {
  NodeType get nodeType {
    if (this == '*') {
      return NodeType.wildcard;
    }
    if (this[0] == '{' && this[length - 1] == '}') {
      return NodeType.parametric;
    }
    return NodeType.static;
  }

  ParametricNodeType get parametricNodeType {
    if (nodeType != NodeType.parametric) {
      throw AssertionError('$this is not a parametric path');
    }
    if (!contains(':')) {
      return ParametricNodeType.nonRegExp;
    }
    return ParametricNodeType.regExp;
  }
}
