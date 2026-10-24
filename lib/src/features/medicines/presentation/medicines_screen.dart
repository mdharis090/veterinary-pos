import 'package:flutter/material.dart';

import '../data/medicines_api.dart';
import 'add_medicine_dialog.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  int _refreshKey = 0;

  Future<void> _addMedicine() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddMedicineDialog(),
    );
    if (created == true && mounted) {
      setState(() => _refreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Medicines',
    action: ClinicPrimaryButton(
      label: 'Add medicine',
      icon: Icons.add,
      onPressed: _addMedicine,
    ),
    child: ApiClinicTable(
      key: ValueKey(_refreshKey),
      title: 'Medicines',
      columns: const [
        'ID',
        'Name',
        'Category',
        'Manufacturer',
        'Unit',
        'Stock',
        'Reorder at',
        'Sale price',
        'Status',
      ],
      loadRows: MedicinesApi().list,
      mapRow: (medicine) {
        final stock = medicine['med_stock'];
        final reorder = medicine['med_reorder_level'];
        final status = stock is num && reorder is num
            ? stock <= 0
                  ? 'Out of stock'
                  : stock <= reorder
                  ? 'Low stock'
                  : 'In stock'
            : '—';
        return [
          apiCell(medicine, 'medicine_id'),
          apiCell(medicine, 'med_name'),
          apiCell(medicine, 'med_category'),
          apiCell(medicine, 'med_manufacturer'),
          apiCell(medicine, 'med_unit'),
          apiCell(medicine, 'med_stock'),
          apiCell(medicine, 'med_reorder_level'),
          'Rs ${apiCell(medicine, 'med_sale_price')}',
          status,
        ];
      },
    ),
  );
}
