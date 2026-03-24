String normalizeImportHeader(String value) {
  final lower = value.trim().toLowerCase();
  final compact = lower.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  return compact
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

const Set<String> requiredZipTables = {
  'trips',
  'cities',
  'flights',
  'trains',
  'hotels',
  'itinerary',
  'trip_tips',
};

const Set<String> supportedImportTables = {
  'trips',
  'cities',
  'flights',
  'trains',
  'hotels',
  'itinerary',
  'trip_tips',
  'city_summaries',
  'foods',
  'packing_items',
  'contacts',
  'locations',
};

const Map<String, Set<String>> tableDetectionColumns = {
  'trips': {'start_date', 'end_date', 'timezone'},
  'cities': {'arrival_date', 'departure_date'},
  'flights': {'flight_number', 'departure', 'arrival'},
  'trains': {'train_number', 'departure', 'arrival'},
  'hotels': {'name', 'city_name', 'address_en'},
  'itinerary': {'city_name', 'date', 'title'},
  'trip_tips': {'category', 'title', 'content', 'language'},
  'city_summaries': {'city_name', 'summary_text'},
  'foods': {'city_name', 'name', 'map_url'},
  'packing_items': {'item', 'is_packed'},
  'contacts': {'name', 'role'},
  'locations': {'name', 'type', 'trip_name'},
};

const Map<String, Set<String>> headerAliases = {
  'trip_name': {'trip_name'},
  'name': {'name'},
  'start_date': {'start_date'},
  'end_date': {'end_date'},
  'notes': {'notes'},
  'currency': {'currency'},
  'timezone': {'timezone'},
  'country': {'country'},
  'arrival_date': {'arrival_date'},
  'departure_date': {'departure_date'},
  'lat': {'lat'},
  'lng': {'lng'},
  'flight_number': {'flight_number'},
  'airline': {'airline'},
  'origin': {'origin'},
  'destination': {'destination'},
  'origin_terminal': {'origin_terminal'},
  'destination_terminal': {'destination_terminal'},
  'departure': {'departure'},
  'arrival': {'arrival'},
  'duration': {'duration'},
  'status': {'status'},
  'tracker_url': {'tracker_url'},
  'train_number': {'train_number'},
  'platform': {'platform'},
  'seat': {'seat'},
  'booking_ref': {'booking_ref'},
  'ticket_price_pp': {'ticket_price_pp'},
  'booking_fee_pp': {'booking_fee_pp'},
  'total_price_pp': {'total_price_pp'},
  'city_name': {'city_name'},
  'local_name': {'local_name'},
  'check_in_date': {'check_in_date'},
  'check_out_date': {'check_out_date'},
  'check_in_time': {'check_in_time'},
  'check_out_time': {'check_out_time'},
  'address_en': {'address_en'},
  'address_local': {'address_local'},
  'phone': {'phone'},
  'website': {'website'},
  'total_price': {'total_price'},
  'price_pp': {'price_pp'},
  'price_pp_night': {'price_pp_night'},
  'map_url': {'map_url'},
  'date': {'date'},
  'time': {'time'},
  'title': {'title'},
  'summary_text': {'summary_text'},
  'source_language': {'source_language'},
  'itinerary_type': {'itinerary_type'},
  'location': {'location'},
  'url': {'url'},
  'price': {'price'},
  'duration_minutes': {'duration_minutes'},
  'availability': {'availability'},
  'flight_id': {'flight_id'},
  'train_id': {'train_id'},
  'hotel_id': {'hotel_id'},
  'category': {'category'},
  'content': {'content'},
  'language': {'language'},
  'item': {'item'},
  'quantity': {'quantity'},
  'is_packed': {'is_packed'},
  'role': {'role'},
  'email': {'email'},
  'type': {'type'},
  'image': {'image'},
  'source_table': {'source_table'},
  'source_id': {'source_id'},
  'avg_price_cny': {'avg_price_cny'},
  'avg_price_eur': {'avg_price_eur'},
  'recommended_dishes': {'recommended_dishes'},
};

Map<String, String> buildAliasToCanonical() {
  final aliasToCanonical = <String, String>{};
  for (final entry in headerAliases.entries) {
    for (final alias in entry.value) {
      aliasToCanonical[normalizeImportHeader(alias)] = entry.key;
    }
  }
  return aliasToCanonical;
}
