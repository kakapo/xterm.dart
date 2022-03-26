import 'package:flutter/material.dart';

///
/// @author tsing
/// @time 2018/10/15
/// @email shuqing.li@merculet.io
///
class Toast {
  static OverlayEntry? _overlayEntry;
  static bool _showing = false;
  static DateTime? _startedTime;
  static String? _msg;
  static void toast(
    BuildContext context,
    String msg,
  ) async {
    _msg = msg;
    _startedTime = DateTime.now();
    //get OverlayState
    OverlayState? overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
                //top value
                top: MediaQuery.of(context).size.height * 2 / 3,
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80.0),
                      child: AnimatedOpacity(
                        opacity: _showing ? 1.0 : 0.0,
                        duration: _showing
                            ? Duration(milliseconds: 100)
                            : Duration(milliseconds: 400),
                        child: _buildToastWidget(),
                      ),
                    )),
              ));
      overlayState?.insert(_overlayEntry!);
    } else {
      //rebuild UI，like setState
      _overlayEntry?.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: 2000));

    //after 2 seconds, it disapears.
    if (DateTime.now().difference(_startedTime!).inMilliseconds >= 2000) {
      _showing = false;
      _overlayEntry?.markNeedsBuild();
    }
  }

  static _buildToastWidget() {
    return Center(
      child: Card(
        color: Colors.black26,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Text(
            _msg!,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontFamily: 'microhei',
            ),
          ),
        ),
      ),
    );
  }
}
