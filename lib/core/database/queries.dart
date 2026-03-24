import 'package:drift/drift.dart';
import 'app_database.dart';

extension AppQueries on AppDatabase {
  // All cities for a trip
  Future<List<City>> citiesForTrip(int tripId) =>
      (select(cities)..where((c) => c.tripId.equals(tripId))).get();

  // All itinerary entries for a city
  Future<List<ItineraryData>> itinerariesForCity(int cityId) =>
      (select(itinerary)
            ..where((a) => a.cityId.equals(cityId))
            ..orderBy([
              (a) => OrderingTerm.asc(a.date),
              (a) => OrderingTerm.asc(a.time),
            ]))
          .get();

  // Itinerary entries for a city filtered by date
  Future<List<ItineraryData>> itinerariesForCityOnDate(
    int cityId,
    DateTime date,
  ) =>
      (select(itinerary)
            ..where(
              (a) =>
                  a.cityId.equals(cityId) &
                  a.date.isBetweenValues(
                    DateTime(date.year, date.month, date.day),
                    DateTime(date.year, date.month, date.day, 23, 59, 59),
                  ),
            )
            ..orderBy([(a) => OrderingTerm.asc(a.time)]))
          .get();

  // All itinerary entries across all cities for a trip
  Future<List<ItineraryData>> allItinerariesForTrip(int tripId) async {
    final tripCities = await citiesForTrip(tripId);
    final cityIds = tripCities.map((c) => c.id).toList();
    return (select(itinerary)
          ..where((a) => a.cityId.isIn(cityIds))
          ..orderBy([
            (a) => OrderingTerm.asc(a.date),
            (a) => OrderingTerm.asc(a.time),
          ]))
        .get();
  }

  // Watch itinerary (reactive stream) for a trip
  Stream<List<ItineraryData>> watchItinerariesForTrip(int tripId) async* {
    final tripCities = await citiesForTrip(tripId);
    final cityIds = tripCities.map((c) => c.id).toList();
    yield* (select(itinerary)
          ..where((a) => a.cityId.isIn(cityIds))
          ..orderBy([
            (a) => OrderingTerm.asc(a.date),
            (a) => OrderingTerm.asc(a.time),
          ]))
        .watch();
  }

  // First trip (for now we work with one trip at a time)
  Future<Trip?> get currentTrip => (select(trips)..limit(1)).getSingleOrNull();
}
