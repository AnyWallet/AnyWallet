import 'package:foss_wallet/generated/i18n.dart';
import 'package:foss_wallet/core/validator.dart';

class ContactNameValidator extends TextValidator {
  ContactNameValidator()
      : super(
            errorMessage: S.current.error_text_contact_name,
            pattern: '''[^`,'"]''',
            minLength: 1,
            maxLength: 32);
}
