import 'package:flutter/material.dart';

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Puntos de corte (Breakpoints)
        final double width = constraints.maxWidth;
        
        double maxWidth;
        EdgeInsets dynamicPadding;

        if (width >= 1024) {
          // --- PANTALLA WEB / ESCRITORIO ---
          maxWidth = 750.0;
          dynamicPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 32.0);
        } else if (width >= 600) {
          // --- PANTALLA TABLET ---
          maxWidth = 580.0;
          dynamicPadding = const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0);
        } else {
          // --- PANTALLA MÓVIL ---
          maxWidth = double.infinity;
          dynamicPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: padding ?? dynamicPadding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}