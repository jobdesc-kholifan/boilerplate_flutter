import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/base_text.dart';
import '../../constants/config_types.dart';
import '../../contracts/base/edit_view_contract.dart';
import '../../contracts/base/index_view_contract.dart';
import '../../services/masters/type_service.dart';
import '../../services/security/menu_service.dart';
import '../../utils/custom_get_controller.dart';
import '../../views/masters/menus/_menu_type.dart';
import '../../views/masters/menus/menu_form.dart';
import '../../widgets/confirm_dialog.dart';

class MenuPresenter extends CustomGetXController {
  final _menuService = Get.find<MenuService>();
  final _typeService = Get.put(TypeService());

  late IndexViewContract _menuViewContract;
  set menuViewContract(IndexViewContract menuViewContract) {
    _menuViewContract = menuViewContract;
  }

  late EditViewContract _menuFetchDataContract;
  set menuFetchDataContract(EditViewContract menuFetchDataContract) {
    _menuFetchDataContract = menuFetchDataContract;
  }

  late MenuTypeViewContract _menuTypeViewContract;
  set menuTypeViewContract(MenuTypeViewContract menuTypeViewContract) {
    _menuTypeViewContract = menuTypeViewContract;
  }

  Future datatables(BuildContext context, Map<String, String> params) async {
    Response response = await _menuService.datatables(params);
    if (response.statusCode == 200)
      _menuViewContract.onLoadDatatables(context, response);
    else
      _menuViewContract.onErrorRequest(response);
  }

  Future _loadType() async {
    Response response = await _typeService.byCode(ConfigType.menuType);
    if (response.statusCode == 200)
      _menuTypeViewContract.onLoadSuccess(response);
    else
      _menuViewContract.onErrorRequest(response);
  }

  void add(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => MenuFormView(
        onSave: (body) => save(context, body),
      ),
    );

    _loadType();
  }

  void save(BuildContext context, Map<String, dynamic> body) async {
    Response response = await _menuService.store(body);
    if (response.statusCode == 200)
      _menuViewContract.onCreateSuccess(response, context: context);
    else
      _menuViewContract.onErrorRequest(response);
  }

  void edit(BuildContext context, int menuid) async {
    setProcessing(true);
    showDialog(
      context: context,
      builder: (context) => MenuFormView(
        onSave: (body) => update(context, body, menuid),
      ),
    );

    await _loadType();

    Response response = await _menuService.show(menuid);
    if (response.statusCode == 200)
      _menuFetchDataContract.onSuccessFetchData(response);
    else
      _menuViewContract.onErrorRequest(response);
  }

  void update(
      BuildContext context, Map<String, dynamic> body, int menuid) async {
    setProcessing(true);
    Response response = await _menuService.update(menuid, body);
    if (response.statusCode == 200)
      _menuViewContract.onEditSuccess(response, context: context);
    else
      _menuViewContract.onErrorRequest(response);
  }

  void delete(BuildContext context, int menuid) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: BaseText.confirmTitle,
        message: BaseText.confirmMessage,
        onPressed: (_, value) async {
          if (value == ConfirmDialogOption.YES_OPTION) {
            Response response = await _menuService.destroy(menuid);
            if (response.statusCode == 200)
              _menuViewContract.onDeleteSuccess(response, context: context);
            else
              _menuViewContract.onErrorRequest(response);
          }
        },
      ),
    );
  }
}
