import 'dart:math';

import 'package:flutter/material.dart';
import 'package:xterm/buffer/cell_flags.dart';
import 'package:xterm/buffer/line/line.dart';
import 'package:xterm/mouse/position.dart';
import 'package:xterm/terminal/terminal.dart';
import 'package:xterm/terminal/terminal_search.dart';
import 'package:xterm/theme/terminal_style.dart';
import 'package:xterm/util/bit_flags.dart';

import 'cache.dart';
import 'char_size.dart';

class TerminalPainter extends CustomPainter {
  TerminalPainter({
    required this.terminal,
    required this.style,
    required this.charSize,
    required this.textLayoutCache,
  });

  final Terminal terminal;
  final TerminalStyle style;
  final CellSize charSize;
  final TextLayoutCache textLayoutCache;
  double cursorX = -1;
  double cursorY = -1;

  @override
  void paint(Canvas canvas, Size size) {
    _paintText(canvas);

    _paintUserSearchResult(canvas, size);

    _paintSelection(canvas);
  }

  void _paintUserSearchResult(Canvas canvas, Size size) {
    final searchResult = terminal.userSearchResult;

    //when there is no ongoing user search then directly return
    if (!terminal.isUserSearchActive) {
      return;
    }

    //make everything dim so that the search result can be seen better
    final dimPaint = Paint()
      ..color = Color(terminal.theme.background).withAlpha(128)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), dimPaint);

    for (int i = 1; i <= searchResult.allHits.length; i++) {
      _paintSearchHit(canvas, searchResult.allHits[i - 1], i);
    }
  }

  void _paintSearchHit(Canvas canvas, TerminalSearchHit hit, int hitNum) {
    //check if the hit is visible
    if (hit.startLineIndex >=
            terminal.scrollOffsetFromTop + terminal.terminalHeight ||
        hit.endLineIndex < terminal.scrollOffsetFromTop) {
      return;
    }

    final paint = Paint()
      ..color = Color(terminal.currentSearchHit == hitNum
          ? terminal.theme.searchHitBackgroundCurrent
          : terminal.theme.searchHitBackground)
      ..style = PaintingStyle.fill;

    if (hit.startLineIndex == hit.endLineIndex) {
      final double y =
          (hit.startLineIndex.toDouble() - terminal.scrollOffsetFromTop) *
              charSize.cellHeight;
      final startX = charSize.cellWidth * hit.startIndex;
      final endX = charSize.cellWidth * hit.endIndex;

      canvas.drawRect(
          Rect.fromLTRB(startX, y, endX, y + charSize.cellHeight), paint);
    } else {
      //draw first row: start - line end
      final double yFirstRow =
          (hit.startLineIndex.toDouble() - terminal.scrollOffsetFromTop) *
              charSize.cellHeight;
      final startXFirstRow = charSize.cellWidth * hit.startIndex;
      final endXFirstRow = charSize.cellWidth * terminal.terminalWidth;
      canvas.drawRect(
          Rect.fromLTRB(startXFirstRow, yFirstRow, endXFirstRow,
              yFirstRow + charSize.cellHeight),
          paint);
      //draw middle rows
      final middleRowCount = hit.endLineIndex - hit.startLineIndex - 1;
      if (middleRowCount > 0) {
        final startYMiddleRows =
            (hit.startLineIndex + 1 - terminal.scrollOffsetFromTop) *
                charSize.cellHeight;
        final startXMiddleRows = 0.toDouble();
        final endYMiddleRows = min(
                hit.endLineIndex - terminal.scrollOffsetFromTop,
                terminal.terminalHeight) *
            charSize.cellHeight;
        final endXMiddleRows = terminal.terminalWidth * charSize.cellWidth;
        canvas.drawRect(
            Rect.fromLTRB(startXMiddleRows, startYMiddleRows, endXMiddleRows,
                endYMiddleRows),
            paint);
      }
      //draw end row: line start - end
      if (hit.endLineIndex - terminal.scrollOffsetFromTop <
          terminal.terminalHeight) {
        final startXEndRow = 0.toDouble();
        final startYEndRow = (hit.endLineIndex - terminal.scrollOffsetFromTop) *
            charSize.cellHeight;
        final endXEndRow = hit.endIndex * charSize.cellWidth;
        final endYEndRow = startYEndRow + charSize.cellHeight;
        canvas.drawRect(
            Rect.fromLTRB(startXEndRow, startYEndRow, endXEndRow, endYEndRow),
            paint);
      }
    }

    final visibleLines = terminal.getVisibleLines();

    //paint text
    for (var rawRow = hit.startLineIndex;
        rawRow <= hit.endLineIndex;
        rawRow++) {
      final start = rawRow == hit.startLineIndex ? hit.startIndex : 0;
      final end =
          rawRow == hit.endLineIndex ? hit.endIndex : terminal.terminalWidth;

      final row = rawRow - terminal.scrollOffsetFromTop;

      final offsetY = row * charSize.cellHeight;

      if (row >= visibleLines.length || row < 0) {
        continue;
      }

      final line = visibleLines[row];

      for (var col = start; col < end; col++) {
        final offsetX = col * charSize.cellWidth;
        _paintCell(
          canvas,
          line,
          col,
          offsetX,
          offsetY,
          fgColorOverride: terminal.theme.searchHitForeground,
          bgColorOverride: terminal.theme.searchHitForeground,
        );
      }
    }
  }

  void _paintSelection(Canvas canvas) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);

    for (var y = 0; y < terminal.terminalHeight; y++) {
      final offsetY = y * charSize.cellHeight;
      final absoluteY = terminal.convertViewLineToRawLine(y) -
          terminal.scrollOffsetFromBottom;

      for (var x = 0; x < terminal.terminalWidth; x++) {
        var cellCount = 0;

        while (
            (terminal.selection?.contains(Position(x + cellCount, absoluteY)) ??
                    false) &&
                x + cellCount < terminal.terminalWidth) {
          cellCount++;
        }

        if (cellCount == 0) {
          continue;
        }

        final offsetX = x * charSize.cellWidth;
        final effectWidth = cellCount * charSize.cellWidth;
        final effectHeight = charSize.cellHeight;

        canvas.drawRect(
          Rect.fromLTWH(offsetX, offsetY, effectWidth, effectHeight),
          paint,
        );

        x += cellCount;
      }
    }
  }

  int _getColor(int colorCode) {
    return (colorCode == 0) ? 0xFF000000 : colorCode;
  }

  void _paintCell(
    Canvas canvas,
    BufferLine line,
    int cell,
    double offsetX,
    double offsetY, {
    int? fgColorOverride,
    int? bgColorOverride,
  }) {
    final codePoint = line.cellGetContent(cell);
    final fgColor = fgColorOverride ?? _getColor(line.cellGetFgColor(cell));
    final bgColor = bgColorOverride ?? _getColor(line.cellGetBgColor(cell));
    final flags = line.cellGetFlags(cell);
    final cellwidth = line.cellGetWidth(cell);
    bool hasUnicode = cellwidth == 2 ? true : false;

    if (codePoint == 0 || flags.hasFlag(CellFlags.invisible)) {
      return;
    }

    // final cellHash = line.cellGetHash(cell);
    final cellHash = hashValues(codePoint, fgColor, bgColor, flags);

    var character = textLayoutCache.getLayoutFromCache(cellHash);
    if (character != null) {
      canvas.drawParagraph(character, Offset(offsetX, offsetY));
      return;
    }

    final cellColor = flags.hasFlag(CellFlags.inverse) ? bgColor : fgColor;

    var color = Color(cellColor);

    if (flags & CellFlags.faint != 0) {
      color = color.withOpacity(0.5);
    }

    final styleToUse = PaintHelper.getStyleToUse(
      style,
      color,
      bold: flags.hasFlag(CellFlags.bold),
      italic: flags.hasFlag(CellFlags.italic),
      underline: flags.hasFlag(CellFlags.underline),
      hasUnicode: hasUnicode,
    );

    character = textLayoutCache.performAndCacheLayout(
        String.fromCharCode(codePoint), styleToUse, cellHash);

    canvas.drawParagraph(character, Offset(offsetX, offsetY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    /// paint only when the terminal has changed since last paint.
    return terminal.dirty;
  }

  void _paintText(Canvas canvas) {
    final lines = terminal.getVisibleLines();

    double offsetX = 0;
    // a flag Cell if it's null means it's a space cell or it's the first cell of line
    Cell? flagCell;
    // a string which have the same fgcolor and same unicode
    String builtString = "";
    // if cell's width is 2, means a unicode cell.
    bool flagCellUnicode = false;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final offsetY = i * charSize.cellHeight;

      final cellCount = terminal.terminalWidth;

      for (var j = 0; j < cellCount; j++) {
        final codePoint = line.cellGetContent(j);
        final fgColor = _getColor(line.cellGetFgColor(j));
        final bgColor = _getColor(line.cellGetBgColor(j));
        final flags = line.cellGetFlags(j);
        final cellwidth = line.cellGetWidth(j);

        if (cellwidth == 0 ||
            codePoint == 0 ||
            flags.hasFlag(CellFlags.invisible)) {
          continue;
        }

        // paint cell backgournd
        _paintCellBackground(canvas, line, j, j * charSize.cellWidth, offsetY);

        // if unicode cell, just paint cell.
        if (cellwidth == 2) {
          _paintCell(canvas, line, j, j * charSize.cellWidth, offsetY);
          flagCellUnicode = true;
          continue;
        }

        final cell = new Cell();
        cell.setWidth(cellwidth);
        cell.setFgColor(fgColor);
        cell.setBgColor(bgColor);
        cell.setFlags(flags);

        // reset at the first cell of a line
        if (j == 0) {
          // set flagCell null to indicate current cell is the first cell of line
          flagCell = null;
          terminal.gLocationTitle = '';
        }

        // don't paint space cell for improving UI performance, because every line have space cells.
        // when meet a fist space cell of a line, the previous builtString is always a path location. like: admin@larkbooks:/home/admin$ ls
        // space cell's ASCII code is 32
        if (codePoint == 32) {
          if (flagCell != null) {
            // when meet a space cell, and flagCell have content, means builtString have chars, must paint it once time.
            /*
            print("paint builtString 1:" +
                builtString +
                ", offsetX=" +
                offsetX.toString());
            */
            paintString(canvas, flagCell, offsetX, offsetY, builtString,
                flagCellUnicode);
            // set the first string of line as location
            if (terminal.gLocationTitle == '') {
              terminal.gLocationTitle = builtString;
            }
          }
          // set flagCell null to indicate it is a space sell, all space cells are skipped .
          flagCell = null;
        } else {
          //if cell is not space, going to build string or paint string.
          String singleChar = String.fromCharCode(codePoint);
          bool unicodeFlag = cellwidth == 2;
          if (flagCell == null) {
            // if flagCell is null,  means previous cell is first cell or previous cell is space cell.
            flagCell = cell;
            builtString = singleChar;
            offsetX = j * charSize.cellWidth;
            flagCellUnicode = unicodeFlag;
          } else {
            //if the current cell are same fgcolor and same unicode wiht flag cell, going to build string
            if (flagCellUnicode == unicodeFlag &&
                (fgColor == 0xFF000000 ||
                    (fgColor != 0xFF000000 &&
                        flagCell.getFgColor() != 0xFF000000 &&
                        fgColor == flagCell.getFgColor()))) {
              builtString = builtString + singleChar;
            } else {
              // but if current cell's fgcolor changed, or unicode changed
              // paint the previous built string at once and reset.
              /*
              print("paint builtString 2:" +
                  builtString +
                  ", offsetX=" +
                  offsetX.toString());
              */
              paintString(
                  canvas, flagCell, offsetX, offsetY, builtString, unicodeFlag);
              flagCell = cell;
              builtString = singleChar;
              offsetX = j * charSize.cellWidth;
              flagCellUnicode = unicodeFlag;
            }
          }
        }
      }

      // paint the remaining build string as every line is not end of space cell.
      if (flagCell != null) {
        /*
        print("paint builtString 3:" +
            builtString +
            ", offsetX=" +
            offsetX.toString());
        */
        paintString(
            canvas, flagCell, offsetX, offsetY, builtString, flagCellUnicode);
        flagCell = null;
      }
    }
  }

  void paintString(Canvas canvas, Cell cell, double offsetX, double offsetY,
      String builtString, bool hasUnicode) {
    final fgColor = cell.getFgColor();
    final bgColor = cell.getBgColor();
    final flags = cell.getFlags();

    final cellHash = hashValues(builtString, fgColor, bgColor, flags);
    var character = textLayoutCache.getLayoutFromCache(cellHash);
    if (character != null) {
      canvas.drawParagraph(character, Offset(offsetX, offsetY));
      return;
    }

    final cellColor = flags.hasFlag(CellFlags.inverse) ? bgColor : fgColor;
    var color = Color(cellColor);
    if (flags & CellFlags.faint != 0) {
      color = color.withOpacity(0.5);
    }

    final styleToUse = PaintHelper.getStyleToUse(
      style,
      color,
      bold: flags.hasFlag(CellFlags.bold),
      italic: flags.hasFlag(CellFlags.italic),
      underline: flags.hasFlag(CellFlags.underline),
      hasUnicode: hasUnicode,
    );
    character = textLayoutCache.performAndCacheLayout(
        builtString, styleToUse, cellHash);
    canvas.drawParagraph(character, Offset(offsetX, offsetY));
  }

  void _paintCellBackground(
      Canvas canvas, BufferLine line, int cell, offsetX, offsetY) {
    final cellWidth = line.cellGetWidth(cell);
    final cellFgColor = line.cellGetFgColor(cell);
    final cellBgColor = line.cellGetBgColor(cell);
    final effectBgColor =
        line.cellHasFlag(cell, CellFlags.inverse) ? cellFgColor : cellBgColor;

    if (effectBgColor == 0x00) {
      return;
    }

    // when a program reports black as background then it "really" means transparent
    if (effectBgColor == 0xFF000000) {
      return;
    }

    final offsetX = cell * charSize.cellWidth;
    final effectWidth = charSize.cellWidth * cellWidth + 1;
    final effectHeight = charSize.cellHeight + 1;

    // background color is already painted with opacity by the Container of
    // TerminalPainter so wo don't need to fallback to
    // terminal.theme.background here.

    if (offsetX != cursorX || offsetY != cursorY) {
      final paint = Paint()..color = Color(effectBgColor);
      canvas.drawRect(
        Rect.fromLTWH(offsetX, offsetY, effectWidth, effectHeight),
        paint,
      );
    }
  }
}

