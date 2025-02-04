import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum ShortcutKeys {
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P,
  Q,
  R,
  S,
  T,
  U,
  V,
  W,
  X,
  Y,
  Z,
  SEMICOLON, // ;
  MINUS, // -
  EQUAL, // =
  COMMA, // ,
  SLASH_AND_NUM_DIV, // /
  BACKSLASH, // \
  BRACKET_LEFT, // [
  BRACKET_RIGHT, // ]
  QUOTE, // '
  BACK_QUOTE, // `
  PERIOD, // .
  DIGIT0,
  DIGIT1,
  DIGIT2,
  DIGIT3,
  DIGIT4,
  DIGIT5,
  DIGIT6,
  DIGIT7,
  DIGIT8,
  DIGIT9,
  NUM0,
  NUM1,
  NUM2,
  NUM3,
  NUM4,
  NUM5,
  NUM6,
  NUM7,
  NUM8,
  NUM9,
  NUM_MUL, // *
  NUM_SUB, // -
  NUM_ADD, // +
  NUM_LOCK,
  F1,
  F2,
  F3,
  F4,
  F5,
  F6,
  F7,
  F8,
  F9,
  F10,
  F11,
  F12,
  ARROW_UP,
  ARROW_DOWN,
  ARROW_LEFT,
  ARROW_RIGHT,
  ALT_LEFT,
  ALT_RIGHT,
  CTRL_LEFT,
  CTRL_RIGHT,
  SHIFT_LEFT,
  SHIFT_RIGHT,
  CAPS_LOCK,
  SUPER_LEFT,
  SUPER_RIGHT,
  MENU,
  TAB,
  SPACE,
  ENTER_AND_NUM_ENTER,
  ESCAPE,
  BACKSPACE,
  PRINT,
  SCROLL_LOCK,
  PAUSE,
  INSERT,
  DELETE,
  NUM_DECIMAL,
  HOME,
  END,
  PAGE_UP,
  PAGE_DOWN,
  MOUSE_LEFT,
  MOUSE_SCROLL,
  MOUSE_REGION,
}

