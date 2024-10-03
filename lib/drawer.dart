import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({required this.child, required this.drawer, super.key});
  final Widget child;
  final Widget drawer;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _xControllerForChild;
  late Animation<double> _yRotationAnimationForChild;

  late AnimationController _xControllerForDrawer;
  late Animation<double> _yRotationAnimationForDrawer;

  @override
  void initState() {
    super.initState();
    _xControllerForChild = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    _yRotationAnimationForChild = Tween<double>(
      begin: 0,
      end: -pi / 2,
    ).animate(_xControllerForChild);

    _xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    _yRotationAnimationForChild = Tween<double>(
      begin: pi / 2,
      end: 0,
    ).animate(_xControllerForDrawer);
  }

  @override
  void dispose() {
    _xControllerForChild.dispose();
    _xControllerForDrawer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.8;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _xControllerForChild += details.delta.dx / maxDrag;
        _xControllerForDrawer += details.delta.dx / maxDrag;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerForChild.value < 0.5) {
          _xControllerForChild.reverse();
          _xControllerForDrawer.reverse();
        } else {
          _xControllerForChild.forward();
          _xControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
          [
            _xControllerForChild,
            _xControllerForDrawer,
          ],
        ),
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: const Color.fromARGB(255, 80, 71, 71),
              ),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(
                    _xControllerForChild.value * maxDrag,
                  )
                  ..rotateY(_yRotationAnimationForChild.value),
                child: widget.child,
              ),
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..transform(
                    (-screenWidth + _xControllerForDrawer.value * maxDrag)
                        as Vector4,
                  )
                  ..rotateY(
                    _yRotationAnimationForDrawer.value,
                  ),
                child: widget.drawer,
              ),
            ],
          );
        },
      ),
    );
  }
}
