import 'package:camera/camera.dart';
import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/data/models/report_model.dart';
import 'package:cilean/data/repository/report_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReportCameraLayout extends StatefulWidget {
  const ReportCameraLayout({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  _ReportCameraLayoutState createState() => _ReportCameraLayoutState();
}

class _ReportCameraLayoutState extends State<ReportCameraLayout> {
  final ReportRepository _repository = ReportRepository();
  late CameraController _controller;
  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras[0]);
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      await _controller.setFlashMode(FlashMode.off);
      XFile picture = await _controller.takePicture();
      Position curPosition = await Geolocator.getCurrentPosition();
      await _repository.create(
        report: ReportModel(
          verified: false,
          reportedAt: Timestamp.now(),
          location: GeoPoint(curPosition.latitude, curPosition.longitude),
        ),
        email: FirebaseAuth.instance.currentUser!.email!,
      );
      Navigator.of(context).pop();
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Container(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _controller.value.isInitialized
                    ? CameraPreview(_controller)
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: SizeConfig.blockHeight * 10,
                  child: Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: takePicture,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          SizeConfig.blockWidth * 15,
                          SizeConfig.blockWidth * 15,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        shape: const CircleBorder(),
                      ),
                      child:
                          const Icon(Icons.circle, color: Colors.transparent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
