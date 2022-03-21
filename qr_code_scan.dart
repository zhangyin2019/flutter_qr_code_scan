import 'dart:io';

import 'package:ddcw_app/icons/sxb_icons.dart';
import 'package:ddcw_app/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrcodeScanPage extends StatefulWidget {
  final QrScannerOverlayShape qrScannerOverlayShape;

  QrcodeScanPage({
    this.qrScannerOverlayShape,
    Key key,
  }) : super(key: key);

  @override
  _QrcodeScanPageState createState() => _QrcodeScanPageState();
}

class _QrcodeScanPageState extends State<QrcodeScanPage>
    with TickerProviderStateMixin {
  QRViewController _controller;

  AnimationController _animation;
  Animation<EdgeInsets> _padding;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    initYellowLine();

    //
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller.pauseCamera();
    } else if (Platform.isIOS) {
      _controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  // 光条动画
  Future<void> startYellowLineAnimation() async {
    try {
      await _animation.forward().orCancel;
      await _animation.reverse().orCancel;
      await startYellowLineAnimation();
    } on TickerCanceled {}

    //
  }

  // 步数 光条
  void initYellowLine() {
    _animation = AnimationController(
      duration: Duration(milliseconds: 3000),
      reverseDuration: Duration(milliseconds: 3000),
      vsync: this,
    );

    if (_animation != null) {
      _padding = Tween<EdgeInsets>(
        begin: EdgeInsets.only(
          top: .0,
        ),
        end: EdgeInsets.only(
          top: MediaQuery.of(context).size.height,
        ),
      ).animate(
        CurvedAnimation(
          parent: _animation,
          curve: Interval(
            0.0,
            1.0,
          ),
        ),
      );

      startYellowLineAnimation();

      //
    }

    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 摄像头
          QRView(
            key: GlobalKey(debugLabel: 'QRCode'),
            overlay: widget.qrScannerOverlayShape ??
                QrScannerOverlayShape(
                  cutOutWidth: MediaQuery.of(context).size.width,
                  cutOutHeight: MediaQuery.of(context).size.height,
                ),
            onQRViewCreated: (QRViewController controller) {
              _controller = controller;

              if (controller.hasPermissions) return;

              controller.scannedDataStream.listen((result) {
                _controller.pauseCamera();
                AppUtil.pop(context, result: result.code);

                //
              });

              //
            },
            onPermissionSet: (QRViewController controller, bool isGranted) {
              if (!isGranted) AppUtil.pop(context);
            },

            //
          ),

          // 光条
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget child) {
              return Container(
                margin: _padding.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/qr_code_yellow_line.svg',
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.yellow,
                    )
                  ],
                ),
              );
            },
          ),

          // 返回
          Positioned(
            left: 16,
            top: MediaQuery.of(context).viewPadding.top + 16,
            child: InkWell(
              child: ClipOval(
                child: Container(
                  color: Colors.white.withOpacity(0.6),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    SxbIcons.IconFanhui,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),

              onTap: () {
                Navigator.of(context).pop();
              },

              //
            ),
          )

          //
        ],
      ),
    );
  }
}