class ShortcutKey {
  // ignore: non_constant_identifier_names
  static final PhysicalKeyboardKeyMaps = {
    PhysicalKeyboardKey.space: ShortcutKeys.SPACE,
    PhysicalKeyboardKey.quote: ShortcutKeys.QUOTE, // '
    PhysicalKeyboardKey.comma: ShortcutKeys.COMMA, // ,
    PhysicalKeyboardKey.minus: ShortcutKeys.MINUS, // -
    PhysicalKeyboardKey.period: ShortcutKeys.PERIOD, // .
    PhysicalKeyboardKey.slash: ShortcutKeys.SLASH_AND_NUM_DIV, // /
    PhysicalKeyboardKey.digit0: ShortcutKeys.DIGIT0,
    PhysicalKeyboardKey.digit1: ShortcutKeys.DIGIT1,
    PhysicalKeyboardKey.digit2: ShortcutKeys.DIGIT2,
    PhysicalKeyboardKey.digit3: ShortcutKeys.DIGIT3,
    PhysicalKeyboardKey.digit4: ShortcutKeys.DIGIT4,
    PhysicalKeyboardKey.digit5: ShortcutKeys.DIGIT5,
    PhysicalKeyboardKey.digit6: ShortcutKeys.DIGIT6,
    PhysicalKeyboardKey.digit7: ShortcutKeys.DIGIT7,
    PhysicalKeyboardKey.digit8: ShortcutKeys.DIGIT8,
    PhysicalKeyboardKey.digit9: ShortcutKeys.DIGIT9,
    PhysicalKeyboardKey.select: ShortcutKeys.SEMICOLON, // ;
    PhysicalKeyboardKey.equal: ShortcutKeys.EQUAL, // =
    PhysicalKeyboardKey.keyA: ShortcutKeys.A,
    PhysicalKeyboardKey.keyB: ShortcutKeys.B,
    PhysicalKeyboardKey.keyC: ShortcutKeys.C,
    PhysicalKeyboardKey.keyD: ShortcutKeys.D,
    PhysicalKeyboardKey.keyE: ShortcutKeys.E,
    PhysicalKeyboardKey.keyF: ShortcutKeys.F,
    PhysicalKeyboardKey.keyG: ShortcutKeys.G,
    PhysicalKeyboardKey.keyH: ShortcutKeys.H,
    PhysicalKeyboardKey.keyI: ShortcutKeys.I,
    PhysicalKeyboardKey.keyJ: ShortcutKeys.J,
    PhysicalKeyboardKey.keyK: ShortcutKeys.K,
    PhysicalKeyboardKey.keyL: ShortcutKeys.L,
    PhysicalKeyboardKey.keyM: ShortcutKeys.M,
    PhysicalKeyboardKey.keyN: ShortcutKeys.N,
    PhysicalKeyboardKey.keyO: ShortcutKeys.O,
    PhysicalKeyboardKey.keyP: ShortcutKeys.P,
    PhysicalKeyboardKey.keyQ: ShortcutKeys.Q,
    PhysicalKeyboardKey.keyR: ShortcutKeys.R,
    PhysicalKeyboardKey.keyS: ShortcutKeys.S,
    PhysicalKeyboardKey.keyT: ShortcutKeys.T,
    PhysicalKeyboardKey.keyU: ShortcutKeys.U,
    PhysicalKeyboardKey.keyV: ShortcutKeys.V,
    PhysicalKeyboardKey.keyW: ShortcutKeys.W,
    PhysicalKeyboardKey.keyX: ShortcutKeys.X,
    PhysicalKeyboardKey.keyY: ShortcutKeys.Y,
    PhysicalKeyboardKey.keyZ: ShortcutKeys.Z,
    PhysicalKeyboardKey.bracketLeft: ShortcutKeys.BRACKET_LEFT, // [
    PhysicalKeyboardKey.backslash: ShortcutKeys.BACKSLASH, // \
    PhysicalKeyboardKey.bracketRight: ShortcutKeys.BRACKET_RIGHT, // ]
    PhysicalKeyboardKey.backquote: ShortcutKeys.BACK_QUOTE, // `
    PhysicalKeyboardKey.numpadEnter: ShortcutKeys.ENTER_AND_NUM_ENTER,
    PhysicalKeyboardKey.tab: ShortcutKeys.TAB,
    PhysicalKeyboardKey.arrowRight: ShortcutKeys.ARROW_RIGHT,
    PhysicalKeyboardKey.arrowLeft: ShortcutKeys.ARROW_LEFT,
    PhysicalKeyboardKey.arrowDown: ShortcutKeys.ARROW_DOWN,
    PhysicalKeyboardKey.arrowUp: ShortcutKeys.ARROW_UP,
    PhysicalKeyboardKey.scrollLock: ShortcutKeys.SCROLL_LOCK,
    PhysicalKeyboardKey.capsLock: ShortcutKeys.CAPS_LOCK,
    PhysicalKeyboardKey.numLock: ShortcutKeys.NUM_LOCK,
    PhysicalKeyboardKey.f1: ShortcutKeys.F1,
    PhysicalKeyboardKey.f2: ShortcutKeys.F2,
    PhysicalKeyboardKey.f3: ShortcutKeys.F3,
    PhysicalKeyboardKey.f4: ShortcutKeys.F4,
    PhysicalKeyboardKey.f5: ShortcutKeys.F5,
    PhysicalKeyboardKey.f6: ShortcutKeys.F6,
    PhysicalKeyboardKey.f7: ShortcutKeys.F7,
    PhysicalKeyboardKey.f8: ShortcutKeys.F8,
    PhysicalKeyboardKey.f9: ShortcutKeys.F9,
    PhysicalKeyboardKey.f10: ShortcutKeys.F10,
    PhysicalKeyboardKey.f11: ShortcutKeys.F11,
    PhysicalKeyboardKey.f12: ShortcutKeys.F12,
    PhysicalKeyboardKey.numpad0: ShortcutKeys.NUM0,
    PhysicalKeyboardKey.numpad1: ShortcutKeys.NUM1,
    PhysicalKeyboardKey.numpad2: ShortcutKeys.NUM2,
    PhysicalKeyboardKey.numpad3: ShortcutKeys.NUM3,
    PhysicalKeyboardKey.numpad4: ShortcutKeys.NUM4,
    PhysicalKeyboardKey.numpad5: ShortcutKeys.NUM5,
    PhysicalKeyboardKey.numpad6: ShortcutKeys.NUM6,
    PhysicalKeyboardKey.numpad7: ShortcutKeys.NUM7,
    PhysicalKeyboardKey.numpad8: ShortcutKeys.NUM8,
    PhysicalKeyboardKey.numpad9: ShortcutKeys.NUM9,
    PhysicalKeyboardKey.intlBackslash: ShortcutKeys.SLASH_AND_NUM_DIV, // /
    PhysicalKeyboardKey.numpadMultiply: ShortcutKeys.NUM_MUL, // *
    PhysicalKeyboardKey.numpadSubtract: ShortcutKeys.NUM_SUB, // -
    PhysicalKeyboardKey.numpadAdd: ShortcutKeys.NUM_ADD, // +
    PhysicalKeyboardKey.enter: ShortcutKeys.ENTER_AND_NUM_ENTER,
    PhysicalKeyboardKey.shiftLeft: ShortcutKeys.SHIFT_LEFT,
    PhysicalKeyboardKey.controlLeft: ShortcutKeys.CTRL_LEFT,
    PhysicalKeyboardKey.altLeft: ShortcutKeys.ALT_LEFT,
    PhysicalKeyboardKey.superKey: ShortcutKeys.SUPER_LEFT,
    PhysicalKeyboardKey.shiftRight: ShortcutKeys.SHIFT_RIGHT,
    PhysicalKeyboardKey.controlRight: ShortcutKeys.CTRL_RIGHT,
    PhysicalKeyboardKey.altRight: ShortcutKeys.ALT_RIGHT,
    PhysicalKeyboardKey.contextMenu: ShortcutKeys.MENU,
    PhysicalKeyboardKey.escape: ShortcutKeys.ESCAPE,
    PhysicalKeyboardKey.backspace: ShortcutKeys.BACKSPACE,
    PhysicalKeyboardKey.print: ShortcutKeys.PRINT,
    PhysicalKeyboardKey.insert: ShortcutKeys.INSERT,
    PhysicalKeyboardKey.delete: ShortcutKeys.DELETE,
    PhysicalKeyboardKey.numpadDecimal: ShortcutKeys.NUM_DECIMAL,
    PhysicalKeyboardKey.home: ShortcutKeys.HOME,
    PhysicalKeyboardKey.end: ShortcutKeys.END,
    PhysicalKeyboardKey.pageUp: ShortcutKeys.PAGE_UP,
    PhysicalKeyboardKey.pageDown: ShortcutKeys.PAGE_DOWN,
    PhysicalKeyboardKey.pause: ShortcutKeys.PAUSE,
  };

