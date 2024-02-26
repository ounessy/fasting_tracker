import 'package:fasting_tracker/components/home_page/main_controller.dart';
import 'package:fasting_tracker/components/utils/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class HistoryGrid extends StatefulWidget {
  final MainController mainController;

  HistoryGrid({super.key, required this.mainController});

  @override
  State<HistoryGrid> createState() => _HistoryGridState();
}

class _HistoryGridState extends State<HistoryGrid> {
  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  @override
  void initState() {
    super.initState();
    columns.addAll([
      PlutoColumn(
        title: 'Start',
        field: 'start',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'End',
        field: 'end',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Duration',
        field: 'duration',
        type: PlutoColumnType.number(),
        readOnly: true,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: widget.mainController.historyProvider.readHistory(),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: _getgrid(snapshot.data));
              })),
        ),
      ],
    );
  }

  Widget _getgrid(List<HistoryModel>? history) {
    List<PlutoRow> rows = history != null
        ? history
            .map((e) => PlutoRow(cells: {
                  "start": PlutoCell(value: e.startTime),
                  "end": PlutoCell(value: e.endTime),
                  "duration": PlutoCell(value: e.duration),
                }))
            .toList()
        : [];

    return PlutoGrid(
      columns: columns,
      rows: rows,
    );
  }
}
