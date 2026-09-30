import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/api_service.dart' show ApiException;
import '../services/countries_service.dart';
import '../widgets/error_view.dart';
import '../widgets/flag_image.dart';
import 'country_detail_screen.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final _api = CountriesService();

  List<Country> _countries = [];
  String _query = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool showSpinner = true, bool forceRefresh = false}) async {
    if (showSpinner) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final result = await _api.getAll(forceRefresh: forceRefresh);
      if (!mounted) return;
      setState(() {
        _countries = result;
        _loading = false;
        _error = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      if (_countries.isEmpty) {
        setState(() => _error = e.message);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  List<Country> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _countries;
    return _countries
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            (c.capital ?? '').toLowerCase().contains(q) ||
            c.region.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              hintText: 'Search by name, capital or region...',
              leading: const Icon(Icons.search),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final items = _filtered;
    return RefreshIndicator(
      onRefresh: () => _load(showSpinner: false, forceRefresh: true),
      child: items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                Center(child: Text('No countries match "$_query"')),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final c = items[i];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: FlagImage(url: c.flagUrl, emoji: c.flagEmoji, width: 48, height: 32),
                  ),
                  title: Text(c.name),
                  subtitle: Text('${c.capital ?? '-'}  |  ${c.region}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CountryDetailScreen(country: c)),
                  ),
                );
              },
            ),
    );
  }
}
