import 'package:foss_wallet/core/execution_state.dart';

class AuthenticationBanned extends ExecutionState {
  AuthenticationBanned({required this.error});

  final String error;
}

