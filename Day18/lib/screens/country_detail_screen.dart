import 'package:flutter/material.dart';

import '../models/country.dart';
import '../models/weather.dart';
import '../services/api_service.dart' show ApiException;
import '../services/countries_service.dart';
import '../widgets/flag_image.dart';

class CountryDetailScreen extends StatefulWidget {
  final Country country;
  const CountryDetailScreen({super.key, required this.country});

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  final _api = CountriesService();

  Weather? _weather;
  bool _weatherLoading = false;
  String? _weatherError;

  @override
  void initState() {
    super.initState();
    if (widget.country.hasLocation) _loadWeather();
  }

  /// Second API: weather at the country's coordinates, taken from the first data source.
  Future<void> _loadWeather() async {
    final c = widget.country;
    setState(() {
      _weatherLoading = true;
      _weatherError = null;
    });
    try {
      final w = await _api.getWeather(c.lat!, c.lng!);
      if (!mounted) return;
      setState(() {
        _weather = w;
        _weatherLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _weatherError = e.message;
        _weatherLoading = false;
      });
    }
  }

  String _formatNumber(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.country;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(c.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FlagImage(
                url: c.flagUrl,
                emoji: c.flagEmoji,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(c.officialName, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          _row('Capital', c.capital ?? ''),
          _row('Region', c.region),
          _row('Subregion', c.subregion),
          _row('Area', '${_formatNumber(c.area.round())} km2'),
          _row('Languages', c.languages.join(', ')),
          _row('Currencies', c.currencies.join(', ')),
          const SizedBox(height: 16),
          _weatherCard(theme),
        ],
      ),
    );
  }

  Widget _weatherCard(ThemeData theme) {
    final c = widget.country;

    Widget content;
    if (!c.hasLocation) {
      content = const Text('No location available for weather.');
    } else if (_weatherLoading) {
      content = const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_weatherError != null) {
      content = Row(
        children: [
          Expanded(child: Text(_weatherError!)),
          TextButton.icon(
            onPressed: _loadWeather,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      );
    } else if (_weather != null) {
      final w = _weather!;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${w.temperature.toStringAsFixed(1)} ${w.temperatureUnit}',
              style: theme.textTheme.headlineMedium),
          Text(w.description),
          const SizedBox(height: 4),
          Text('Wind: ${w.windSpeed} ${w.windUnit}'),
        ],
      );
    } else {
      content = const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weather in ${c.name} (country center)', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}