  static const keyLinuxAndWindows = {
    32: ShortcutKeys.SPACE,
    39: ShortcutKeys.QUOTE, // '
    44: ShortcutKeys.COMMA, // ,
    45: ShortcutKeys.MINUS, // -
    46: ShortcutKeys.PERIOD, // .
    47: ShortcutKeys.SLASH_AND_NUM_DIV, // /
    48: ShortcutKeys.DIGIT0,
    49: ShortcutKeys.DIGIT1,
    50: ShortcutKeys.DIGIT2,
    51: ShortcutKeys.DIGIT3,
    52: ShortcutKeys.DIGIT4,
    53: ShortcutKeys.DIGIT5,
    54: ShortcutKeys.DIGIT6,
    55: ShortcutKeys.DIGIT7,
    56: ShortcutKeys.DIGIT8,
    57: ShortcutKeys.DIGIT9,
    59: ShortcutKeys.SEMICOLON, // ;
    61: ShortcutKeys.EQUAL, // =
    65: ShortcutKeys.A,
    66: ShortcutKeys.B,
    67: ShortcutKeys.C,
    68: ShortcutKeys.D,
    69: ShortcutKeys.E,
    70: ShortcutKeys.F,
    71: ShortcutKeys.G,
    72: ShortcutKeys.H,
    73: ShortcutKeys.I,
    74: ShortcutKeys.J,
    75: ShortcutKeys.K,
    76: ShortcutKeys.L,
    77: ShortcutKeys.M,
    78: ShortcutKeys.N,
    79: ShortcutKeys.O,
    80: ShortcutKeys.P,
    81: ShortcutKeys.Q,
    82: ShortcutKeys.R,
    83: ShortcutKeys.S,
    84: ShortcutKeys.T,
    85: ShortcutKeys.U,
    86: ShortcutKeys.V,
    87: ShortcutKeys.W,
    88: ShortcutKeys.X,
    89: ShortcutKeys.Y,
    90: ShortcutKeys.Z,
    91: ShortcutKeys.BRACKET_LEFT, // [
    92: ShortcutKeys.BACKSLASH, // \
    93: ShortcutKeys.BRACKET_RIGHT, // ]
    96: ShortcutKeys.BACK_QUOTE, // `
    257: ShortcutKeys.ENTER_AND_NUM_ENTER,
    258: ShortcutKeys.TAB,
    262: ShortcutKeys.ARROW_RIGHT,
    263: ShortcutKeys.ARROW_LEFT,
    264: ShortcutKeys.ARROW_DOWN,
    265: ShortcutKeys.ARROW_UP,
    281: ShortcutKeys.SCROLL_LOCK,
    280: ShortcutKeys.CAPS_LOCK,
    282: ShortcutKeys.NUM_LOCK,
    290: ShortcutKeys.F1,
    291: ShortcutKeys.F2,
    292: ShortcutKeys.F3,
    293: ShortcutKeys.F4,
    294: ShortcutKeys.F5,
    295: ShortcutKeys.F6,
    296: ShortcutKeys.F7,
    297: ShortcutKeys.F8,
    298: ShortcutKeys.F9,
    299: ShortcutKeys.F10,
    300: ShortcutKeys.F11,
    301: ShortcutKeys.F12,
    320: ShortcutKeys.NUM0,
    321: ShortcutKeys.NUM1,
    322: ShortcutKeys.NUM2,
    323: ShortcutKeys.NUM3,
    324: ShortcutKeys.NUM4,
    325: ShortcutKeys.NUM5,
    326: ShortcutKeys.NUM6,
    327: ShortcutKeys.NUM7,
    328: ShortcutKeys.NUM8,
    329: ShortcutKeys.NUM9,
    331: ShortcutKeys.SLASH_AND_NUM_DIV, // /
    332: ShortcutKeys.NUM_MUL, // *
    333: ShortcutKeys.NUM_SUB, // -
    334: ShortcutKeys.NUM_ADD, // +
    335: ShortcutKeys.ENTER_AND_NUM_ENTER,
    340: ShortcutKeys.SHIFT_LEFT,
    341: ShortcutKeys.CTRL_LEFT,
    342: ShortcutKeys.ALT_LEFT,
    343: ShortcutKeys.SUPER_LEFT,
    344: ShortcutKeys.SHIFT_RIGHT,
    345: ShortcutKeys.CTRL_RIGHT,
    346: ShortcutKeys.ALT_RIGHT,
    347: ShortcutKeys.SUPER_RIGHT,
    348: ShortcutKeys.MENU,
    256: ShortcutKeys.ESCAPE,
    259: ShortcutKeys.BACKSPACE,
    283: ShortcutKeys.PRINT,
    260: ShortcutKeys.INSERT,
    261: ShortcutKeys.DELETE,
    330: ShortcutKeys.NUM_DECIMAL,
    268: ShortcutKeys.HOME,
    269: ShortcutKeys.END,
    266: ShortcutKeys.PAGE_UP,
    267: ShortcutKeys.PAGE_DOWN,
    284: ShortcutKeys.PAUSE,
  };

