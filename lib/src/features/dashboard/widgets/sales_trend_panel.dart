import 'package:flutter/material.dart';

class SalesTrendPanel extends StatelessWidget {
  const SalesTrendPanel({super.key});

  static const _values = [40.0, 60.0, 49.0, 77.0, 65.0, 91.0, 58.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE2E8ED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080E3550),
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales trend (7 days)',
            style: TextStyle(
              color: Color(0xFF17283F),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < _values.length; index++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == _values.length - 1 ? 0 : 4,
                      ),
                      child: FractionallySizedBox(
                        heightFactor: _values[index] / 100,
                        alignment: Alignment.bottomCenter,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: index == _values.length - 1
                                ? const Color(0xFF128078)
                                : const Color(0xFF91F0DD),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
