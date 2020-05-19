import 'dart:collection';

enum Keys {
  id,
  type,
  detailUrl,
  created_at,
  company,
  company_url,
  location,
  title,
  description,
  how_to_apply,
  company_logo,
  host_url,
  assets_path
}

class KeyMappingUtil {

  static HashMap<String, HashMap> getProviderMap() {
    //For external provider Key = ExternalProviderName; Value = hashmap with Host Url and required json keys
    HashMap providerMap = new HashMap<String, HashMap>();
    providerMap["GitHub"] = getDefaultResponseKeyMapping();

    //For local provider Key = LocalProviderName; Value = Hashmap with Assets Path and required json keys
    //For local provider make sure the key contains keyword 'Local'
    providerMap["LocalStorage"] = getLocalStorageResponseKeyMapping();

    return providerMap;
  }

  static HashMap getDefaultResponseKeyMapping() {
    HashMap defaultKeyMap = new HashMap<Keys, String>();
    defaultKeyMap[Keys.host_url] = "https://jobs.github.com/positions.json";
    defaultKeyMap[Keys.id] = "id";
    defaultKeyMap[Keys.type] = "type";
    defaultKeyMap[Keys.detailUrl] = "url";
    defaultKeyMap[Keys.created_at] = "created_at";
    defaultKeyMap[Keys.company] = "company";
    defaultKeyMap[Keys.company_url] = "company_url";
    defaultKeyMap[Keys.location] = "location";
    defaultKeyMap[Keys.title] = "title";
    defaultKeyMap[Keys.description] = "description";
    defaultKeyMap[Keys.how_to_apply] = "how_to_apply";
    defaultKeyMap[Keys.company_logo] = "company_logo";

    return defaultKeyMap;
  }

  static HashMap getLocalStorageResponseKeyMapping() {
    HashMap defaultKeyMap = new HashMap<Keys, String>();
    defaultKeyMap[Keys.assets_path] = "assets/localData.json";
    defaultKeyMap[Keys.id] = "id";
    defaultKeyMap[Keys.type] = "type_local";
    defaultKeyMap[Keys.detailUrl] = "url";
    defaultKeyMap[Keys.created_at] = "created_at";
    defaultKeyMap[Keys.company] = "company_local";
    defaultKeyMap[Keys.company_url] = "company_url";
    defaultKeyMap[Keys.location] = "location";
    defaultKeyMap[Keys.title] = "title_local";
    defaultKeyMap[Keys.description] = "description";
    defaultKeyMap[Keys.how_to_apply] = "how_to_apply";
    defaultKeyMap[Keys.company_logo] = "company_logo";

    return defaultKeyMap;
  }
}
