import 'package:flutter/material.dart';

import '../data/medicines_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class MedicinesPage extends StatelessWidget {
  const MedicinesPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Medicines',
    action: ClinicPrimaryButton(
      label: 'Add medicine',
      icon: Icons.add,
      onPressed: () =>
          showClinicNotice(context, 'Medicine form is ready to complete.'),
    ),
    child: ApiClinicTable(
      title: 'Medicines',
      columns: const ['ID', 'Name', 'Stock', 'Price', 'Status'],
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
          apiCell(medicine, 'med_stock'),
          'Rs ${apiCell(medicine, 'med_sale_price')}',
          status,
        ];
      },
    ),
  );
}
