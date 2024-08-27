import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeWidget extends StatelessWidget {
  final String title;
  final double value;
  final double minValue;
  final double maxValue;
  final Color color;

  const GaugeWidget({
    super.key,
    required this.title,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.deepPurple),
        ),
        SizedBox(
          height: 150,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: minValue,
                maximum: maxValue,
                showLabels: false,
                showTicks: false,
                axisLineStyle: AxisLineStyle(
                  thickness: 0.15,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: color.withOpacity(0.3),
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: value,
                    width: 0.15,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: color,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      '${value.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
