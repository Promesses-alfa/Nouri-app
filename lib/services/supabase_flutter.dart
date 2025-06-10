import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<void> saveDayPlan({
    required String timeBlock,
    required List<String> items,
    required bool repeat,
    required DateTime date,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception("Niet ingelogd");

    await _client.from('day_plans').insert({
      'user_id': userId,
      'date': date.toIso8601String(),
      'time_block': timeBlock,
      'items': items,
      'repeat': repeat,
    });
  }

  Future<List<Map<String, dynamic>>> fetchDayPlan(DateTime date) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception("Niet ingelogd");

    final response = await _client
        .from('day_plans')
        .select()
        .eq('user_id', userId)
        .eq('date', date.toIso8601String());

    return response;
  }
}