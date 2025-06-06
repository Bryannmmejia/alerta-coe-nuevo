import 'dart:convert';

import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/views/reports/CitizenReportsPage.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  ReportPageState createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  var _http = HttpRequestHelper();
  var app = ApplicationDefault();
  bool isBusy = true;
  List<List<String>> items = [
    ["", "", "", ""]
  ];

  final _fixedRowCells = [
    "Titulo",
    "Fecha",
    "Mensaje",
    "Estado",
  ];

  @override
  void initState() {
    super.initState();
    this.init();
  }

  init() async {
    try {
      var response = await _http.getRequest("apim/report",
          {"username": GlobalState.getInstance().logonResult.username},
          token: GlobalState.getInstance().logonResult.token);
      var _result = HttpResponseModel.fromJson(json.decode(response!.body));
      items = [];
      for (int x = 0; x < _result.data.length; x++) {
        var item = _result.data[x];
        items.add([
          item["title"],
          item["formattedDate"],
          item["message"],
          item["state"],
        ]);
      }
      if (this.mounted) {
        setState(() {
          isBusy = false;
          items = items;
        });
      }
    } catch (e) {
      isBusy = false;
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isBusy
          ? Center(
              child: Visibility(
                maintainSize: false,
                maintainAnimation: false,
                maintainState: false,
                visible: isBusy,
                child: Container(
                  margin: EdgeInsets.only(top: 50, bottom: 30),
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : items.length <= 0 ? Center(child: Text("NO CONTIENE NINGUN REPORTE"),) : CustomDataTable(
              rowsCells: items,
              //fixedColCells: _fixedColCells,
              fixedRowCells: _fixedRowCells,
              cellBuilder: (data) {
                return InkWell(
                  onTap: () => {print(data)},
                  child: Text('$data', style: TextStyle(color: Colors.black)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          app.navigateToWithWidget(
              context, "Nuevo Reporte", CitizenReportsPage())
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: Colors.lightBlue,
        tooltip: 'Nuevo Reporte',
        elevation: 5,
        splashColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class CustomDataTable<T> extends StatefulWidget {
  final T? fixedCornerCell;
  final List<T>? fixedColCells;
  final List<T>? fixedRowCells;
  final List<List<T>> rowsCells;
  final Widget Function(T data) cellBuilder;
  final double fixedColWidth;
  final double cellWidth;
  final double cellHeight;
  final double cellMargin;
  final double cellSpacing;

  CustomDataTable({
    this.fixedCornerCell,
    this.fixedColCells,
    this.fixedRowCells,
    required this.rowsCells,
    required this.cellBuilder,
    this.fixedColWidth = 60.0,
    this.cellHeight = 56.0,
    this.cellWidth = 120.0,
    this.cellMargin = 10.0,
    this.cellSpacing = 10.0,
  });

  @override
  State<StatefulWidget> createState() => CustomDataTableState();
}

class CustomDataTableState<T> extends State<CustomDataTable<T>> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  final _subTableYController = ScrollController();
  final _subTableXController = ScrollController();

  Widget _buildChild(double width, T data) => SizedBox(
      width: width, child: widget.cellBuilder.call(data));

  Widget _buildFixedCol() => widget.fixedColCells == null
      ? SizedBox.shrink()
      : Material(
          color: Colors.lightBlueAccent,
          child: DataTable(
              horizontalMargin: widget.cellMargin,
              columnSpacing: widget.cellSpacing,
              headingRowHeight: widget.cellHeight,
              // ignore: deprecated_member_use
              dataRowHeight: widget.cellHeight,
              columns: [
                DataColumn(
                    label: _buildChild(
                        widget.fixedColWidth, widget.fixedColCells?.first as T))
              ],
              rows: (widget.fixedColCells
                  ?.sublist(widget.fixedRowCells == null ? 1 : 0)
                  .map((c) => DataRow(
                      cells: [DataCell(_buildChild(widget.fixedColWidth, c))]))
                  .toList()) ?? []),
        );

  Widget _buildFixedRow() => widget.fixedRowCells == null
      ? SizedBox.shrink()
      : Material(
          color: Colors.grey,
          child: DataTable(
              horizontalMargin: widget.cellMargin,
              columnSpacing: widget.cellSpacing,
              headingRowHeight: widget.cellHeight,
              // ignore: deprecated_member_use
              dataRowHeight: widget.cellHeight,
              columns: widget.fixedRowCells?.map((c) =>
                      DataColumn(label: _buildChild(widget.cellWidth, c)))
                  .toList() ?? [],
              rows: []),
        );

  Widget _buildSubTable() => Material(
      color: Colors.white,
      child: DataTable(
          horizontalMargin: widget.cellMargin,
          columnSpacing: widget.cellSpacing,
          headingRowHeight: widget.cellHeight,
          // ignore: deprecated_member_use
          dataRowHeight: widget.cellHeight,
          columns: widget.rowsCells.first
              .map((c) => DataColumn(label: _buildChild(widget.cellWidth, c)))
              .toList(),
          rows: widget.rowsCells
              .sublist(widget.fixedRowCells == null ? 1 : 0)
              .map((row) => DataRow(
                  cells: row
                      .map((c) => DataCell(_buildChild(widget.cellWidth, c)))
                      .toList()))
              .toList()));

  Widget _buildCornerCell() =>
      widget.fixedColCells == null || widget.fixedRowCells == null
          ? SizedBox.shrink()
          : Material(
              color: Colors.amberAccent,
              child: DataTable(
                  horizontalMargin: widget.cellMargin,
                  columnSpacing: widget.cellSpacing,
                  headingRowHeight: widget.cellHeight,
                  // ignore: deprecated_member_use
                  dataRowHeight: widget.cellHeight,
                  columns: [
                    DataColumn(
                        label: _buildChild(
                            widget.fixedColWidth, widget.fixedCornerCell as T))
                  ],
                  rows: []),
            );

  @override
  void initState() {
    super.initState();
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
    _subTableYController.addListener(() {
      _columnController.jumpTo(_subTableYController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            SingleChildScrollView(
              controller: _columnController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              child: _buildFixedCol(),
            ),
            Flexible(
              child: SingleChildScrollView(
                controller: _subTableXController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: _subTableYController,
                  scrollDirection: Axis.vertical,
                  child: _buildSubTable(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildCornerCell(),
            Flexible(
              child: SingleChildScrollView(
                controller: _rowController,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: _buildFixedRow(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
