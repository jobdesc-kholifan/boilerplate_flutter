import 'package:boilerplate/styles/theme_datatables_styles.dart';
import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:flutter/material.dart';

typedef CustomizeHeaderDatatable = Widget Function(BsDatatableElement _);

class CustomDatabales extends BsDatatable {
  CustomDatabales({
    required BsDatatableSource source,
    required List<BsDataColumn> columns,
    CustomizeHeaderDatatable? customizeLeftHeader,
    CustomizeHeaderDatatable? customizeRightHeader,
    List<Widget> headerActions = const [],
    BsDatatableServerSide? serverSide,
  }) : super(
          source: source,
          columns: columns,
          serverSide: serverSide,
          style: BsDatatableStyle(borderColor: Colors.transparent),
          customizeLayout: (el) => Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: customizeLeftHeader == null
                            ? null
                            : customizeLeftHeader(el),
                      ),
                      Container(
                        child: customizeRightHeader == null
                            ? Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Row(children: headerActions),
                                  ),
                                  el.searchForm(
                                    decoration:
                                        ThemeDatatablesStyles.searchDecoration,
                                    inputDecoration: ThemeDatatablesStyles
                                        .searchInputDecoration,
                                    builderLabel: null,
                                  ),
                                ],
                              )
                            : customizeRightHeader(el),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: el.table(),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      el.informationData(),
                      el.pagination(),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
}