class Cell {
  Cell({this.codePoint = 0, this.width = 0});

  int codePoint = 0;
  int width = 0;
  int flags = 0;
  int fgColor = 0;
  int bgColor = 0;

  void setCodePoint(int codePoint) {
    this.codePoint = codePoint;
  }

  void setWidth(int width) {
    this.width = width;
  }

  void setFlags(int flags) {
    this.flags = flags;
  }

  void setFgColor(int fgColor) {
    this.fgColor = fgColor;
  }

  void setBgColor(int bgColor) {
    this.bgColor = bgColor;
  }

  int getFgColor() {
    return this.fgColor;
  }

  int getBgColor() {
    return this.bgColor;
  }

  int getCodePoint() {
    return this.codePoint;
  }

  int getWidth() {
    return this.width;
  }

  int getFlags() {
    return this.flags;
  }

  @override
  String toString() {
    return 'Cell($codePoint)';
  }
}

class CursorPainter extends CustomPainter {
  final bool visible;
  final CellSize charSize;
  final bool focused;
  final bool blinkVisible;
  final int cursorColor;
  final int textColor;
  final String composingString;
  final TextLayoutCache textLayoutCache;
  final TerminalStyle style;

  CursorPainter({
    required this.visible,
    required this.charSize,
    required this.focused,
    required this.blinkVisible,
    required this.cursorColor,
    required this.textColor,
    required this.composingString,
    required this.textLayoutCache,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    bool isVisible =
        visible && (blinkVisible || composingString != '' || !focused);
    if (isVisible) {
      _paintCursor(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CursorPainter) {
      return blinkVisible != oldDelegate.blinkVisible ||
          focused != oldDelegate.focused ||
          visible != oldDelegate.visible ||
          charSize.cellWidth != oldDelegate.charSize.cellWidth ||
          charSize.cellHeight != oldDelegate.charSize.cellHeight ||
          composingString != oldDelegate.composingString;
    }
    return true;
  }

  void _paintCursor(Canvas canvas) {
    final paint = Paint()
      ..color = Color(cursorColor)
      ..strokeWidth = focused ? 0.0 : 1.0
      ..style = focused ? PaintingStyle.fill : PaintingStyle.stroke;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, charSize.cellWidth, charSize.cellHeight), paint);

    if (composingString != '') {
      final styleToUse = PaintHelper.getStyleToUse(style, Color(textColor));
      final character = textLayoutCache.performAndCacheLayout(
          composingString, styleToUse, null);
      canvas.drawParagraph(character, Offset(0, 0));
    }
  }
}

class PaintHelper {
  static TextStyle getStyleToUse(
    TerminalStyle style,
    Color color, {
    bool bold = false,
    bool italic = false,
    bool underline = false,
    bool hasUnicode = false,
  }) {
    return (style.textStyleProvider != null)
        ? style.textStyleProvider!(
            color: color,
            fontSize: style.fontSize,
            fontWeight: bold && !style.ignoreBoldFlag
                ? FontWeight.bold
                : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            decoration:
                underline ? TextDecoration.underline : TextDecoration.none,
          )
        : TextStyle(
            color: color,
            fontSize: style.fontSize,
            fontWeight: bold && !style.ignoreBoldFlag
                ? FontWeight.bold
                : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            decoration:
                underline ? TextDecoration.underline : TextDecoration.none,
            fontFamily: hasUnicode ? 'microhei' : 'monospace',
            letterSpacing: hasUnicode ? 2.2 : 0,
            fontFamilyFallback: style.fontFamily,
          );
  }
}
