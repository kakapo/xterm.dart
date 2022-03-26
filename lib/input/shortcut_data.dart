import 'dart:ui';
import 'shortcut_keys.dart';

class ShortcutData {
  final List<ShortcutKeys> shortcuts;

  final Function trigger;

  ShortcutData({
    required this.shortcuts,
    required this.trigger,
  })  : assert(() {
          int count = 0;
          if (shortcuts.contains(ShortcutKeys.MOUSE_REGION) == true) {
            count++;
          }
          if (shortcuts.contains(ShortcutKeys.MOUSE_LEFT) == true) {
            count++;
          }
          if (shortcuts.contains(ShortcutKeys.MOUSE_SCROLL) == true) {
            count++;
          }
          return count <= 1;
        }()),
        assert(() {
          bool hasScroll = shortcuts.contains(ShortcutKeys.MOUSE_SCROLL);
          bool hasLeft = shortcuts.contains(ShortcutKeys.MOUSE_LEFT);
          bool hasRegion = shortcuts.contains(ShortcutKeys.MOUSE_REGION);
          if (hasScroll || hasLeft || hasRegion) {
            if (trigger is VoidCallback) {
              return false;
            }
            return true;
          } else {
            if (trigger is VoidCallback) {
              return true;
            }
            return false;
          }
        }());

  void triggerEvent([event]) {
    // ignore: unnecessary_null_comparison
    if (trigger == null) {
      return;
    }
    if (event == null) {
      trigger();
    } else {
      trigger(event);
    }
  }

  bool equalKey(List<ShortcutKeys> keys, [ShortcutKeys? ignore]) {
    // ignore: unnecessary_null_comparison
    if (keys == null || shortcuts == null) {
      return false;
    }
    if (hasMouse()) {
      if (keys.length != shortcuts.length - 1) {
        return false;
      }
    } else {
      if (keys.length != shortcuts.length) {
        return false;
      }
    }

    int jump = 0;
    for (var i = 0; i < shortcuts.length; ++i) {
      ShortcutKeys shortcutKeys = shortcuts[i];
      if (shortcutKeys == ignore) {
        jump = 1;
        continue;
      }
      if (keys[i - jump] != shortcutKeys) {
        return false;
      }
    }
    return true;
  }

  bool hasMouse() {
    bool hasScroll = shortcuts.contains(ShortcutKeys.MOUSE_SCROLL);
    bool hasLeft = shortcuts.contains(ShortcutKeys.MOUSE_LEFT);
    bool hasRegion = shortcuts.contains(ShortcutKeys.MOUSE_REGION);
    return hasScroll || hasLeft || hasRegion;
  }
}
