import 'dart:convert';

import 'package:samba_helpers/samba_helpers.dart';

import '../decoded_path.dart';
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

  /// An modified version of original [Uri.splitQueryString] where
  /// the original function will return [Map<String, String>] but
  /// this modified version of ours will return [Map<String, dynamic>]
  /// where [dynamic] value can be a [String] or [List<String>]
  Map<String, dynamic> extractQueryParameters({
    required Encoding encoding,
  }) {
    // first check if the string is a full path or not,
    // by looking for the index of '?', because queryParameters stars with '?'
    int index = indexOf('?');
    if (index == -1) {
      // '?' didn't found in the string, so treat the complete string
      // from starting as a queryParameters
      index = 0;
    }
    return substring(index).split("&").fold({}, (map, element) {
      int index = element.indexOf("=");
      if (index == -1) {
        if (element != "") {
          map[Uri.decodeQueryComponent(element, encoding: encoding)] = "";
        }
      } else if (index != 0) {
        final key = Uri.decodeQueryComponent(
          element.substring(0, index),
          encoding: encoding,
        );
        final value = Uri.decodeQueryComponent(
          element.substring(index + 1),
          encoding: encoding,
        );
        map.addOrUpdateValue(key: key, value: value);
      }
      return map;
    });
  }

  /// Decode the path into pathSections as well as queryString.
  DecodedPath get decodePath {
    final pathSections = <String>[];
    int startIndex = 0;
    int queryStringIndex = -1;
    for (int i = 0; i < length; ++i) {
      if (this[i] == '/') {
        // '/' detected, meaning next pathSection is going to begin,
        // so add previous one as a pathSection, if its not empty.
        // & continue iterations
        final pathSection = substring(startIndex, i).trim();
        if (pathSection.isNotEmpty) {
          pathSections.add(pathSection);
        }
        startIndex = i + 1;
        continue;
      }
      if (this[i] == '?') {
        // '?' detected, meaning pathSections got completed
        // so add previous as a pathSection, if its not empty.
        //
        // Also reset the startIndex & insert the remaining as queryString
        final pathSection = substring(startIndex, i).trim();
        if (pathSection.isNotEmpty) {
          pathSections.add(pathSection);
        }
        startIndex = -1;
        queryStringIndex = i + 1;
        break;
      }
    }
    if (startIndex != -1) {
      // startIndex is not reset, so there is one last pathSection left
      // add it to the pathSections, only if its not empty string
      // & reset the startIndex.
      final pathSection = substring(startIndex).trim();
      if (pathSection.isNotEmpty) {
        pathSections.add(pathSection);
      }
      startIndex = -1;
    }
    return DecodedPath(
      pathSections,
      queryStringIndex == -1 ? null : substring(queryStringIndex),
    );
  }
}
