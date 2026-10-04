import 'package:supabase_flutter/supabase_flutter.dart';

class BickriCardApi {
  final SupabaseClient _client;
  BickriCardApi(this._client);

  Future<Map<String, dynamic>> status() async {
    final response = await _client.functions.invoke(
      'bickri-card-api',
      queryParameters: {'action': 'status'},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> saveProfile({
    required String legalName,
    required String phone,
    required String countryCode,
  }) async {
    final response = await _client.functions.invoke(
      'bickri-card-api',
      method: HttpMethod.post,
      queryParameters: {'action': 'profile'},
      body: {'legal_name': legalName, 'phone': phone, 'country_code': countryCode},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> requestCard({required String cardType}) async {
    final response = await _client.functions.invoke(
      'bickri-card-api',
      method: HttpMethod.post,
      queryParameters: {'action': 'card-request'},
      body: {'card_type': cardType},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }
}
