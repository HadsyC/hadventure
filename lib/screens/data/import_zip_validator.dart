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

String requiredZipFilesHelpMessage() {
  return 'ZIP file must contain required CSV files: trips.csv, cities.csv, flights.csv, trains.csv, hotels.csv, itinerary.csv, trip_tips.csv.';
}

String missingRequiredZipFilesMessage(Iterable<String> missingTables) {
  final missingFiles = missingTables.map((table) => '$table.csv').toList()
    ..sort();
  return 'ZIP is missing required files: ${missingFiles.join(', ')}.';
}
