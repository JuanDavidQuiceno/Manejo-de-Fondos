import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/common/repositories/data_repository.dart';

/// Contrato para listar roles (ej. para selector de rol de usuario).
abstract class RoleListRepository implements DataRepository<List<RoleModel>> {}
