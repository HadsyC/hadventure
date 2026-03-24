import 'package:drift/drift.dart';

// ── SHARED MIXINS ─────────────────────────────────────────────────────────────

mixin HasTripId on Table {
  IntColumn get tripId => integer().references(Trips, #id)();
}

mixin HasCityId on Table {
  IntColumn get cityId => integer().references(Cities, #id)();
}

mixin HasCoordinates on Table {
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
}

mixin HasBooking on Table {
  TextColumn get bookingRef => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get seat => text().nullable()();
}

mixin HasAddress on Table {
  TextColumn get address => text().nullable()();
  TextColumn get localAddress => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get website => text().nullable()();
}

// ── TABLES ────────────────────────────────────────────────────────────────────

class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get coverImage => text().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get timezone => text().nullable()();
}

class Contacts extends Table with HasTripId {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get role => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notes => text().nullable()();
}

class Cities extends Table with HasTripId, HasCoordinates {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get country => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get arrivalDate => dateTime().nullable()();
  DateTimeColumn get departureDate => dateTime().nullable()();
}

class Hotels extends Table with HasCityId, HasCoordinates, HasAddress {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get localName => text().nullable()();
  DateTimeColumn get checkIn => dateTime().nullable()();
  DateTimeColumn get checkOut => dateTime().nullable()();
  TextColumn get checkInTime => text().nullable()();
  TextColumn get checkOutTime => text().nullable()();
  TextColumn get confirmation => text().nullable()();
  RealColumn get totalPrice => real().nullable()();
  RealColumn get pricePerPerson => real().nullable()();
  RealColumn get pricePerPersonNight => real().nullable()();
  TextColumn get mapUrl => text().nullable()();
}

class Activities extends Table with HasCityId, HasCoordinates {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get time => text().nullable()();
  TextColumn get title => text()();
  TextColumn get activityType => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get url => text().nullable()();
  RealColumn get price => real().nullable()();
  TextColumn get currency => text().nullable()();
  IntColumn get duration => integer().nullable()();
  TextColumn get availability => text().nullable()();
  TextColumn get status => text().nullable()();
  DateTimeColumn get bookedAt => dateTime().nullable()();
}

class Flights extends Table with HasTripId, HasBooking {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get airline => text().nullable()();
  TextColumn get flightNumber => text()();
  TextColumn get origin => text()();
  TextColumn get destination => text()();
  TextColumn get originTerminal => text().nullable()();
  TextColumn get destinationTerminal => text().nullable()();
  DateTimeColumn get departure => dateTime()();
  DateTimeColumn get arrival => dateTime()();
  TextColumn get duration => text().nullable()();
  TextColumn get trackerUrl => text().nullable()();
}

class Trains extends Table with HasTripId, HasBooking {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get trainNumber => text()();
  TextColumn get origin => text()();
  TextColumn get destination => text()();
  DateTimeColumn get departure => dateTime()();
  DateTimeColumn get arrival => dateTime()();
  TextColumn get duration => text().nullable()();
  TextColumn get platform => text().nullable()();
  RealColumn get ticketPricePerPerson => real().nullable()();
  RealColumn get bookingFeePerPerson => real().nullable()();
  RealColumn get totalPricePerPerson => real().nullable()();
}

class PackingItems extends Table with HasTripId {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get item => text()();
  TextColumn get category => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  BoolColumn get isPacked => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
}

class TripTips extends Table with HasTripId {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cityId => integer().references(Cities, #id).nullable()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get language => text().nullable()();
}
