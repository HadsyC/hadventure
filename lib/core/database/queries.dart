import 'package:drift/drift.dart';
import 'app_database.dart';

extension AppQueries on AppDatabase {
  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);

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
                  a.date.isBetweenValues(_startOfDay(date), _endOfDay(date)),
            )
            ..orderBy([(a) => OrderingTerm.asc(a.time)]))
          .get();

  Future<List<ItineraryData>> itinerariesForTripOnDate(
    int tripId,
    DateTime date,
  ) async {
    final tripCities = await citiesForTrip(tripId);
    final cityIds = tripCities.map((c) => c.id).toList();
    if (cityIds.isEmpty) return [];

    return (select(itinerary)
          ..where(
            (a) =>
                a.cityId.isIn(cityIds) &
                a.date.isBetweenValues(_startOfDay(date), _endOfDay(date)),
          )
          ..orderBy([
            (a) => OrderingTerm.asc(a.time),
            (a) => OrderingTerm.asc(a.title),
          ]))
        .get();
  }

  // All itinerary entries across all cities for a trip
  Future<List<ItineraryData>> allItinerariesForTrip(int tripId) async {
    final tripCities = await citiesForTrip(tripId);
    final cityIds = tripCities.map((c) => c.id).toList();
    if (cityIds.isEmpty) return [];

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
    if (cityIds.isEmpty) {
      yield const [];
      return;
    }

    yield* (select(itinerary)
          ..where((a) => a.cityId.isIn(cityIds))
          ..orderBy([
            (a) => OrderingTerm.asc(a.date),
            (a) => OrderingTerm.asc(a.time),
          ]))
        .watch();
  }

  Future<List<Flight>> flightsForTripOnDate(int tripId, DateTime date) =>
      (select(flights)
            ..where(
              (f) =>
                  f.tripId.equals(tripId) &
                  f.departure.isBetweenValues(
                    _startOfDay(date),
                    _endOfDay(date),
                  ),
            )
            ..orderBy([(f) => OrderingTerm.asc(f.departure)]))
          .get();

  Future<List<Train>> trainsForTripOnDate(int tripId, DateTime date) =>
      (select(trains)
            ..where(
              (t) =>
                  t.tripId.equals(tripId) &
                  t.departure.isBetweenValues(
                    _startOfDay(date),
                    _endOfDay(date),
                  ),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.departure)]))
          .get();

  Future<Hotel?> activeHotelForTripOnDate(int tripId, DateTime date) async {
    final tripCities = await citiesForTrip(tripId);
    final cityIds = tripCities.map((c) => c.id).toList();
    if (cityIds.isEmpty) return null;

    final dayStart = _startOfDay(date);
    final dayEnd = _endOfDay(date);
    return (select(hotels)
          ..where(
            (h) =>
                h.cityId.isIn(cityIds) &
                (h.checkIn.isNull() | h.checkIn.isSmallerOrEqualValue(dayEnd)) &
                (h.checkOut.isNull() |
                    h.checkOut.isBiggerOrEqualValue(dayStart)),
          )
          ..orderBy([
            (h) => OrderingTerm.asc(h.checkIn),
            (h) => OrderingTerm.asc(h.id),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Hotel?> nextHotelForTripAfterDate(int tripId, DateTime date) async {
    final tripCities = await citiesForTrip(tripId);
    final cityIds = tripCities.map((c) => c.id).toList();
    if (cityIds.isEmpty) return null;

    final dayStart = _startOfDay(date);
    return (select(hotels)
          ..where(
            (h) =>
                h.cityId.isIn(cityIds) &
                h.checkIn.isNotNull() &
                h.checkIn.isBiggerOrEqualValue(dayStart),
          )
          ..orderBy([(h) => OrderingTerm.asc(h.checkIn)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<TripTip>> tripTipsForTrip(int tripId) =>
      (select(tripTips)
            ..where((t) => t.tripId.equals(tripId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.cityId),
              (t) => OrderingTerm.asc(t.id),
            ]))
          .get();

  Future<List<CitySummary>> citySummariesForTrip(int tripId) =>
      (select(citySummaries)..where((s) => s.tripId.equals(tripId))).get();

  Future<List<Food>> foodsForTrip(int tripId) =>
      (select(foods)
            ..where((f) => f.tripId.equals(tripId))
            ..orderBy([(f) => OrderingTerm.asc(f.name)]))
          .get();

  // First trip (for now we work with one trip at a time)
  Future<Trip?> get currentTrip => (select(trips)..limit(1)).getSingleOrNull();
}
