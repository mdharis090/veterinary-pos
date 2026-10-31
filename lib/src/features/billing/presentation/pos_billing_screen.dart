import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../medicines/data/medicines_api.dart';
import '../../owners/data/owners_api.dart';
import '../../patients/data/animals_api.dart';
import '../../sales/data/sales_api.dart';
import '../../shared/presentation/clinic_ui.dart';

class PosBillingScreen extends StatefulWidget {
  const PosBillingScreen({
    this.ownersApi,
    this.animalsApi,
    this.medicinesApi,
    this.salesApi,
    super.key,
  });

  final OwnersApi? ownersApi;
  final AnimalsApi? animalsApi;
  final MedicinesApi? medicinesApi;
  final SalesApi? salesApi;

  @override
  State<PosBillingScreen> createState() => _PosBillingScreenState();
}

class _PosBillingScreenState extends State<PosBillingScreen> {
  final _searchController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final Map<int, _CartItem> _cart = {};

  List<JsonMap> _owners = [];
  List<JsonMap> _animals = [];
  List<JsonMap> _medicines = [];
  int? _ownerId;
  int? _animalId;
  int _ownerRequest = 0;
  String _paymentMethod = 'Cash';
  String? _error;
  bool _loading = true;
  bool _animalsLoading = false;
  bool _saving = false;

  double get _subtotal =>
      _cart.values.fold(0, (total, item) => total + item.price * item.quantity);

  double get _discount {
    final value = double.tryParse(_discountController.text);
    return value != null && value.isFinite ? value : 0;
  }

  double get _total => _subtotal - _discount;
  int get _itemCount =>
      _cart.values.fold(0, (total, item) => total + item.quantity);

