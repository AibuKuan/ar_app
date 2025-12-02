import 'package:ar_app/services/model.dart';
import 'package:ar_app/utils/ar.dart';
import 'package:ar_app/widgets/qr_scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(autoStart: false);
  bool _isStarting = true;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.start().whenComplete(() => _isStarting = false);
  }

  @override
  void dispose() {
    _controller.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    if (state == AppLifecycleState.paused) {
      if (_isStarting) return;
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (_isStarting) return;
      _controller.start().whenComplete(() => _isStarting = false);
    }
  }

  // Helper method to restart the scanner
  void _restartScanner() {
    if (_isStarting) return;

    _isStarting = true;
    _controller.start().whenComplete(() => _isStarting = false);
  }

  Future<void> _showConfirmationDialog(BuildContext context, Model model) async {
    final bool? shouldOpen = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('View AR Model'),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.0, // Default text size in dialogs
                color: Theme.of(dialogContext).textTheme.bodyLarge?.color,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Do you want to open the AR view for model: '),
                TextSpan(
                  text: '${model.detail?.name}', // Assuming you meant model.name from the previous context
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // User canceled
              },
            ),
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // User confirmed
              },
            ),
          ],
        );
      },
    );

    // Act based on the dialog result
    if (shouldOpen == true) {
      showARView(context, model, _restartScanner);
    } else {
      // If canceled, restart the scanner immediately
      _restartScanner();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the total height of the widget (usually the screen height)
    final double screenHeight = MediaQuery.sizeOf(context).height;
    
    // Define the desired vertical shift as a fraction of the screen height.
    // Example: Shift up by 10% of the screen height.
    // 0.10 means 10% of the screen height. Use negative to shift up.
    const double verticalShiftRatio = -0.10; // Change this value (e.g., -0.05 for a smaller shift)
    
    // Calculate the fixed pixel offset based on the ratio
    final double verticalOffset = screenHeight * verticalShiftRatio;

    final Rect scanArea = Rect.fromCenter(
      // The center() method calculates the center of the screen size.
      // We then apply our calculated proportional vertical offset.
      center: MediaQuery.sizeOf(context).center(Offset(0, verticalOffset)),
      width: 300,
      height: 300,
    );

    return MobileScanner(
      controller: _controller,
      scanWindow: scanArea,
      overlayBuilder: (context, constraints) {
        // The constraints argument provides the size of the MobileScanner widget.
        // This is passed directly into the QrScannerOverlay.
        return QRScannerOverlay(
          scanWindow: scanArea,
        );
      },
      onDetect: (capture) async {
        final barcode = capture.barcodes.first;
        final String? code = barcode.rawValue;
        if (code != null) {
          _controller.stop();
          final model = await Model.create(name: code);
          model.exists().then((value) {
            if (!value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Model not found'),
                  backgroundColor: Colors.red,
                ),
              );
              _restartScanner();
            } else {
              _showConfirmationDialog(context, model);
            }
          });
        }
      }
    );   
  }
}