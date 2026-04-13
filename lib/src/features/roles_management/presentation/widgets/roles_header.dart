import 'package:dashboard/src/common/bloc/data/data_bloc.dart';
import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/common/widgets/buttons/custom_button_v2.dart';
import 'package:dashboard/src/common/widgets/text_field/text_field_search_generic.dart';
import 'package:dashboard/src/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolesHeader extends StatelessWidget {
  const RolesHeader({required this.onRegister, super.key});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.defaultHorizontal,
        vertical: AppDimens.p20,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFieldSearchGeneric(
              hintText: 'Buscar roles',
              minCharsForSearch: 2,
              callback: (value) {
                context.read<DataBloc<List<RoleModel>>>().add(
                  DataFetchEvent(
                    params: {if (value.isNotEmpty) 'search': value},
                  ),
                );
              },
            ),
          ),
          if (!Responsive.isMobile(context)) ...[
            const SizedBox(width: 16),
            CustomButtonV2(text: 'Nuevo rol', onPressed: onRegister),
          ],
        ],
      ),
    );
  }
}