  OwnersApi get _ownersApi => widget.ownersApi ?? OwnersApi();
  AnimalsApi get _animalsApi => widget.animalsApi ?? AnimalsApi();
  MedicinesApi get _medicinesApi => widget.medicinesApi ?? MedicinesApi();
  SalesApi get _salesApi => widget.salesApi ?? SalesApi();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _ownersApi.list(),
        _medicinesApi.list(),
      ]);
      final owners = results[0];
      final medicines = results[1];
      final ownerId = _firstId(owners, 'owner_id');
      final animals = ownerId == null
          ? <JsonMap>[]
          : await _animalsApi.listByOwner(ownerId);
      if (!mounted) return;
      setState(() {
        _owners = owners;
        _medicines = medicines;
        _ownerId = ownerId;
        _animals = animals;
        _animalId = _firstId(animals, 'animal_id');
        _loading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _loading = false;
      });
    }
  }

  Future<void> _selectOwner(int? ownerId) async {
    if (ownerId == null) return;
    final request = ++_ownerRequest;
    setState(() {
      _ownerId = ownerId;
      _animalId = null;
      _animals = [];
      _animalsLoading = true;
      _error = null;
    });
    try {
      final animals = await _animalsApi.listByOwner(ownerId);
      if (!mounted || request != _ownerRequest) return;
      setState(() {
        _animals = animals;
        _animalId = _firstId(animals, 'animal_id');
        _animalsLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted || request != _ownerRequest) return;
      setState(() {
        _error = error.message;
        _animalsLoading = false;
      });
    }
  }

  void _addMedicine(JsonMap medicine) {
    final id = _idFrom(medicine['medicine_id']);
    final price = _numberFrom(medicine['med_sale_price']);
    final stock = _numberFrom(medicine['med_stock']);
    final name = _medicineName(medicine);
    if (id == null || price == null || stock == null || stock < 1) return;

    final existing = _cart[id];
    if (existing != null && existing.quantity >= stock) {
      showClinicNotice(context, 'There is not enough stock for $name.');
      return;
    }
    setState(() {
      if (existing == null) {
        _cart[id] = _CartItem(id: id, name: name, price: price, stock: stock);
      } else {
        existing.quantity++;
      }
    });
  }

  void _removeOne(int medicineId) {
    final item = _cart[medicineId];
    if (item == null) return;
    setState(() {
      if (item.quantity <= 1) {
        _cart.remove(medicineId);
      } else {
        item.quantity--;
      }
    });
  }

  Future<void> _completeSale() async {
    final ownerId = _ownerId;
    final animalId = _animalId;
    final discount = double.tryParse(_discountController.text);
    if (ownerId == null) {
      showClinicNotice(context, 'Select an owner before completing the sale.');
      return;
    }
    if (animalId == null) {
      showClinicNotice(context, 'Select an animal before completing the sale.');
      return;
    }
    if (_cart.isEmpty) {
      showClinicNotice(context, 'Add at least one medicine to the cart.');
      return;
    }
    if (discount == null ||
        !discount.isFinite ||
        discount < 0 ||
        discount > _subtotal) {
      showClinicNotice(
        context,
        'Enter a valid discount no greater than the subtotal.',
      );
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final result = await _salesApi.create({
        'owner_id': ownerId,
        'animal_id': animalId,
        'sal_payment_method': _paymentMethod,
        'sal_discount': discount,
        'items': [
          for (final item in _cart.values)
            {
              'medicine_id': item.id,
              'si_qty': item.quantity,
              'si_price': item.price,
            },
        ],
      });
      if (!mounted) return;
      final saleId = result['sale_id'];
      setState(() {
        _cart.clear();
        _discountController.text = '0';
        _saving = false;
      });
      showClinicNotice(
        context,
        saleId == null
            ? 'Sale completed successfully.'
            : 'Sale #$saleId completed.',
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'POS Billing',
    subtitle: 'Select a customer, add medicines, then complete checkout.',
    child: _loading
        ? const ClinicPanel(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Loading owners, animals, and medicines...'),
            ),
          )
        : _error != null && _owners.isEmpty && _medicines.isEmpty
        ? ClinicPanel(
            title: 'Unable to load POS data',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_error!, style: const TextStyle(color: Color(0xFFB91C1C))),
                const SizedBox(height: 12),
                ClinicOutlineButton(
                  label: 'Retry',
                  icon: Icons.refresh,
                  onPressed: _loadData,
                ),
              ],
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;
              final products = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _customerPanel(),
                  const SizedBox(height: 14),
                  _medicinesPanel(),
                ],
              );
              final checkout = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _cartPanel(),
                  const SizedBox(height: 14),
                  _paymentPanel(),
                  const SizedBox(height: 12),
                  ClinicPrimaryButton(
                    label: 'Complete sale',
                    loading: _saving,
                    onPressed: _saving || _cart.isEmpty ? null : _completeSale,
                  ),
                ],
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_error != null) ...[
                    _errorBanner(_error!),
                    const SizedBox(height: 12),
                  ],
                  if (desktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 11, child: products),
                        const SizedBox(width: 18),
                        Expanded(flex: 9, child: checkout),
                      ],
                    )
                  else ...[
                    products,
                    const SizedBox(height: 14),
                    checkout,
                  ],
                ],
              );
            },
          ),
  );

  Widget _customerPanel() => ClinicPanel(
    title: 'Customer',
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(width: 220, child: _ownerDropdown()),
        SizedBox(width: 220, child: _animalDropdown()),
      ],
    ),
  );

  Widget _ownerDropdown() {
    final validIds = _owners
        .map((owner) => _idFrom(owner['owner_id']))
        .whereType<int>()
        .toSet();
    return DropdownButtonFormField<int>(
      initialValue: validIds.contains(_ownerId) ? _ownerId : null,
      decoration: _dropdownDecoration('Owner'),
      items: [
        for (final owner in _owners)
          if (_idFrom(owner['owner_id']) case final int id)
            DropdownMenuItem(
              value: id,
              child: Text(
                '${owner['ow_name'] ?? owner['owner_name'] ?? 'Owner'}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
      ],
      onChanged: _saving ? null : _selectOwner,
    );
  }

  Widget _animalDropdown() {
    final validIds = _animals
        .map((animal) => _idFrom(animal['animal_id']))
        .whereType<int>()
        .toSet();
    return DropdownButtonFormField<int>(
      initialValue: validIds.contains(_animalId) ? _animalId : null,
      decoration: _dropdownDecoration(
        _animalsLoading
            ? 'Loading animals...'
            : _animals.isEmpty
            ? 'No animals for owner'
            : 'Animal',
      ),
      items: [
        for (final animal in _animals)
          if (_idFrom(animal['animal_id']) case final int id)
            DropdownMenuItem(
              value: id,
              child: Text(
                '${animal['an_name'] ?? animal['animal_name'] ?? 'Animal'}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
      ],
      onChanged: _saving || _animalsLoading || _animals.isEmpty
          ? null
          : (value) => setState(() => _animalId = value),
    );
  }

  Widget _medicinesPanel() {
    final query = _searchController.text.trim().toLowerCase();
    final medicines = _medicines
        .where((medicine) {
          final name = _medicineName(medicine).toLowerCase();
          final id = medicine['medicine_id']?.toString() ?? '';
          return query.isEmpty || name.contains(query) || id.contains(query);
        })
        .toList(growable: false);

    return ClinicPanel(
      title: 'Medicines',
      child: Column(
        children: [
          ClinicSearchField(
            hint: 'Search medicine or scan barcode',
            controller: _searchController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          if (medicines.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No medicines available.'),
            )
          else
            for (final medicine in medicines)
              _MedicineRow(
                name: _medicineName(medicine),
                stock: _numberFrom(medicine['med_stock']) ?? 0,
                price: _numberFrom(medicine['med_sale_price']) ?? 0,
                onAdd:
                    _idFrom(medicine['medicine_id']) == null ||
                        (_numberFrom(medicine['med_stock']) ?? 0) < 1 ||
                        _numberFrom(medicine['med_sale_price']) == null ||
                        _saving
                    ? null
                    : () => _addMedicine(medicine),
              ),
        ],
      ),
    );
  }

  Widget _cartPanel() => ClinicPanel(
    title: 'Cart',
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$_itemCount items'),
        if (_cart.isNotEmpty)
          IconButton(
            tooltip: 'Clear cart',
            onPressed: _saving ? null : () => setState(_cart.clear),
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    ),
    child: Column(
      children: [
        if (_cart.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Center(child: Text('Your cart is empty. Add a medicine.')),
          )
        else
          for (final item in _cart.values)
            _CartRow(
              item: item,
              onRemove: _saving ? null : () => _removeOne(item.id),
              onAdd: _saving ? null : () => _increaseItem(item),
            ),
        const Divider(),
        ClinicPriceLine(label: 'Subtotal', amount: _subtotal),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(child: Text('Discount')),
            SizedBox(
              width: 120,
              child: TextField(
                controller: _discountController,
                enabled: !_saving,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  prefixText: 'Rs ',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClinicPriceLine(
          label: 'Total',
          amount: _total.clamp(0, double.infinity),
          large: true,
          color: clinicTeal,
        ),
      ],
    ),
  );

  void _increaseItem(_CartItem item) {
    if (item.quantity >= item.stock) {
      showClinicNotice(context, 'There is not enough stock for ${item.name}.');
      return;
    }
    setState(() => item.quantity++);
  }

  Widget _paymentPanel() => ClinicPanel(
    title: 'Payment',
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final method in const ['Cash', 'Card', 'Online'])
          ChoiceChip(
            label: Text(method),
            selected: _paymentMethod == method,
            onSelected: _saving
                ? null
                : (selected) {
                    if (selected) setState(() => _paymentMethod = method);
                  },
          ),
      ],
    ),
  );

  Widget _errorBanner(String message) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFEF2F2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(message, style: const TextStyle(color: Color(0xFFB91C1C))),
  );

  InputDecoration _dropdownDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  String _medicineName(JsonMap medicine) =>
      '${medicine['med_name'] ?? medicine['medicine_name'] ?? 'Medicine'}';

  int? _idFrom(Object? value) {
    if (value is int) return value;
    if (value is num && value == value.toInt()) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  int? _firstId(List<JsonMap> records, String key) {
    for (final record in records) {
      final id = _idFrom(record[key]);
      if (id != null) return id;
    }
    return null;
  }

  double? _numberFrom(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}

class _CartItem {
  _CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  final int id;
  final String name;
  final double price;
  final double stock;
  int quantity = 1;
}

class _MedicineRow extends StatelessWidget {
  const _MedicineRow({
    required this.name,
    required this.stock,
    required this.price,
    required this.onAdd,
  });

  final String name;
  final double stock;
  final double price;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: clinicLine)),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFCCFBF1),
          child: Icon(Icons.medication_outlined, color: clinicTeal, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: clinicInk,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${stock.toStringAsFixed(stock.truncateToDouble() == stock ? 0 : 1)} in stock',
                style: const TextStyle(color: clinicMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        Text('Rs ${price.toStringAsFixed(2)}'),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: onAdd,
          tooltip: 'Add $name',
          icon: const Icon(Icons.add),
        ),
      ],
    ),
  );
}

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.item,
    required this.onRemove,
    required this.onAdd,
  });

  final _CartItem item;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(item.name)),
        IconButton(
          onPressed: onRemove,
          tooltip: 'Remove one',
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('${item.quantity}'),
        IconButton(
          onPressed: onAdd,
          tooltip: 'Add one',
          icon: const Icon(Icons.add_circle_outline),
        ),
        SizedBox(
          width: 90,
          child: Text(
            'Rs ${(item.price * item.quantity).toStringAsFixed(2)}',
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
