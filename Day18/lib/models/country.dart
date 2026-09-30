/// Model for the open countries dataset (mledoze/countries on GitHub).
/// Shows nested JSON, lists and maps being flattened into simple fields.
class Country {
  final String code; // ISO alpha-2, e.g. "SA"
  final String name;
  final String officialName;
  final String? capital;
  final String region;
  final String subregion;
  final double area; // km2
  final String flagEmoji;
  final List<String> languages;
  final List<String> currencies;
  final double? lat;
  final double? lng;

  const Country({
    required this.code,
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.area,
    required this.flagEmoji,
    required this.languages,
    required this.currencies,
    required this.lat,
    required this.lng,
  });

  /// Flag image from flagcdn.com, built from the country code.
  String get flagUrl => 'https://flagcdn.com/w320/${code.toLowerCase()}.png';

  bool get hasLocation => lat != null && lng != null;

  factory Country.fromJson(Map<String, dynamic> json) {
    // "name": { "common": "...", "official": "...", "native": {...} }  (nested object)
    final nameMap = json['name'] as Map<String, dynamic>;

    // "capital": ["Riyadh"]  (a list, may be missing or empty)
    final capitals = (json['capital'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    // "languages": { "ara": "Arabic" }  (a map, we only need the values)
    final languagesMap = json['languages'] as Map<String, dynamic>? ?? <String, dynamic>{};

    // "currencies": { "SAR": { "name": "Saudi riyal", "symbol": "..." } }
    final currenciesMap = json['currencies'] as Map<String, dynamic>? ?? <String, dynamic>{};

    // "latlng": [25, 45]  (center of the country)
    final latlng = json['latlng'] as List?;
    final hasLatLng = latlng != null && latlng.length >= 2;

    return Country(
      code: (json['cca2'] ?? '') as String,
      name: nameMap['common'] as String,
      officialName: (nameMap['official'] ?? '') as String,
      capital: capitals.isEmpty ? null : capitals.first,
      region: (json['region'] ?? '') as String,
      subregion: (json['subregion'] ?? '') as String,
      area: (json['area'] as num?)?.toDouble() ?? 0,
      flagEmoji: (json['flag'] ?? '') as String,
      languages: languagesMap.values.map((e) => e.toString()).toList(),
      currencies: currenciesMap.values
          .map((c) => (c as Map<String, dynamic>)['name'].toString())
          .toList(),
      lat: hasLatLng ? (latlng[0] as num).toDouble() : null,
      lng: hasLatLng ? (latlng[1] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'cca2': code,
        'name': {'common': name, 'official': officialName},
        'capital': capital == null ? [] : [capital],
        'region': region,
        'subregion': subregion,
        'area': area,
        'flag': flagEmoji,
        'latlng': hasLocation ? [lat, lng] : [],
      };
}
