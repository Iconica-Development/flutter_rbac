class Permission {
  final String _root;
  final Permission? _parent;

  Permission._({
    required String root,
    required Permission? parent,
  })  : _parent = parent,
        _root = root;

  String get representation {
    var parent = _parent;
    if (parent != null) {
      return '${parent.representation}.$_root';
    }
    return _root;
  }

  Permission child(String value) {
    return Permission._(root: value, parent: this);
  }

  Permission resource<T extends Permissable>(T resource) {
    return child(resource.resourceName).child(resource.resourceId);
  }

  Permission any() {
    return child('*');
  }

  factory Permission.root(String root) {
    return Permission._(root: root, parent: null);
  }

  static Permission fromPermissable<T extends Permissable>(T resource) {
    return Permission.root(resource.resourceName).child(resource.resourceId);
  }

  static Permission _fromRepresentation(String representation) {
    //Make use of converter and split function?
    final splitted = representation.split('.');

    return Permission.root(splitted.first);
  }

  bool allows(Permission other) {
    if (other._parent != null && _parent != null) {
      if (!_parent!.allows(other._parent!)) {
        return false;
      }
    }
    if ((other._parent == null) ^ (_parent == null)) {
      return false;
    }

    if (_root == '*') {
      return true;
    }

    return other._root == _root;
  }
}

extension PermissionConversion on Permission {
  static Permission fromRepresentation(String representation) {
    return Permission._fromRepresentation(representation);
  }
}

abstract class Permissable {
  String get resourceId;
  String get resourceName;
}
