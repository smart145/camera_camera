import 'package:camera_camera/camera_camera.dart';
import 'package:camera_camera/src/presentation/controller/camera_camera_controller.dart';
import 'package:camera_camera/src/presentation/controller/camera_camera_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraCameraPreview extends StatefulWidget {
  final void Function(String value)? onFile;
  final CameraCameraController controller;
  final bool enableZoom;
  final bool? enableCancel;

  CameraCameraPreview({
    Key? key,
    this.onFile,
    required this.controller,
    required this.enableZoom,
    this.enableCancel,
  }) : super(key: key);

  @override
  _CameraCameraPreviewState createState() => _CameraCameraPreviewState();
}

class _CameraCameraPreviewState extends State<CameraCameraPreview> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    widget.controller.init();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CameraCameraStatus>(
      valueListenable: widget.controller.statusNotifier,
      builder: (_, status, __) => status.when(
          success: (camera) => GestureDetector(
                onScaleUpdate: (details) {
                  widget.controller.setZoomLevel(details.scale);
                },
                child: Stack(
                  children: [
                    Center(
                      child:
                          CameraPreview(widget.controller.originalController),
                    ),
                    if (widget.enableZoom)
                      Positioned(
                          bottom: 105,
                          left: 0.0,
                          right: 0.0,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black.withOpacity(0.6),
                              child: IconButton(
                                icon: Center(
                                  child: Text(
                                    "${camera.zoom.toStringAsFixed(1)}x",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                splashRadius: 24,
                                onPressed: () {
                                  widget.controller.zoomChange();
                                },
                              ),
                            ),
                          )),
                    if (widget.enableCancel == true)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.black.withOpacity(0.8)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black.withOpacity(0.6)),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    if (widget.controller.flashModes.length > 1)
                      Align(
                        alignment: widget.enableCancel == true
                            ? Alignment.topLeft
                            : Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black.withOpacity(0.6),
                            child: IconButton(
                              onPressed: () {
                                widget.controller.changeFlashMode();
                              },
                              icon: Icon(
                                camera.flashModeIcon,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 29),
                        child: InkWell(
                          onTap: () {
                            widget.controller.takePhoto();
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          failure: (message, _) => Container(
                color: Colors.black,
                child: Text(message),
              ),
          orElse: () => Container(
                color: Colors.black,
              )),
    );
  }
}
