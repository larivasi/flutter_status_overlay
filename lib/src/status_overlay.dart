import 'package:flutter/material.dart';
import 'dart:async';

enum StatusType { error, success }

class StatusOverlay extends StatefulWidget {
  final String title;
  final String message;
  final StatusType type;
  final Duration displayDuration;

  const StatusOverlay({
    Key? key,
    required this.title,
    required this.message,
    required this.type,
    this.displayDuration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  StatusOverlayState createState() => StatusOverlayState();

  static void show(
      BuildContext context, {
        required String title,
        required String message,
        required StatusType type,
        Duration duration = const Duration(seconds: 5),
      }) {
    final overlay = StatusOverlay(
      title: title,
      message: message,
      type: type,
      displayDuration: duration,
    );

    final overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => overlay,
    );

    overlayState.insert(overlayEntry);
  }
}

class StatusOverlayState extends State<StatusOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  Timer? _dismissTimer;
  OverlayEntry? _overlayEntry;

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      _startDismissTimer();
    });
  }

  void _startDismissTimer() {
    _dismissTimer = Timer(widget.displayDuration, () {
      _controller.reverse().then((_) {
        if (mounted) {
          _removeOverlay();
        }
      });
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color _getOverlayColor() {
    switch (widget.type) {
      case StatusType.error:
        return Colors.red;
      case StatusType.success:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    _overlayEntry ??= OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                _dismissTimer?.cancel();
                _controller.reverse().then((_) => _removeOverlay());
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Material(
                  color: _getOverlayColor(),
                  child: SafeArea(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Overlay(
      initialEntries: [_overlayEntry!],
    );
  }
}
