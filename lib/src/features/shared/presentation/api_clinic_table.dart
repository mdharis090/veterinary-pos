import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import 'clinic_ui.dart';

typedef ApiRowMapper = List<String> Function(JsonMap record);

class ApiClinicTable extends StatefulWidget {
  const ApiClinicTable({
    required this.title,
    required this.columns,
    required this.loadRows,
    required this.mapRow,
    this.footer,
    this.onRowTap,
    super.key,
  });

  final String title;
  final List<String> columns;
  final Future<List<JsonMap>> Function() loadRows;
  final ApiRowMapper mapRow;
  final String? footer;
  final ValueChanged<List<String>>? onRowTap;

  @override
  State<ApiClinicTable> createState() => _ApiClinicTableState();
}

class _ApiClinicTableState extends State<ApiClinicTable> {
  late Future<List<JsonMap>> _rows;

  @override
  void initState() {
    super.initState();
    _rows = widget.loadRows();
  }

  void _reload() => setState(() => _rows = widget.loadRows());

  @override
  Widget build(BuildContext context) => FutureBuilder<List<JsonMap>>(
    future: _rows,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return ClinicPanel(
          title: widget.title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Color(0xFFB91C1C)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      if (!snapshot.hasData) {
        return ClinicPanel(
          title: widget.title,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }
      return ClinicTable(
        title: widget.title,
        columns: widget.columns,
        rows: snapshot.data!.map(widget.mapRow).toList(growable: false),
        footer: widget.footer,
        onRowTap: widget.onRowTap,
      );
    },
  );
}

String apiCell(JsonMap record, String key) {
  final value = record[key];
  if (value == null || value.toString().isEmpty) return '—';
  return value.toString();
}
