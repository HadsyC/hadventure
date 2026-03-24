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
  'activities',
  'trip_tips',
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
  'packing_items': {'item', 'is_packed'},
  'contacts': {'name', 'role'},
  'locations': {'name', 'type', 'trip_name'},
};

const Map<String, Set<String>> headerAliases = {
  'trip_name': {'trip_name', 'trip', 'trip_title'},
  'name': {'name'},
  'start_date': {'start_date', 'start'},
  'end_date': {'end_date', 'end'},
  'notes': {'notes', 'note'},
  'currency': {'currency'},
  'timezone': {'timezone', 'time_zone'},
  'country': {'country'},
  'arrival_date': {'arrival_date', 'arrival'},
  'departure_date': {'departure_date', 'departure'},
  'lat': {'lat', 'latitude'},
  'lng': {'lng', 'longitude', 'lon'},
  'flight_number': {'flight_number', 'flight_id', 'flight_no'},
  'airline': {'airline'},
  'origin': {'origin', 'departure_airport', 'from'},
  'destination': {'destination', 'arrival_airport', 'to'},
  'origin_terminal': {'origin_terminal', 'departure_terminal'},
  'destination_terminal': {'destination_terminal', 'arrival_terminal'},
  'departure': {'departure', 'departure_time'},
  'arrival': {'arrival', 'arrival_time'},
  'duration': {'duration', 'flight_duration', 'travel_time'},
  'status': {'status'},
  'tracker_url': {'tracker_url', 'live_tracker_url'},
  'train_number': {'train_number', 'code', 'train_id'},
  'platform': {'platform'},
  'seat': {'seat'},
  'booking_ref': {'booking_ref', 'booking_reference'},
  'ticket_price_pp': {'ticket_price_pp', 'ticket_price_p_p'},
  'booking_fee_pp': {'booking_fee_pp', 'booking_fee_p_p'},
  'total_price_pp': {'total_price_pp', 'total_price_p_p'},
  'city_name': {'city_name', 'city', 'cities', 'city_region'},
  'local_name': {'local_name'},
  'check_in_date': {'check_in_date', 'check_in'},
  'check_out_date': {'check_out_date', 'check_out'},
  'check_in_time': {'check_in_time'},
  'check_out_time': {'check_out_time'},
  'address_en': {'address_en', 'address_en_', 'address'},
  'address_local': {'address_local', 'address_cn', 'address_cn_', 'address_zh'},
  'phone': {'phone'},
  'website': {'website', 'trip_url', 'url_hotel'},
  'total_price': {'total_price'},
  'price_pp': {'price_pp', 'price_p_p'},
  'price_pp_night': {'price_pp_night', 'price_p_p_p_night'},
  'map_url': {'map_url', 'amap_url'},
  'date': {'date', 'dates'},
  'time': {'time'},
  'title': {'title', 'activity', 'event'},
  'itinerary_type': {'itinerary_type', 'activity_type', 'type'},
  'location': {'location'},
  'url': {'url'},
  'price': {'price'},
  'duration_minutes': {'duration_minutes', 'duration_min'},
  'availability': {'availability'},
  'flight_id': {'flight_id'},
  'train_id': {'train_id'},
  'hotel_id': {'hotel_id'},
  'category': {'category'},
  'content': {'content'},
  'language': {'language'},
  'item': {'item'},
  'quantity': {'quantity'},
  'is_packed': {'is_packed', 'packed'},
  'role': {'role'},
  'email': {'email'},
  'type': {'type'},
  'image': {'image'},
  'source_table': {'source_table'},
  'source_id': {'source_id'},
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
