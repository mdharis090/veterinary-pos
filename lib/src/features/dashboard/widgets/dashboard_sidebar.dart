import 'package:flutter/material.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.items,
    required this.icons,
    required this.selectedItem,
    required this.onSelected,
    super.key,
  });

  final List<String> items;
  final List<IconData> icons;
  final String selectedItem;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE8EDF0))),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Color(0xFF128078),
                  child: Icon(Icons.pets, color: Colors.white, size: 13),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vetnaly',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF17283F),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Veterinary POS',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF758399),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedItem;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Material(
                    color: isSelected
                        ? const Color(0xFFCCF8F0)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => onSelected(item),
                      child: SizedBox(
                        height: 27,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Icon(
                                icons[index],
                                size: 13,
                                color: isSelected
                                    ? const Color(0xFF128078)
                                    : const Color(0xFF718096),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF087B73)
                                        : const Color(0xFF52627A),
                                    fontSize: 9,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
