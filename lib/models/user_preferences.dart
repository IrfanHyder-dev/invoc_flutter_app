import 'package:invoc/v3/auth/constants/strings.dart';

enum UserPreferencesVariable {
  VEGAN,
  VEGETARIAN,
  GLUTEN_FREE,
  ORGANIC_LABELS,
  FAIR_TRADE_LABELS,
  PALM_FREE_LABELS,
  ADDITIVES,
  NOVA_GROUP,
  NUTRI_SCORE
}

extension UserPreferencesVariableExtension on UserPreferencesVariable {
  String get name {
    switch (this) {
      case UserPreferencesVariable.VEGAN:
        return 'Vegan';
        break;
      case UserPreferencesVariable.VEGETARIAN:
        return 'Vegetarian';
        break;
      case UserPreferencesVariable.GLUTEN_FREE:
        return 'Gluten Free';
        break;
      case UserPreferencesVariable.ORGANIC_LABELS:
        return 'Organic';
        break;
      case UserPreferencesVariable.FAIR_TRADE_LABELS:
        return 'Fair trade';
        break;
      case UserPreferencesVariable.PALM_FREE_LABELS:
        return 'Palm Oil free ';
        break;
      case UserPreferencesVariable.ADDITIVES:
        return 'Additives';
        break;
      case UserPreferencesVariable.NOVA_GROUP:
        return 'NOVA Group';
        break;
      case UserPreferencesVariable.NUTRI_SCORE:
        return 'Nutri-Score';
        break;
      default:
        return 'Accountable variables';
        break;
    }
  }

  String get icon{
    switch(this){
      case UserPreferencesVariable.VEGAN:
        return 'assets/icons/vegan.svg';
        break;
      case UserPreferencesVariable.VEGETARIAN:
        return 'assets/icons/organic.svg';
        break;
      case UserPreferencesVariable.GLUTEN_FREE:
        return 'assets/icons/gluteen_free.svg';
        break;
      case UserPreferencesVariable.ORGANIC_LABELS:
        return 'assets/icons/organic.svg';
        break;
      case UserPreferencesVariable.FAIR_TRADE_LABELS:
        return 'assets/icons/fair_trade.svg';
        break;
      case UserPreferencesVariable.PALM_FREE_LABELS:
        return 'assets/icons/palm_oil.svg';
        break;
      case UserPreferencesVariable.ADDITIVES:
        return 'assets/icons/additive.svg';
        break;
      case UserPreferencesVariable.NOVA_GROUP:
        return 'assets/icons/nova_group.svg';
        break;
      case UserPreferencesVariable.NUTRI_SCORE:
        return 'assets/icons/nutri_score.svg';
        break;
      default:
        return 'Accountable variables';
        break;
    }
    }


  static List<UserPreferencesVariable> getMandatoryVariables() {
    return <UserPreferencesVariable>[
      UserPreferencesVariable.VEGAN,
      UserPreferencesVariable.VEGETARIAN,
      //UserPreferencesVariable.GLUTEN_FREE
    ];
  }

  static List<UserPreferencesVariable> getAccountableVariables() {
    return <UserPreferencesVariable>[
      UserPreferencesVariable.ORGANIC_LABELS,
      UserPreferencesVariable.FAIR_TRADE_LABELS,
      UserPreferencesVariable.PALM_FREE_LABELS,
      UserPreferencesVariable.ADDITIVES,
      UserPreferencesVariable.NOVA_GROUP,
      UserPreferencesVariable.NUTRI_SCORE
    ];
  }
}



class UserPreferences {

  UserPreferences() {
    for(final UserPreferencesVariable variable in UserPreferencesVariable.values) {
      setVariable(variable, false);
    }
  }

  UserPreferences.filled(Map<String, dynamic> data) {
    loadJson(data);
  }

  // Mandatory
  bool _vegan = false;
  bool _vegetarian = false;
  bool _glutenFree = false;

  // Accountable
  bool _organicLabels = false;
  bool _fairTradeLabels = false;
  bool _palmFreeLabels = false;
  bool _additives = false;
  bool _novaGroup = false;
  bool _nutriScore = false;

  void setVariable(UserPreferencesVariable variable, bool value) {
    switch(variable) {
      case UserPreferencesVariable.VEGAN:
        _vegan = value;
        break;
      case UserPreferencesVariable.VEGETARIAN:
        _vegetarian = value;
        break;
      case UserPreferencesVariable.GLUTEN_FREE:
        _glutenFree = value;
        break;
      case UserPreferencesVariable.ORGANIC_LABELS:
        _organicLabels = value;
        break;
      case UserPreferencesVariable.FAIR_TRADE_LABELS:
        _fairTradeLabels = value;
        break;
      case UserPreferencesVariable.PALM_FREE_LABELS:
        _palmFreeLabels = value;
        break;
      case UserPreferencesVariable.ADDITIVES:
        _additives = value;
        break;
      case UserPreferencesVariable.NOVA_GROUP:
        _novaGroup = value;
        break;
      case UserPreferencesVariable.NUTRI_SCORE:
        _nutriScore = value;
        break;
    }
  }

  bool getVariable(UserPreferencesVariable variable) {
    switch(variable) {
      case UserPreferencesVariable.VEGAN:
        return _vegan;
        break;
      case UserPreferencesVariable.VEGETARIAN:
        return _vegetarian;
        break;
      case UserPreferencesVariable.GLUTEN_FREE:
        return _glutenFree;
        break;
      case UserPreferencesVariable.ORGANIC_LABELS:
        return _organicLabels;
        break;
      case UserPreferencesVariable.FAIR_TRADE_LABELS:
        return _fairTradeLabels;
        break;
      case UserPreferencesVariable.PALM_FREE_LABELS:
        return _palmFreeLabels;
        break;
      case UserPreferencesVariable.ADDITIVES:
        return _additives;
        break;
      case UserPreferencesVariable.NOVA_GROUP:
        return _novaGroup;
        break;
      case UserPreferencesVariable.NUTRI_SCORE:
        return _nutriScore;
        break;
      default:
        return false;
        break;
    }
  }

  List<UserPreferencesVariable> getActiveVariables() {
    final List<UserPreferencesVariable> result = <UserPreferencesVariable>[];
    for(final UserPreferencesVariable variable in UserPreferencesVariable.values) {
      if(getVariable(variable)) {
        result.add(variable);
      }
    }
    return result;
  }

  void loadJson(Map<String, dynamic> data) {
    for(final UserPreferencesVariable variable in UserPreferencesVariable.values) {
      setVariable(variable, data[variable.name] as bool ?? false);
    }
  }

  Map<String, bool> toJson() {
    final Map<String, bool> result = <String, bool>{};

    for(final UserPreferencesVariable variable in UserPreferencesVariable.values) {
      result[variable.name] = getVariable(variable);
    }

    return result;
  }
}