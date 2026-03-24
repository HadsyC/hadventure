const Set<String> requiredZipTables = {
  'trips',
  'cities',
  'flights',
  'trains',
  'hotels',
  'itinerary',
  'trip_tips',
};

Set<String> missingRequiredZipTables(Iterable<String> availableTables) {
  final available = availableTables.toSet();
  return requiredZipTables.difference(available);
}

bool hasAllRequiredZipTables(Iterable<String> availableTables) {
  return missingRequiredZipTables(availableTables).isEmpty;
}