  /// android keycode
  static const keyAndroid = {
    62: ShortcutKeys.SPACE,
    75: ShortcutKeys.QUOTE, // '
    55: ShortcutKeys.COMMA, // ,
    69: ShortcutKeys.MINUS, // -
    56: ShortcutKeys.PERIOD, // .
    76: ShortcutKeys.SLASH_AND_NUM_DIV, // /
    7: ShortcutKeys.DIGIT0,
    8: ShortcutKeys.DIGIT1,
    9: ShortcutKeys.DIGIT2,
    10: ShortcutKeys.DIGIT3,
    11: ShortcutKeys.DIGIT4,
    12: ShortcutKeys.DIGIT5,
    13: ShortcutKeys.DIGIT6,
    14: ShortcutKeys.DIGIT7,
    15: ShortcutKeys.DIGIT8,
    16: ShortcutKeys.DIGIT9,
    74: ShortcutKeys.SEMICOLON, // ;
    70: ShortcutKeys.EQUAL, // =
    29: ShortcutKeys.A,
    30: ShortcutKeys.B,
    31: ShortcutKeys.C,
    32: ShortcutKeys.D,
    33: ShortcutKeys.E,
    34: ShortcutKeys.F,
    35: ShortcutKeys.G,
    36: ShortcutKeys.H,
    37: ShortcutKeys.I,
    38: ShortcutKeys.J,
    39: ShortcutKeys.K,
    40: ShortcutKeys.L,
    41: ShortcutKeys.M,
    42: ShortcutKeys.N,
    43: ShortcutKeys.O,
    44: ShortcutKeys.P,
    45: ShortcutKeys.Q,
    46: ShortcutKeys.R,
    47: ShortcutKeys.S,
    48: ShortcutKeys.T,
    49: ShortcutKeys.U,
    50: ShortcutKeys.V,
    51: ShortcutKeys.W,
    52: ShortcutKeys.X,
    53: ShortcutKeys.Y,
    54: ShortcutKeys.Z,
    71: ShortcutKeys.BRACKET_LEFT, // [
    73: ShortcutKeys.BACKSLASH, // \
    72: ShortcutKeys.BRACKET_RIGHT, // ]
    68: ShortcutKeys.BACK_QUOTE, // `
    66: ShortcutKeys.ENTER_AND_NUM_ENTER,
    61: ShortcutKeys.TAB,
    22: ShortcutKeys.ARROW_RIGHT,
    21: ShortcutKeys.ARROW_LEFT,
    20: ShortcutKeys.ARROW_DOWN,
    19: ShortcutKeys.ARROW_UP,
    144: ShortcutKeys.NUM0,
    145: ShortcutKeys.NUM1,
    146: ShortcutKeys.NUM2,
    147: ShortcutKeys.NUM3,
    148: ShortcutKeys.NUM4,
    149: ShortcutKeys.NUM5,
    150: ShortcutKeys.NUM6,
    151: ShortcutKeys.NUM7,
    152: ShortcutKeys.NUM8,
    153: ShortcutKeys.NUM9,
    154: ShortcutKeys.SLASH_AND_NUM_DIV, // /
    155: ShortcutKeys.NUM_MUL, // *
    156: ShortcutKeys.NUM_SUB, // -
    157: ShortcutKeys.NUM_ADD, // +
    113: ShortcutKeys.CTRL_LEFT,
    57: ShortcutKeys.ALT_LEFT,
    60: ShortcutKeys.SHIFT_RIGHT,
    59: ShortcutKeys.SHIFT_LEFT,
    114: ShortcutKeys.CTRL_RIGHT,
    58: ShortcutKeys.ALT_RIGHT,
    82: ShortcutKeys.MENU,
    115: ShortcutKeys.CAPS_LOCK,
    143: ShortcutKeys.NUM_LOCK,
    116: ShortcutKeys.SCROLL_LOCK,
    160: ShortcutKeys.ENTER_AND_NUM_ENTER,
    131: ShortcutKeys.F1,
    132: ShortcutKeys.F2,
    133: ShortcutKeys.F3,
    134: ShortcutKeys.F4,
    135: ShortcutKeys.F5,
    136: ShortcutKeys.F6,
    137: ShortcutKeys.F7,
    138: ShortcutKeys.F8,
    139: ShortcutKeys.F9,
    140: ShortcutKeys.F10,
    141: ShortcutKeys.F11,
    142: ShortcutKeys.F12,
    111: ShortcutKeys.ESCAPE,
    67: ShortcutKeys.BACKSPACE,
    120: ShortcutKeys.PRINT,
    124: ShortcutKeys.INSERT,
    112: ShortcutKeys.DELETE,
    158: ShortcutKeys.NUM_DECIMAL,
    122: ShortcutKeys.HOME,
    123: ShortcutKeys.END,
    92: ShortcutKeys.PAGE_UP,
    93: ShortcutKeys.PAGE_DOWN,
    121: ShortcutKeys.PAUSE,

    -1: ShortcutKeys.SUPER_LEFT,
    -2: ShortcutKeys.SUPER_RIGHT,
  };

  static ShortcutKeys? getKey(int keyCode, [PhysicalKeyboardKey? physicalKey]) {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      ShortcutKeys? key = PhysicalKeyboardKeyMaps[physicalKey];
      if (key == null) {
        key = keyLinuxAndWindows[keyCode];
      }
      return key;
    } else if (Platform.isAndroid) {
      return keyAndroid[keyCode];
    }

    throw FlutterError('Unsupported platform,keyboard code :$keyCode');
  }
}
