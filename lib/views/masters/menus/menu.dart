import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../contracts/base/index_view_contract.dart';
import '../../../presenters/masters/menu_presenter.dart';
import '../../../routes/route_list.dart';
import '../../../utils/handle_error_request.dart';
import '../../../widgets/breadcrumb.dart';
import '../../../widgets/button/theme_button_create.dart';
import '../../../widgets/datatables/custom_datatable.dart';
import '../../skins/tempalte.dart';

import '_datatable_source.dart';
import '_text.dart';

class MenuView extends StatelessWidget
    with IndexViewContract, HandleErrorRequest {
  final presenter = Get.find<MenuPresenter>();
  final datatable = MenuDataTableSource();

  MenuView() {
    presenter.menuViewContract = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplateView(
        title: 'Menus',
        breadcrumbs: [
          BreadcrumbWidget('Dashboard', route: RouteList.home.index),
          BreadcrumbWidget('Masters'),
          BreadcrumbWidget('Menus', active: true),
        ],
        activeRoutes: [RouteList.master.index, RouteList.masterMenu.index],
        child: Container(
          child: Column(
            children: [
              CustomDatabales(
                source: datatable,
                columns: datatable.columns,
                headerActions: [
                  ThemeButtonCreate(
                    prefix: MenuText.title,
                    onPressed: () => presenter.add(context),
                  )
                ],
                serverSide: (params) => presenter.datatables(context, params),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onCreateSuccess(Response response, {BuildContext? context}) {
    presenter.setProcessing(false);
    datatable.controller.reload();
    if (context != null) Navigator.pop(context);
  }

  @override
  void onDeleteSuccess(Response response, {BuildContext? context}) {
    presenter.setProcessing(false);
    datatable.controller.reload();
    if (context != null) Navigator.pop(context);
  }

  @override
  void onEditSuccess(Response response, {BuildContext? context}) {
    presenter.setProcessing(false);
    datatable.controller.reload();
    if (context != null) Navigator.pop(context);
  }

  @override
  void onLoadDatatables(BuildContext context, Response response) {
    presenter.setProcessing(false);
    datatable.response = BsDatatableResponse.createFromJson(response.body);
    datatable.onEditListener = (menuid) => presenter.edit(context, menuid);
    datatable.onDeleteListener = (menuid) => presenter.delete(context, menuid);
  }

  @override
  void onErrorRequest(Response response) {
    presenter.setProcessing(false);
    super.onErrorRequest(response);
  }
}
