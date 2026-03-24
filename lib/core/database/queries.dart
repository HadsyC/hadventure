import 'package:drift/drift.dart';
import 'app_database.dart';

extension AppQueries on AppDatabase {
  // All cities for a trip
  Future<List<City>> citiesForTrip(int tripId) =>
      (select(cities)..where((c) => c.tripId.equals(tripId))).get();

  // All activities for a city
  Future<List<Activity>> activitiesForCity(int cityId) =>
      (select(activities)
            ..where((a) => a.cityId.equals(cityId))
            ..orderBy([
              (a) => OrderingTerm.asc(a.date),
              (a) => OrderingTerm.asc(a.time),
            ]))
          .get();

  // Activities for a city filtered by date
  Future<List<Activity>> activitiesForCityOnDate(int cityId, DateTime date) =>
      (select(activities)
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

  // All activities across all cities for a trip
  Future<List<Activity>> allActivitiesForTrip(int tripId) async {
    final tripCities = await citiesForTrip(tripId);
    final cityIds = tripCities.map((c) => c.id).toList();
    return (select(activities)
          ..where((a) => a.cityId.isIn(cityIds))
          ..orderBy([
            (a) => OrderingTerm.asc(a.date),
            (a) => OrderingTerm.asc(a.time),
          ]))
        .get();
  }

  // Watch activities (reactive stream) for a trip
  Stream<List<Activity>> watchActivitiesForTrip(int tripId) async* {
    final tripCities = await citiesForTrip(tripId);
    final cityIds = tripCities.map((c) => c.id).toList();
    yield* (select(activities)
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
