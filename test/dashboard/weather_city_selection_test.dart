import 'package:flutter_test/flutter_test.dart';
import 'package:hadventure/core/database/app_database.dart';
import 'package:hadventure/screens/dashboard/dashboard_screen.dart';

void main() {
  City city(int id, String name) =>
      City(tripId: 1, id: id, name: name, country: 'CN');

  ItineraryData itinerary({required int cityId}) => ItineraryData(
    cityId: cityId,
    id: cityId * 100,
    date: DateTime(2026, 3, 25),
    title: 'Activity $cityId',
  );

  Hotel hotel({required int cityId}) =>
      Hotel(cityId: cityId, id: cityId * 10, name: 'Hotel $cityId');

  test('prefers today itinerary city first', () {
    final shanghai = city(1, 'Shanghai');
    final beijing = city(2, 'Beijing');

    final selected = chooseWeatherCityForDashboard(
      cityById: {1: shanghai, 2: beijing},
      todayItinerary: [itinerary(cityId: 2)],
      tomorrowFirst: itinerary(cityId: 1),
      hotel: hotel(cityId: 1),
      allCities: [shanghai, beijing],
    );

    expect(selected?.id, 2);
  });

  test('falls back to tomorrow first city when no today items', () {
    final shanghai = city(1, 'Shanghai');
    final beijing = city(2, 'Beijing');

    final selected = chooseWeatherCityForDashboard(
      cityById: {1: shanghai, 2: beijing},
      todayItinerary: const [],
      tomorrowFirst: itinerary(cityId: 1),
      hotel: hotel(cityId: 2),
      allCities: [shanghai, beijing],
    );

    expect(selected?.id, 1);
  });

  test('falls back to hotel city when itinerary is unavailable', () {
    final shanghai = city(1, 'Shanghai');
    final beijing = city(2, 'Beijing');

    final selected = chooseWeatherCityForDashboard(
      cityById: {1: shanghai, 2: beijing},
      todayItinerary: const [],
      tomorrowFirst: null,
      hotel: hotel(cityId: 2),
      allCities: [shanghai, beijing],
    );

    expect(selected?.id, 2);
  });

  test('falls back to first city when no itinerary or hotel exists', () {
    final shanghai = city(1, 'Shanghai');
    final beijing = city(2, 'Beijing');

    final selected = chooseWeatherCityForDashboard(
      cityById: {1: shanghai, 2: beijing},
      todayItinerary: const [],
      tomorrowFirst: null,
      hotel: null,
      allCities: [shanghai, beijing],
    );

    expect(selected?.id, 1);
  });
}
