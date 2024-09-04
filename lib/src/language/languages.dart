import 'package:get/get.dart';
import 'available_languages/en_us.dart';
import 'available_languages/fr_fr.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': EnLanguage().language,
        'fr_FR': FrLanguage().language,
      };
}
