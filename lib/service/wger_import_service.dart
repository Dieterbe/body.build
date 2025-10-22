import 'dart:convert';
import 'package:http/http.dart' as http;

class WgerImportService {
  static const String baseUrl = 'https://wger.de/api/v2';

  Future<WgerImportResult> importWeightMeasurements(
    String apiKey, {
    void Function(WgerImportProgress)? onProgress,
  }) async {
    try {
      // First, fetch the user profile to determine weight unit
      onProgress?.call(
        WgerImportProgress(
          currentPage: 0,
          totalPointsFetched: 0,
          status: 'Fetching user profile...',
        ),
      );

      final profileResponse = await http.get(
        Uri.parse('$baseUrl/userprofile/'),
        headers: {'Authorization': 'Token $apiKey', 'Accept': 'application/json'},
      );

      if (profileResponse.statusCode == 401) {
        return WgerImportResult.error('Invalid API key');
      }

      if (profileResponse.statusCode != 200) {
        return WgerImportResult.error(
          'Failed to fetch user profile: ${profileResponse.statusCode} ${profileResponse.reasonPhrase}',
        );
      }

      final profileData = jsonDecode(profileResponse.body) as Map<String, dynamic>;

      String weightUnit = 'kg'; // default to kg.
      // in wger, it's either 'kg' or 'lb'
      // see https://github.com/wger-project/wger/blob/master/wger/core/models/profile.py
      if (profileData.isNotEmpty) {
        weightUnit = profileData['weight_unit'] as String? ?? 'kg';
      }

      final allResults = <dynamic>[];
      String? nextUrl = '$baseUrl/weightentry/';
      int pageNumber = 0;

      // Fetch all pages by following the 'next' URL
      while (nextUrl != null) {
        pageNumber++;

        // Report progress before making the call
        onProgress?.call(
          WgerImportProgress(
            currentPage: pageNumber,
            totalPointsFetched: allResults.length,
            status: 'Fetching page $pageNumber...',
          ),
        );

        final response = await http.get(
          Uri.parse(nextUrl),
          headers: {'Authorization': 'Token $apiKey', 'Accept': 'application/json'},
        );

        if (response.statusCode == 401) {
          return WgerImportResult.error('Invalid API key');
        }

        if (response.statusCode != 200) {
          return WgerImportResult.error(
            'Failed to fetch data: ${response.statusCode} ${response.reasonPhrase}',
          );
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;

        if (results != null && results.isNotEmpty) {
          allResults.addAll(results);

          // Report progress after fetching data
          onProgress?.call(
            WgerImportProgress(
              currentPage: pageNumber,
              totalPointsFetched: allResults.length,
              status: 'Fetched ${results.length} points from page $pageNumber',
            ),
          );
        }

        // Get the next page URL, if any
        nextUrl = data['next'] as String?;
      }

      if (allResults.isEmpty) {
        return WgerImportResult.success(0, 0, weightUnit: weightUnit);
      }

      return WgerImportResult.success(
        allResults.length,
        0,
        weightEntries: allResults,
        weightUnit: weightUnit,
      );
    } catch (e) {
      return WgerImportResult.error('Error: $e');
    }
  }

  List<WgerWeightEntry> parseWeightEntries(List<dynamic> results) {
    return results.map((entry) {
      final weightValue = entry['weight'];
      final weight = weightValue is String
          ? double.parse(weightValue)
          : (weightValue as num).toDouble();

      return WgerWeightEntry(date: DateTime.parse(entry['date'] as String), weight: weight);
    }).toList();
  }
}

class WgerWeightEntry {
  final DateTime date;
  final double weight;

  WgerWeightEntry({required this.date, required this.weight});
}

class WgerImportProgress {
  final int currentPage;
  final int totalPointsFetched;
  final String status;

  WgerImportProgress({
    required this.currentPage,
    required this.totalPointsFetched,
    required this.status,
  });
}

class WgerImportResult {
  final bool success;
  final String? errorMessage;
  final int totalCount;
  final int importedCount;
  final List<dynamic>? weightEntries;
  final String? weightUnit;

  WgerImportResult._({
    required this.success,
    this.errorMessage,
    required this.totalCount,
    required this.importedCount,
    this.weightEntries,
    this.weightUnit,
  });

  factory WgerImportResult.success(
    int totalCount,
    int importedCount, {
    List<dynamic>? weightEntries,
    String? weightUnit,
  }) {
    return WgerImportResult._(
      success: true,
      totalCount: totalCount,
      importedCount: importedCount,
      weightEntries: weightEntries,
      weightUnit: weightUnit,
    );
  }

  factory WgerImportResult.error(String message) {
    return WgerImportResult._(
      success: false,
      errorMessage: message,
      totalCount: 0,
      importedCount: 0,
      weightUnit: null,
    );
  }
}
