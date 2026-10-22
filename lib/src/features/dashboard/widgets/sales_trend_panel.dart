import 'package:flutter/material.dart';

class SalesTrendPanel extends StatelessWidget {
  const SalesTrendPanel({super.key});

  static const _values = [40.0, 60.0, 49.0, 77.0, 65.0, 91.0, 58.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
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
                                ? const Color(0xFF0F766E)
                                : const Color(0xFF99F6E4),
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
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Mon', style: TextStyle(color: Color(0xFF64748B))),
              Text('Tue', style: TextStyle(color: Color(0xFF64748B))),
              Text('Wed', style: TextStyle(color: Color(0xFF64748B))),
              Text('Thu', style: TextStyle(color: Color(0xFF64748B))),
              Text('Fri', style: TextStyle(color: Color(0xFF64748B))),
              Text('Sat', style: TextStyle(color: Color(0xFF64748B))),
              Text('Sun', style: TextStyle(color: Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }
}
