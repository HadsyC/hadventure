// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverImageMeta = const VerificationMeta(
    'coverImage',
  );
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
    'cover_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startDate,
    endDate,
    notes,
    coverImage,
    currency,
    timezone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('cover_image')) {
      context.handle(
        _coverImageMeta,
        coverImage.isAcceptableOrUnknown(data['cover_image']!, _coverImageMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      coverImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      ),
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;
  final String? coverImage;
  final String? currency;
  final String? timezone;
  const Trip({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.notes,
    this.coverImage,
    this.currency,
    this.timezone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || coverImage != null) {
      map['cover_image'] = Variable<String>(coverImage);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || timezone != null) {
      map['timezone'] = Variable<String>(timezone);
    }
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      coverImage: coverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImage),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      timezone: timezone == null && nullToAbsent
          ? const Value.absent()
          : Value(timezone),
    );
  }

  factory Trip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      coverImage: serializer.fromJson<String?>(json['coverImage']),
      currency: serializer.fromJson<String?>(json['currency']),
      timezone: serializer.fromJson<String?>(json['timezone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'notes': serializer.toJson<String?>(notes),
      'coverImage': serializer.toJson<String?>(coverImage),
      'currency': serializer.toJson<String?>(currency),
      'timezone': serializer.toJson<String?>(timezone),
    };
  }

  Trip copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    Value<String?> notes = const Value.absent(),
    Value<String?> coverImage = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    Value<String?> timezone = const Value.absent(),
  }) => Trip(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    notes: notes.present ? notes.value : this.notes,
    coverImage: coverImage.present ? coverImage.value : this.coverImage,
    currency: currency.present ? currency.value : this.currency,
    timezone: timezone.present ? timezone.value : this.timezone,
  );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      coverImage: data.coverImage.present
          ? data.coverImage.value
          : this.coverImage,
      currency: data.currency.present ? data.currency.value : this.currency,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('notes: $notes, ')
          ..write('coverImage: $coverImage, ')
          ..write('currency: $currency, ')
          ..write('timezone: $timezone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    startDate,
    endDate,
    notes,
    coverImage,
    currency,
    timezone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.notes == this.notes &&
          other.coverImage == this.coverImage &&
          other.currency == this.currency &&
          other.timezone == this.timezone);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String?> notes;
  final Value<String?> coverImage;
  final Value<String?> currency;
  final Value<String?> timezone;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.currency = const Value.absent(),
    this.timezone = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    this.notes = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.currency = const Value.absent(),
    this.timezone = const Value.absent(),
  }) : name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Trip> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? notes,
    Expression<String>? coverImage,
    Expression<String>? currency,
    Expression<String>? timezone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (notes != null) 'notes': notes,
      if (coverImage != null) 'cover_image': coverImage,
      if (currency != null) 'currency': currency,
      if (timezone != null) 'timezone': timezone,
    });
  }

  TripsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String?>? notes,
    Value<String?>? coverImage,
    Value<String?>? currency,
    Value<String?>? timezone,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      coverImage: coverImage ?? this.coverImage,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('notes: $notes, ')
          ..write('coverImage: $coverImage, ')
          ..write('currency: $currency, ')
          ..write('timezone: $timezone')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    id,
    name,
    role,
    phone,
    email,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final int tripId;
  final int id;
  final String name;
  final String? role;
  final String? phone;
  final String? email;
  final String? notes;
  const Contact({
    required this.tripId,
    required this.id,
    required this.name,
    this.role,
    this.phone,
    this.email,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      tripId: Value(tripId),
      id: Value(id),
      name: Value(name),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      tripId: serializer.fromJson<int>(json['tripId']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String?>(json['role']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String?>(role),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Contact copyWith({
    int? tripId,
    int? id,
    String? name,
    Value<String?> role = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Contact(
    tripId: tripId ?? this.tripId,
    id: id ?? this.id,
    name: name ?? this.name,
    role: role.present ? role.value : this.role,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    notes: notes.present ? notes.value : this.notes,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('tripId: $tripId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tripId, id, name, role, phone, email, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.tripId == this.tripId &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.notes == this.notes);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<int> tripId;
  final Value<int> id;
  final Value<String> name;
  final Value<String?> role;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> notes;
  const ContactsCompanion({
    this.tripId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ContactsCompanion.insert({
    required int tripId,
    this.id = const Value.absent(),
    required String name,
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
  }) : tripId = Value(tripId),
       name = Value(name);
  static Insertable<Contact> custom({
    Expression<int>? tripId,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
    });
  }

  ContactsCompanion copyWith({
    Value<int>? tripId,
    Value<int>? id,
    Value<String>? name,
    Value<String?>? role,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? notes,
  }) {
    return ContactsCompanion(
      tripId: tripId ?? this.tripId,
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $CitiesTable extends Cities with TableInfo<$CitiesTable, City> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrivalDateMeta = const VerificationMeta(
    'arrivalDate',
  );
  @override
  late final GeneratedColumn<DateTime> arrivalDate = GeneratedColumn<DateTime>(
    'arrival_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departureDateMeta = const VerificationMeta(
    'departureDate',
  );
  @override
  late final GeneratedColumn<DateTime> departureDate =
      GeneratedColumn<DateTime>(
        'departure_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cityImageMeta = const VerificationMeta(
    'cityImage',
  );
  @override
  late final GeneratedColumn<String> cityImage = GeneratedColumn<String>(
    'city_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    lat,
    lng,
    id,
    name,
    country,
    notes,
    arrivalDate,
    departureDate,
    cityImage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cities';
  @override
  VerificationContext validateIntegrity(
    Insertable<City> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    } else if (isInserting) {
      context.missing(_countryMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('arrival_date')) {
      context.handle(
        _arrivalDateMeta,
        arrivalDate.isAcceptableOrUnknown(
          data['arrival_date']!,
          _arrivalDateMeta,
        ),
      );
    }
    if (data.containsKey('departure_date')) {
      context.handle(
        _departureDateMeta,
        departureDate.isAcceptableOrUnknown(
          data['departure_date']!,
          _departureDateMeta,
        ),
      );
    }
    if (data.containsKey('city_image')) {
      context.handle(
        _cityImageMeta,
        cityImage.isAcceptableOrUnknown(data['city_image']!, _cityImageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  City map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return City(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      arrivalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrival_date'],
      ),
      departureDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}departure_date'],
      ),
      cityImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city_image'],
      ),
    );
  }

  @override
  $CitiesTable createAlias(String alias) {
    return $CitiesTable(attachedDatabase, alias);
  }
}

class City extends DataClass implements Insertable<City> {
  final int tripId;
  final double? lat;
  final double? lng;
  final int id;
  final String name;
  final String country;
  final String? notes;
  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final String? cityImage;
  const City({
    required this.tripId,
    this.lat,
    this.lng,
    required this.id,
    required this.name,
    required this.country,
    this.notes,
    this.arrivalDate,
    this.departureDate,
    this.cityImage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['country'] = Variable<String>(country);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || arrivalDate != null) {
      map['arrival_date'] = Variable<DateTime>(arrivalDate);
    }
    if (!nullToAbsent || departureDate != null) {
      map['departure_date'] = Variable<DateTime>(departureDate);
    }
    if (!nullToAbsent || cityImage != null) {
      map['city_image'] = Variable<String>(cityImage);
    }
    return map;
  }

  CitiesCompanion toCompanion(bool nullToAbsent) {
    return CitiesCompanion(
      tripId: Value(tripId),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      id: Value(id),
      name: Value(name),
      country: Value(country),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      arrivalDate: arrivalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivalDate),
      departureDate: departureDate == null && nullToAbsent
          ? const Value.absent()
          : Value(departureDate),
      cityImage: cityImage == null && nullToAbsent
          ? const Value.absent()
          : Value(cityImage),
    );
  }

  factory City.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return City(
      tripId: serializer.fromJson<int>(json['tripId']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      country: serializer.fromJson<String>(json['country']),
      notes: serializer.fromJson<String?>(json['notes']),
      arrivalDate: serializer.fromJson<DateTime?>(json['arrivalDate']),
      departureDate: serializer.fromJson<DateTime?>(json['departureDate']),
      cityImage: serializer.fromJson<String?>(json['cityImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'country': serializer.toJson<String>(country),
      'notes': serializer.toJson<String?>(notes),
      'arrivalDate': serializer.toJson<DateTime?>(arrivalDate),
      'departureDate': serializer.toJson<DateTime?>(departureDate),
      'cityImage': serializer.toJson<String?>(cityImage),
    };
  }

  City copyWith({
    int? tripId,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    int? id,
    String? name,
    String? country,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> arrivalDate = const Value.absent(),
    Value<DateTime?> departureDate = const Value.absent(),
    Value<String?> cityImage = const Value.absent(),
  }) => City(
    tripId: tripId ?? this.tripId,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    id: id ?? this.id,
    name: name ?? this.name,
    country: country ?? this.country,
    notes: notes.present ? notes.value : this.notes,
    arrivalDate: arrivalDate.present ? arrivalDate.value : this.arrivalDate,
    departureDate: departureDate.present
        ? departureDate.value
        : this.departureDate,
    cityImage: cityImage.present ? cityImage.value : this.cityImage,
  );
  City copyWithCompanion(CitiesCompanion data) {
    return City(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      country: data.country.present ? data.country.value : this.country,
      notes: data.notes.present ? data.notes.value : this.notes,
      arrivalDate: data.arrivalDate.present
          ? data.arrivalDate.value
          : this.arrivalDate,
      departureDate: data.departureDate.present
          ? data.departureDate.value
          : this.departureDate,
      cityImage: data.cityImage.present ? data.cityImage.value : this.cityImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('City(')
          ..write('tripId: $tripId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('country: $country, ')
          ..write('notes: $notes, ')
          ..write('arrivalDate: $arrivalDate, ')
          ..write('departureDate: $departureDate, ')
          ..write('cityImage: $cityImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tripId,
    lat,
    lng,
    id,
    name,
    country,
    notes,
    arrivalDate,
    departureDate,
    cityImage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is City &&
          other.tripId == this.tripId &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.id == this.id &&
          other.name == this.name &&
          other.country == this.country &&
          other.notes == this.notes &&
          other.arrivalDate == this.arrivalDate &&
          other.departureDate == this.departureDate &&
          other.cityImage == this.cityImage);
}

class CitiesCompanion extends UpdateCompanion<City> {
  final Value<int> tripId;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<int> id;
  final Value<String> name;
  final Value<String> country;
  final Value<String?> notes;
  final Value<DateTime?> arrivalDate;
  final Value<DateTime?> departureDate;
  final Value<String?> cityImage;
  const CitiesCompanion({
    this.tripId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.country = const Value.absent(),
    this.notes = const Value.absent(),
    this.arrivalDate = const Value.absent(),
    this.departureDate = const Value.absent(),
    this.cityImage = const Value.absent(),
  });
  CitiesCompanion.insert({
    required int tripId,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    required String country,
    this.notes = const Value.absent(),
    this.arrivalDate = const Value.absent(),
    this.departureDate = const Value.absent(),
    this.cityImage = const Value.absent(),
  }) : tripId = Value(tripId),
       name = Value(name),
       country = Value(country);
  static Insertable<City> custom({
    Expression<int>? tripId,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? country,
    Expression<String>? notes,
    Expression<DateTime>? arrivalDate,
    Expression<DateTime>? departureDate,
    Expression<String>? cityImage,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (country != null) 'country': country,
      if (notes != null) 'notes': notes,
      if (arrivalDate != null) 'arrival_date': arrivalDate,
      if (departureDate != null) 'departure_date': departureDate,
      if (cityImage != null) 'city_image': cityImage,
    });
  }

  CitiesCompanion copyWith({
    Value<int>? tripId,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<int>? id,
    Value<String>? name,
    Value<String>? country,
    Value<String?>? notes,
    Value<DateTime?>? arrivalDate,
    Value<DateTime?>? departureDate,
    Value<String?>? cityImage,
  }) {
    return CitiesCompanion(
      tripId: tripId ?? this.tripId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      notes: notes ?? this.notes,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      departureDate: departureDate ?? this.departureDate,
      cityImage: cityImage ?? this.cityImage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (arrivalDate.present) {
      map['arrival_date'] = Variable<DateTime>(arrivalDate.value);
    }
    if (departureDate.present) {
      map['departure_date'] = Variable<DateTime>(departureDate.value);
    }
    if (cityImage.present) {
      map['city_image'] = Variable<String>(cityImage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitiesCompanion(')
          ..write('tripId: $tripId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('country: $country, ')
          ..write('notes: $notes, ')
          ..write('arrivalDate: $arrivalDate, ')
          ..write('departureDate: $departureDate, ')
          ..write('cityImage: $cityImage')
          ..write(')'))
        .toString();
  }
}

class $HotelsTable extends Hotels with TableInfo<$HotelsTable, Hotel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HotelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<int> cityId = GeneratedColumn<int>(
    'city_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cities (id)',
    ),
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localNameMeta = const VerificationMeta(
    'localName',
  );
  @override
  late final GeneratedColumn<String> localName = GeneratedColumn<String>(
    'local_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkInMeta = const VerificationMeta(
    'checkIn',
  );
  @override
  late final GeneratedColumn<DateTime> checkIn = GeneratedColumn<DateTime>(
    'check_in',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkOutMeta = const VerificationMeta(
    'checkOut',
  );
  @override
  late final GeneratedColumn<DateTime> checkOut = GeneratedColumn<DateTime>(
    'check_out',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkInTimeMeta = const VerificationMeta(
    'checkInTime',
  );
  @override
  late final GeneratedColumn<String> checkInTime = GeneratedColumn<String>(
    'check_in_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkOutTimeMeta = const VerificationMeta(
    'checkOutTime',
  );
  @override
  late final GeneratedColumn<String> checkOutTime = GeneratedColumn<String>(
    'check_out_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmationMeta = const VerificationMeta(
    'confirmation',
  );
  @override
  late final GeneratedColumn<String> confirmation = GeneratedColumn<String>(
    'confirmation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricePerPersonMeta = const VerificationMeta(
    'pricePerPerson',
  );
  @override
  late final GeneratedColumn<double> pricePerPerson = GeneratedColumn<double>(
    'price_per_person',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricePerPersonNightMeta =
      const VerificationMeta('pricePerPersonNight');
  @override
  late final GeneratedColumn<double> pricePerPersonNight =
      GeneratedColumn<double>(
        'price_per_person_night',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _mapUrlMeta = const VerificationMeta('mapUrl');
  @override
  late final GeneratedColumn<String> mapUrl = GeneratedColumn<String>(
    'map_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hotelImageMeta = const VerificationMeta(
    'hotelImage',
  );
  @override
  late final GeneratedColumn<String> hotelImage = GeneratedColumn<String>(
    'hotel_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressEnMeta = const VerificationMeta(
    'addressEn',
  );
  @override
  late final GeneratedColumn<String> addressEn = GeneratedColumn<String>(
    'address_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLocalMeta = const VerificationMeta(
    'addressLocal',
  );
  @override
  late final GeneratedColumn<String> addressLocal = GeneratedColumn<String>(
    'address_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cityId,
    lat,
    lng,
    id,
    name,
    localName,
    checkIn,
    checkOut,
    checkInTime,
    checkOutTime,
    confirmation,
    totalPrice,
    pricePerPerson,
    pricePerPersonNight,
    mapUrl,
    hotelImage,
    addressEn,
    addressLocal,
    phone,
    website,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hotels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Hotel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('city_id')) {
      context.handle(
        _cityIdMeta,
        cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('local_name')) {
      context.handle(
        _localNameMeta,
        localName.isAcceptableOrUnknown(data['local_name']!, _localNameMeta),
      );
    }
    if (data.containsKey('check_in')) {
      context.handle(
        _checkInMeta,
        checkIn.isAcceptableOrUnknown(data['check_in']!, _checkInMeta),
      );
    }
    if (data.containsKey('check_out')) {
      context.handle(
        _checkOutMeta,
        checkOut.isAcceptableOrUnknown(data['check_out']!, _checkOutMeta),
      );
    }
    if (data.containsKey('check_in_time')) {
      context.handle(
        _checkInTimeMeta,
        checkInTime.isAcceptableOrUnknown(
          data['check_in_time']!,
          _checkInTimeMeta,
        ),
      );
    }
    if (data.containsKey('check_out_time')) {
      context.handle(
        _checkOutTimeMeta,
        checkOutTime.isAcceptableOrUnknown(
          data['check_out_time']!,
          _checkOutTimeMeta,
        ),
      );
    }
    if (data.containsKey('confirmation')) {
      context.handle(
        _confirmationMeta,
        confirmation.isAcceptableOrUnknown(
          data['confirmation']!,
          _confirmationMeta,
        ),
      );
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    }
    if (data.containsKey('price_per_person')) {
      context.handle(
        _pricePerPersonMeta,
        pricePerPerson.isAcceptableOrUnknown(
          data['price_per_person']!,
          _pricePerPersonMeta,
        ),
      );
    }
    if (data.containsKey('price_per_person_night')) {
      context.handle(
        _pricePerPersonNightMeta,
        pricePerPersonNight.isAcceptableOrUnknown(
          data['price_per_person_night']!,
          _pricePerPersonNightMeta,
        ),
      );
    }
    if (data.containsKey('map_url')) {
      context.handle(
        _mapUrlMeta,
        mapUrl.isAcceptableOrUnknown(data['map_url']!, _mapUrlMeta),
      );
    }
    if (data.containsKey('hotel_image')) {
      context.handle(
        _hotelImageMeta,
        hotelImage.isAcceptableOrUnknown(data['hotel_image']!, _hotelImageMeta),
      );
    }
    if (data.containsKey('address_en')) {
      context.handle(
        _addressEnMeta,
        addressEn.isAcceptableOrUnknown(data['address_en']!, _addressEnMeta),
      );
    }
    if (data.containsKey('address_local')) {
      context.handle(
        _addressLocalMeta,
        addressLocal.isAcceptableOrUnknown(
          data['address_local']!,
          _addressLocalMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hotel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hotel(
      cityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}city_id'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      localName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_name'],
      ),
      checkIn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_in'],
      ),
      checkOut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_out'],
      ),
      checkInTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_time'],
      ),
      checkOutTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_out_time'],
      ),
      confirmation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmation'],
      ),
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      ),
      pricePerPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_person'],
      ),
      pricePerPersonNight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_person_night'],
      ),
      mapUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}map_url'],
      ),
      hotelImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hotel_image'],
      ),
      addressEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_en'],
      ),
      addressLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_local'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
    );
  }

  @override
  $HotelsTable createAlias(String alias) {
    return $HotelsTable(attachedDatabase, alias);
  }
}

class Hotel extends DataClass implements Insertable<Hotel> {
  final int cityId;
  final double? lat;
  final double? lng;
  final int id;
  final String name;
  final String? localName;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? checkInTime;
  final String? checkOutTime;
  final String? confirmation;
  final double? totalPrice;
  final double? pricePerPerson;
  final double? pricePerPersonNight;
  final String? mapUrl;
  final String? hotelImage;
  final String? addressEn;
  final String? addressLocal;
  final String? phone;
  final String? website;
  const Hotel({
    required this.cityId,
    this.lat,
    this.lng,
    required this.id,
    required this.name,
    this.localName,
    this.checkIn,
    this.checkOut,
    this.checkInTime,
    this.checkOutTime,
    this.confirmation,
    this.totalPrice,
    this.pricePerPerson,
    this.pricePerPersonNight,
    this.mapUrl,
    this.hotelImage,
    this.addressEn,
    this.addressLocal,
    this.phone,
    this.website,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['city_id'] = Variable<int>(cityId);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || localName != null) {
      map['local_name'] = Variable<String>(localName);
    }
    if (!nullToAbsent || checkIn != null) {
      map['check_in'] = Variable<DateTime>(checkIn);
    }
    if (!nullToAbsent || checkOut != null) {
      map['check_out'] = Variable<DateTime>(checkOut);
    }
    if (!nullToAbsent || checkInTime != null) {
      map['check_in_time'] = Variable<String>(checkInTime);
    }
    if (!nullToAbsent || checkOutTime != null) {
      map['check_out_time'] = Variable<String>(checkOutTime);
    }
    if (!nullToAbsent || confirmation != null) {
      map['confirmation'] = Variable<String>(confirmation);
    }
    if (!nullToAbsent || totalPrice != null) {
      map['total_price'] = Variable<double>(totalPrice);
    }
    if (!nullToAbsent || pricePerPerson != null) {
      map['price_per_person'] = Variable<double>(pricePerPerson);
    }
    if (!nullToAbsent || pricePerPersonNight != null) {
      map['price_per_person_night'] = Variable<double>(pricePerPersonNight);
    }
    if (!nullToAbsent || mapUrl != null) {
      map['map_url'] = Variable<String>(mapUrl);
    }
    if (!nullToAbsent || hotelImage != null) {
      map['hotel_image'] = Variable<String>(hotelImage);
    }
    if (!nullToAbsent || addressEn != null) {
      map['address_en'] = Variable<String>(addressEn);
    }
    if (!nullToAbsent || addressLocal != null) {
      map['address_local'] = Variable<String>(addressLocal);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    return map;
  }

  HotelsCompanion toCompanion(bool nullToAbsent) {
    return HotelsCompanion(
      cityId: Value(cityId),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      id: Value(id),
      name: Value(name),
      localName: localName == null && nullToAbsent
          ? const Value.absent()
          : Value(localName),
      checkIn: checkIn == null && nullToAbsent
          ? const Value.absent()
          : Value(checkIn),
      checkOut: checkOut == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOut),
      checkInTime: checkInTime == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInTime),
      checkOutTime: checkOutTime == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOutTime),
      confirmation: confirmation == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmation),
      totalPrice: totalPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPrice),
      pricePerPerson: pricePerPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerPerson),
      pricePerPersonNight: pricePerPersonNight == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerPersonNight),
      mapUrl: mapUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mapUrl),
      hotelImage: hotelImage == null && nullToAbsent
          ? const Value.absent()
          : Value(hotelImage),
      addressEn: addressEn == null && nullToAbsent
          ? const Value.absent()
          : Value(addressEn),
      addressLocal: addressLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLocal),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
    );
  }

  factory Hotel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hotel(
      cityId: serializer.fromJson<int>(json['cityId']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      localName: serializer.fromJson<String?>(json['localName']),
      checkIn: serializer.fromJson<DateTime?>(json['checkIn']),
      checkOut: serializer.fromJson<DateTime?>(json['checkOut']),
      checkInTime: serializer.fromJson<String?>(json['checkInTime']),
      checkOutTime: serializer.fromJson<String?>(json['checkOutTime']),
      confirmation: serializer.fromJson<String?>(json['confirmation']),
      totalPrice: serializer.fromJson<double?>(json['totalPrice']),
      pricePerPerson: serializer.fromJson<double?>(json['pricePerPerson']),
      pricePerPersonNight: serializer.fromJson<double?>(
        json['pricePerPersonNight'],
      ),
      mapUrl: serializer.fromJson<String?>(json['mapUrl']),
      hotelImage: serializer.fromJson<String?>(json['hotelImage']),
      addressEn: serializer.fromJson<String?>(json['addressEn']),
      addressLocal: serializer.fromJson<String?>(json['addressLocal']),
      phone: serializer.fromJson<String?>(json['phone']),
      website: serializer.fromJson<String?>(json['website']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cityId': serializer.toJson<int>(cityId),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'localName': serializer.toJson<String?>(localName),
      'checkIn': serializer.toJson<DateTime?>(checkIn),
      'checkOut': serializer.toJson<DateTime?>(checkOut),
      'checkInTime': serializer.toJson<String?>(checkInTime),
      'checkOutTime': serializer.toJson<String?>(checkOutTime),
      'confirmation': serializer.toJson<String?>(confirmation),
      'totalPrice': serializer.toJson<double?>(totalPrice),
      'pricePerPerson': serializer.toJson<double?>(pricePerPerson),
      'pricePerPersonNight': serializer.toJson<double?>(pricePerPersonNight),
      'mapUrl': serializer.toJson<String?>(mapUrl),
      'hotelImage': serializer.toJson<String?>(hotelImage),
      'addressEn': serializer.toJson<String?>(addressEn),
      'addressLocal': serializer.toJson<String?>(addressLocal),
      'phone': serializer.toJson<String?>(phone),
      'website': serializer.toJson<String?>(website),
    };
  }

  Hotel copyWith({
    int? cityId,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    int? id,
    String? name,
    Value<String?> localName = const Value.absent(),
    Value<DateTime?> checkIn = const Value.absent(),
    Value<DateTime?> checkOut = const Value.absent(),
    Value<String?> checkInTime = const Value.absent(),
    Value<String?> checkOutTime = const Value.absent(),
    Value<String?> confirmation = const Value.absent(),
    Value<double?> totalPrice = const Value.absent(),
    Value<double?> pricePerPerson = const Value.absent(),
    Value<double?> pricePerPersonNight = const Value.absent(),
    Value<String?> mapUrl = const Value.absent(),
    Value<String?> hotelImage = const Value.absent(),
    Value<String?> addressEn = const Value.absent(),
    Value<String?> addressLocal = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> website = const Value.absent(),
  }) => Hotel(
    cityId: cityId ?? this.cityId,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    id: id ?? this.id,
    name: name ?? this.name,
    localName: localName.present ? localName.value : this.localName,
    checkIn: checkIn.present ? checkIn.value : this.checkIn,
    checkOut: checkOut.present ? checkOut.value : this.checkOut,
    checkInTime: checkInTime.present ? checkInTime.value : this.checkInTime,
    checkOutTime: checkOutTime.present ? checkOutTime.value : this.checkOutTime,
    confirmation: confirmation.present ? confirmation.value : this.confirmation,
    totalPrice: totalPrice.present ? totalPrice.value : this.totalPrice,
    pricePerPerson: pricePerPerson.present
        ? pricePerPerson.value
        : this.pricePerPerson,
    pricePerPersonNight: pricePerPersonNight.present
        ? pricePerPersonNight.value
        : this.pricePerPersonNight,
    mapUrl: mapUrl.present ? mapUrl.value : this.mapUrl,
    hotelImage: hotelImage.present ? hotelImage.value : this.hotelImage,
    addressEn: addressEn.present ? addressEn.value : this.addressEn,
    addressLocal: addressLocal.present ? addressLocal.value : this.addressLocal,
    phone: phone.present ? phone.value : this.phone,
    website: website.present ? website.value : this.website,
  );
  Hotel copyWithCompanion(HotelsCompanion data) {
    return Hotel(
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      localName: data.localName.present ? data.localName.value : this.localName,
      checkIn: data.checkIn.present ? data.checkIn.value : this.checkIn,
      checkOut: data.checkOut.present ? data.checkOut.value : this.checkOut,
      checkInTime: data.checkInTime.present
          ? data.checkInTime.value
          : this.checkInTime,
      checkOutTime: data.checkOutTime.present
          ? data.checkOutTime.value
          : this.checkOutTime,
      confirmation: data.confirmation.present
          ? data.confirmation.value
          : this.confirmation,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
      pricePerPerson: data.pricePerPerson.present
          ? data.pricePerPerson.value
          : this.pricePerPerson,
      pricePerPersonNight: data.pricePerPersonNight.present
          ? data.pricePerPersonNight.value
          : this.pricePerPersonNight,
      mapUrl: data.mapUrl.present ? data.mapUrl.value : this.mapUrl,
      hotelImage: data.hotelImage.present
          ? data.hotelImage.value
          : this.hotelImage,
      addressEn: data.addressEn.present ? data.addressEn.value : this.addressEn,
      addressLocal: data.addressLocal.present
          ? data.addressLocal.value
          : this.addressLocal,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hotel(')
          ..write('cityId: $cityId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('localName: $localName, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('checkOutTime: $checkOutTime, ')
          ..write('confirmation: $confirmation, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('pricePerPerson: $pricePerPerson, ')
          ..write('pricePerPersonNight: $pricePerPersonNight, ')
          ..write('mapUrl: $mapUrl, ')
          ..write('hotelImage: $hotelImage, ')
          ..write('addressEn: $addressEn, ')
          ..write('addressLocal: $addressLocal, ')
          ..write('phone: $phone, ')
          ..write('website: $website')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cityId,
    lat,
    lng,
    id,
    name,
    localName,
    checkIn,
    checkOut,
    checkInTime,
    checkOutTime,
    confirmation,
    totalPrice,
    pricePerPerson,
    pricePerPersonNight,
    mapUrl,
    hotelImage,
    addressEn,
    addressLocal,
    phone,
    website,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hotel &&
          other.cityId == this.cityId &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.id == this.id &&
          other.name == this.name &&
          other.localName == this.localName &&
          other.checkIn == this.checkIn &&
          other.checkOut == this.checkOut &&
          other.checkInTime == this.checkInTime &&
          other.checkOutTime == this.checkOutTime &&
          other.confirmation == this.confirmation &&
          other.totalPrice == this.totalPrice &&
          other.pricePerPerson == this.pricePerPerson &&
          other.pricePerPersonNight == this.pricePerPersonNight &&
          other.mapUrl == this.mapUrl &&
          other.hotelImage == this.hotelImage &&
          other.addressEn == this.addressEn &&
          other.addressLocal == this.addressLocal &&
          other.phone == this.phone &&
          other.website == this.website);
}

class HotelsCompanion extends UpdateCompanion<Hotel> {
  final Value<int> cityId;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<int> id;
  final Value<String> name;
  final Value<String?> localName;
  final Value<DateTime?> checkIn;
  final Value<DateTime?> checkOut;
  final Value<String?> checkInTime;
  final Value<String?> checkOutTime;
  final Value<String?> confirmation;
  final Value<double?> totalPrice;
  final Value<double?> pricePerPerson;
  final Value<double?> pricePerPersonNight;
  final Value<String?> mapUrl;
  final Value<String?> hotelImage;
  final Value<String?> addressEn;
  final Value<String?> addressLocal;
  final Value<String?> phone;
  final Value<String?> website;
  const HotelsCompanion({
    this.cityId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.localName = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.checkInTime = const Value.absent(),
    this.checkOutTime = const Value.absent(),
    this.confirmation = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.pricePerPerson = const Value.absent(),
    this.pricePerPersonNight = const Value.absent(),
    this.mapUrl = const Value.absent(),
    this.hotelImage = const Value.absent(),
    this.addressEn = const Value.absent(),
    this.addressLocal = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
  });
  HotelsCompanion.insert({
    required int cityId,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.localName = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.checkInTime = const Value.absent(),
    this.checkOutTime = const Value.absent(),
    this.confirmation = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.pricePerPerson = const Value.absent(),
    this.pricePerPersonNight = const Value.absent(),
    this.mapUrl = const Value.absent(),
    this.hotelImage = const Value.absent(),
    this.addressEn = const Value.absent(),
    this.addressLocal = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
  }) : cityId = Value(cityId),
       name = Value(name);
  static Insertable<Hotel> custom({
    Expression<int>? cityId,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? localName,
    Expression<DateTime>? checkIn,
    Expression<DateTime>? checkOut,
    Expression<String>? checkInTime,
    Expression<String>? checkOutTime,
    Expression<String>? confirmation,
    Expression<double>? totalPrice,
    Expression<double>? pricePerPerson,
    Expression<double>? pricePerPersonNight,
    Expression<String>? mapUrl,
    Expression<String>? hotelImage,
    Expression<String>? addressEn,
    Expression<String>? addressLocal,
    Expression<String>? phone,
    Expression<String>? website,
  }) {
    return RawValuesInsertable({
      if (cityId != null) 'city_id': cityId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (localName != null) 'local_name': localName,
      if (checkIn != null) 'check_in': checkIn,
      if (checkOut != null) 'check_out': checkOut,
      if (checkInTime != null) 'check_in_time': checkInTime,
      if (checkOutTime != null) 'check_out_time': checkOutTime,
      if (confirmation != null) 'confirmation': confirmation,
      if (totalPrice != null) 'total_price': totalPrice,
      if (pricePerPerson != null) 'price_per_person': pricePerPerson,
      if (pricePerPersonNight != null)
        'price_per_person_night': pricePerPersonNight,
      if (mapUrl != null) 'map_url': mapUrl,
      if (hotelImage != null) 'hotel_image': hotelImage,
      if (addressEn != null) 'address_en': addressEn,
      if (addressLocal != null) 'address_local': addressLocal,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
    });
  }

  HotelsCompanion copyWith({
    Value<int>? cityId,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<int>? id,
    Value<String>? name,
    Value<String?>? localName,
    Value<DateTime?>? checkIn,
    Value<DateTime?>? checkOut,
    Value<String?>? checkInTime,
    Value<String?>? checkOutTime,
    Value<String?>? confirmation,
    Value<double?>? totalPrice,
    Value<double?>? pricePerPerson,
    Value<double?>? pricePerPersonNight,
    Value<String?>? mapUrl,
    Value<String?>? hotelImage,
    Value<String?>? addressEn,
    Value<String?>? addressLocal,
    Value<String?>? phone,
    Value<String?>? website,
  }) {
    return HotelsCompanion(
      cityId: cityId ?? this.cityId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      id: id ?? this.id,
      name: name ?? this.name,
      localName: localName ?? this.localName,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      confirmation: confirmation ?? this.confirmation,
      totalPrice: totalPrice ?? this.totalPrice,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      pricePerPersonNight: pricePerPersonNight ?? this.pricePerPersonNight,
      mapUrl: mapUrl ?? this.mapUrl,
      hotelImage: hotelImage ?? this.hotelImage,
      addressEn: addressEn ?? this.addressEn,
      addressLocal: addressLocal ?? this.addressLocal,
      phone: phone ?? this.phone,
      website: website ?? this.website,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cityId.present) {
      map['city_id'] = Variable<int>(cityId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (localName.present) {
      map['local_name'] = Variable<String>(localName.value);
    }
    if (checkIn.present) {
      map['check_in'] = Variable<DateTime>(checkIn.value);
    }
    if (checkOut.present) {
      map['check_out'] = Variable<DateTime>(checkOut.value);
    }
    if (checkInTime.present) {
      map['check_in_time'] = Variable<String>(checkInTime.value);
    }
    if (checkOutTime.present) {
      map['check_out_time'] = Variable<String>(checkOutTime.value);
    }
    if (confirmation.present) {
      map['confirmation'] = Variable<String>(confirmation.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (pricePerPerson.present) {
      map['price_per_person'] = Variable<double>(pricePerPerson.value);
    }
    if (pricePerPersonNight.present) {
      map['price_per_person_night'] = Variable<double>(
        pricePerPersonNight.value,
      );
    }
    if (mapUrl.present) {
      map['map_url'] = Variable<String>(mapUrl.value);
    }
    if (hotelImage.present) {
      map['hotel_image'] = Variable<String>(hotelImage.value);
    }
    if (addressEn.present) {
      map['address_en'] = Variable<String>(addressEn.value);
    }
    if (addressLocal.present) {
      map['address_local'] = Variable<String>(addressLocal.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HotelsCompanion(')
          ..write('cityId: $cityId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('localName: $localName, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('checkOutTime: $checkOutTime, ')
          ..write('confirmation: $confirmation, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('pricePerPerson: $pricePerPerson, ')
          ..write('pricePerPersonNight: $pricePerPersonNight, ')
          ..write('mapUrl: $mapUrl, ')
          ..write('hotelImage: $hotelImage, ')
          ..write('addressEn: $addressEn, ')
          ..write('addressLocal: $addressLocal, ')
          ..write('phone: $phone, ')
          ..write('website: $website')
          ..write(')'))
        .toString();
  }
}

class $FlightsTable extends Flights with TableInfo<$FlightsTable, Flight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _bookingRefMeta = const VerificationMeta(
    'bookingRef',
  );
  @override
  late final GeneratedColumn<String> bookingRef = GeneratedColumn<String>(
    'booking_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seatMeta = const VerificationMeta('seat');
  @override
  late final GeneratedColumn<String> seat = GeneratedColumn<String>(
    'seat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _airlineMeta = const VerificationMeta(
    'airline',
  );
  @override
  late final GeneratedColumn<String> airline = GeneratedColumn<String>(
    'airline',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flightNumberMeta = const VerificationMeta(
    'flightNumber',
  );
  @override
  late final GeneratedColumn<String> flightNumber = GeneratedColumn<String>(
    'flight_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originTerminalMeta = const VerificationMeta(
    'originTerminal',
  );
  @override
  late final GeneratedColumn<String> originTerminal = GeneratedColumn<String>(
    'origin_terminal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationTerminalMeta =
      const VerificationMeta('destinationTerminal');
  @override
  late final GeneratedColumn<String> destinationTerminal =
      GeneratedColumn<String>(
        'destination_terminal',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _departureMeta = const VerificationMeta(
    'departure',
  );
  @override
  late final GeneratedColumn<DateTime> departure = GeneratedColumn<DateTime>(
    'departure',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivalMeta = const VerificationMeta(
    'arrival',
  );
  @override
  late final GeneratedColumn<DateTime> arrival = GeneratedColumn<DateTime>(
    'arrival',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackerUrlMeta = const VerificationMeta(
    'trackerUrl',
  );
  @override
  late final GeneratedColumn<String> trackerUrl = GeneratedColumn<String>(
    'tracker_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    bookingRef,
    status,
    seat,
    id,
    airline,
    flightNumber,
    origin,
    destination,
    originTerminal,
    destinationTerminal,
    departure,
    arrival,
    duration,
    trackerUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Flight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('booking_ref')) {
      context.handle(
        _bookingRefMeta,
        bookingRef.isAcceptableOrUnknown(data['booking_ref']!, _bookingRefMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('seat')) {
      context.handle(
        _seatMeta,
        seat.isAcceptableOrUnknown(data['seat']!, _seatMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('airline')) {
      context.handle(
        _airlineMeta,
        airline.isAcceptableOrUnknown(data['airline']!, _airlineMeta),
      );
    }
    if (data.containsKey('flight_number')) {
      context.handle(
        _flightNumberMeta,
        flightNumber.isAcceptableOrUnknown(
          data['flight_number']!,
          _flightNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_flightNumberMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('origin_terminal')) {
      context.handle(
        _originTerminalMeta,
        originTerminal.isAcceptableOrUnknown(
          data['origin_terminal']!,
          _originTerminalMeta,
        ),
      );
    }
    if (data.containsKey('destination_terminal')) {
      context.handle(
        _destinationTerminalMeta,
        destinationTerminal.isAcceptableOrUnknown(
          data['destination_terminal']!,
          _destinationTerminalMeta,
        ),
      );
    }
    if (data.containsKey('departure')) {
      context.handle(
        _departureMeta,
        departure.isAcceptableOrUnknown(data['departure']!, _departureMeta),
      );
    } else if (isInserting) {
      context.missing(_departureMeta);
    }
    if (data.containsKey('arrival')) {
      context.handle(
        _arrivalMeta,
        arrival.isAcceptableOrUnknown(data['arrival']!, _arrivalMeta),
      );
    } else if (isInserting) {
      context.missing(_arrivalMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('tracker_url')) {
      context.handle(
        _trackerUrlMeta,
        trackerUrl.isAcceptableOrUnknown(data['tracker_url']!, _trackerUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Flight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Flight(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      bookingRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_ref'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      seat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seat'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      airline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}airline'],
      ),
      flightNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flight_number'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      )!,
      originTerminal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_terminal'],
      ),
      destinationTerminal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_terminal'],
      ),
      departure: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}departure'],
      )!,
      arrival: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrival'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      ),
      trackerUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_url'],
      ),
    );
  }

  @override
  $FlightsTable createAlias(String alias) {
    return $FlightsTable(attachedDatabase, alias);
  }
}

class Flight extends DataClass implements Insertable<Flight> {
  final int tripId;
  final String? bookingRef;
  final String? status;
  final String? seat;
  final int id;
  final String? airline;
  final String flightNumber;
  final String origin;
  final String destination;
  final String? originTerminal;
  final String? destinationTerminal;
  final DateTime departure;
  final DateTime arrival;
  final String? duration;
  final String? trackerUrl;
  const Flight({
    required this.tripId,
    this.bookingRef,
    this.status,
    this.seat,
    required this.id,
    this.airline,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    this.originTerminal,
    this.destinationTerminal,
    required this.departure,
    required this.arrival,
    this.duration,
    this.trackerUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    if (!nullToAbsent || bookingRef != null) {
      map['booking_ref'] = Variable<String>(bookingRef);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || seat != null) {
      map['seat'] = Variable<String>(seat);
    }
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || airline != null) {
      map['airline'] = Variable<String>(airline);
    }
    map['flight_number'] = Variable<String>(flightNumber);
    map['origin'] = Variable<String>(origin);
    map['destination'] = Variable<String>(destination);
    if (!nullToAbsent || originTerminal != null) {
      map['origin_terminal'] = Variable<String>(originTerminal);
    }
    if (!nullToAbsent || destinationTerminal != null) {
      map['destination_terminal'] = Variable<String>(destinationTerminal);
    }
    map['departure'] = Variable<DateTime>(departure);
    map['arrival'] = Variable<DateTime>(arrival);
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<String>(duration);
    }
    if (!nullToAbsent || trackerUrl != null) {
      map['tracker_url'] = Variable<String>(trackerUrl);
    }
    return map;
  }

  FlightsCompanion toCompanion(bool nullToAbsent) {
    return FlightsCompanion(
      tripId: Value(tripId),
      bookingRef: bookingRef == null && nullToAbsent
          ? const Value.absent()
          : Value(bookingRef),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      seat: seat == null && nullToAbsent ? const Value.absent() : Value(seat),
      id: Value(id),
      airline: airline == null && nullToAbsent
          ? const Value.absent()
          : Value(airline),
      flightNumber: Value(flightNumber),
      origin: Value(origin),
      destination: Value(destination),
      originTerminal: originTerminal == null && nullToAbsent
          ? const Value.absent()
          : Value(originTerminal),
      destinationTerminal: destinationTerminal == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationTerminal),
      departure: Value(departure),
      arrival: Value(arrival),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      trackerUrl: trackerUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(trackerUrl),
    );
  }

  factory Flight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Flight(
      tripId: serializer.fromJson<int>(json['tripId']),
      bookingRef: serializer.fromJson<String?>(json['bookingRef']),
      status: serializer.fromJson<String?>(json['status']),
      seat: serializer.fromJson<String?>(json['seat']),
      id: serializer.fromJson<int>(json['id']),
      airline: serializer.fromJson<String?>(json['airline']),
      flightNumber: serializer.fromJson<String>(json['flightNumber']),
      origin: serializer.fromJson<String>(json['origin']),
      destination: serializer.fromJson<String>(json['destination']),
      originTerminal: serializer.fromJson<String?>(json['originTerminal']),
      destinationTerminal: serializer.fromJson<String?>(
        json['destinationTerminal'],
      ),
      departure: serializer.fromJson<DateTime>(json['departure']),
      arrival: serializer.fromJson<DateTime>(json['arrival']),
      duration: serializer.fromJson<String?>(json['duration']),
      trackerUrl: serializer.fromJson<String?>(json['trackerUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'bookingRef': serializer.toJson<String?>(bookingRef),
      'status': serializer.toJson<String?>(status),
      'seat': serializer.toJson<String?>(seat),
      'id': serializer.toJson<int>(id),
      'airline': serializer.toJson<String?>(airline),
      'flightNumber': serializer.toJson<String>(flightNumber),
      'origin': serializer.toJson<String>(origin),
      'destination': serializer.toJson<String>(destination),
      'originTerminal': serializer.toJson<String?>(originTerminal),
      'destinationTerminal': serializer.toJson<String?>(destinationTerminal),
      'departure': serializer.toJson<DateTime>(departure),
      'arrival': serializer.toJson<DateTime>(arrival),
      'duration': serializer.toJson<String?>(duration),
      'trackerUrl': serializer.toJson<String?>(trackerUrl),
    };
  }

  Flight copyWith({
    int? tripId,
    Value<String?> bookingRef = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<String?> seat = const Value.absent(),
    int? id,
    Value<String?> airline = const Value.absent(),
    String? flightNumber,
    String? origin,
    String? destination,
    Value<String?> originTerminal = const Value.absent(),
    Value<String?> destinationTerminal = const Value.absent(),
    DateTime? departure,
    DateTime? arrival,
    Value<String?> duration = const Value.absent(),
    Value<String?> trackerUrl = const Value.absent(),
  }) => Flight(
    tripId: tripId ?? this.tripId,
    bookingRef: bookingRef.present ? bookingRef.value : this.bookingRef,
    status: status.present ? status.value : this.status,
    seat: seat.present ? seat.value : this.seat,
    id: id ?? this.id,
    airline: airline.present ? airline.value : this.airline,
    flightNumber: flightNumber ?? this.flightNumber,
    origin: origin ?? this.origin,
    destination: destination ?? this.destination,
    originTerminal: originTerminal.present
        ? originTerminal.value
        : this.originTerminal,
    destinationTerminal: destinationTerminal.present
        ? destinationTerminal.value
        : this.destinationTerminal,
    departure: departure ?? this.departure,
    arrival: arrival ?? this.arrival,
    duration: duration.present ? duration.value : this.duration,
    trackerUrl: trackerUrl.present ? trackerUrl.value : this.trackerUrl,
  );
  Flight copyWithCompanion(FlightsCompanion data) {
    return Flight(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      bookingRef: data.bookingRef.present
          ? data.bookingRef.value
          : this.bookingRef,
      status: data.status.present ? data.status.value : this.status,
      seat: data.seat.present ? data.seat.value : this.seat,
      id: data.id.present ? data.id.value : this.id,
      airline: data.airline.present ? data.airline.value : this.airline,
      flightNumber: data.flightNumber.present
          ? data.flightNumber.value
          : this.flightNumber,
      origin: data.origin.present ? data.origin.value : this.origin,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      originTerminal: data.originTerminal.present
          ? data.originTerminal.value
          : this.originTerminal,
      destinationTerminal: data.destinationTerminal.present
          ? data.destinationTerminal.value
          : this.destinationTerminal,
      departure: data.departure.present ? data.departure.value : this.departure,
      arrival: data.arrival.present ? data.arrival.value : this.arrival,
      duration: data.duration.present ? data.duration.value : this.duration,
      trackerUrl: data.trackerUrl.present
          ? data.trackerUrl.value
          : this.trackerUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Flight(')
          ..write('tripId: $tripId, ')
          ..write('bookingRef: $bookingRef, ')
          ..write('status: $status, ')
          ..write('seat: $seat, ')
          ..write('id: $id, ')
          ..write('airline: $airline, ')
          ..write('flightNumber: $flightNumber, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('originTerminal: $originTerminal, ')
          ..write('destinationTerminal: $destinationTerminal, ')
          ..write('departure: $departure, ')
          ..write('arrival: $arrival, ')
          ..write('duration: $duration, ')
          ..write('trackerUrl: $trackerUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tripId,
    bookingRef,
    status,
    seat,
    id,
    airline,
    flightNumber,
    origin,
    destination,
    originTerminal,
    destinationTerminal,
    departure,
    arrival,
    duration,
    trackerUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Flight &&
          other.tripId == this.tripId &&
          other.bookingRef == this.bookingRef &&
          other.status == this.status &&
          other.seat == this.seat &&
          other.id == this.id &&
          other.airline == this.airline &&
          other.flightNumber == this.flightNumber &&
          other.origin == this.origin &&
          other.destination == this.destination &&
          other.originTerminal == this.originTerminal &&
          other.destinationTerminal == this.destinationTerminal &&
          other.departure == this.departure &&
          other.arrival == this.arrival &&
          other.duration == this.duration &&
          other.trackerUrl == this.trackerUrl);
}

class FlightsCompanion extends UpdateCompanion<Flight> {
  final Value<int> tripId;
  final Value<String?> bookingRef;
  final Value<String?> status;
  final Value<String?> seat;
  final Value<int> id;
  final Value<String?> airline;
  final Value<String> flightNumber;
  final Value<String> origin;
  final Value<String> destination;
  final Value<String?> originTerminal;
  final Value<String?> destinationTerminal;
  final Value<DateTime> departure;
  final Value<DateTime> arrival;
  final Value<String?> duration;
  final Value<String?> trackerUrl;
  const FlightsCompanion({
    this.tripId = const Value.absent(),
    this.bookingRef = const Value.absent(),
    this.status = const Value.absent(),
    this.seat = const Value.absent(),
    this.id = const Value.absent(),
    this.airline = const Value.absent(),
    this.flightNumber = const Value.absent(),
    this.origin = const Value.absent(),
    this.destination = const Value.absent(),
    this.originTerminal = const Value.absent(),
    this.destinationTerminal = const Value.absent(),
    this.departure = const Value.absent(),
    this.arrival = const Value.absent(),
    this.duration = const Value.absent(),
    this.trackerUrl = const Value.absent(),
  });
  FlightsCompanion.insert({
    required int tripId,
    this.bookingRef = const Value.absent(),
    this.status = const Value.absent(),
    this.seat = const Value.absent(),
    this.id = const Value.absent(),
    this.airline = const Value.absent(),
    required String flightNumber,
    required String origin,
    required String destination,
    this.originTerminal = const Value.absent(),
    this.destinationTerminal = const Value.absent(),
    required DateTime departure,
    required DateTime arrival,
    this.duration = const Value.absent(),
    this.trackerUrl = const Value.absent(),
  }) : tripId = Value(tripId),
       flightNumber = Value(flightNumber),
       origin = Value(origin),
       destination = Value(destination),
       departure = Value(departure),
       arrival = Value(arrival);
  static Insertable<Flight> custom({
    Expression<int>? tripId,
    Expression<String>? bookingRef,
    Expression<String>? status,
    Expression<String>? seat,
    Expression<int>? id,
    Expression<String>? airline,
    Expression<String>? flightNumber,
    Expression<String>? origin,
    Expression<String>? destination,
    Expression<String>? originTerminal,
    Expression<String>? destinationTerminal,
    Expression<DateTime>? departure,
    Expression<DateTime>? arrival,
    Expression<String>? duration,
    Expression<String>? trackerUrl,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (bookingRef != null) 'booking_ref': bookingRef,
      if (status != null) 'status': status,
      if (seat != null) 'seat': seat,
      if (id != null) 'id': id,
      if (airline != null) 'airline': airline,
      if (flightNumber != null) 'flight_number': flightNumber,
      if (origin != null) 'origin': origin,
      if (destination != null) 'destination': destination,
      if (originTerminal != null) 'origin_terminal': originTerminal,
      if (destinationTerminal != null)
        'destination_terminal': destinationTerminal,
      if (departure != null) 'departure': departure,
      if (arrival != null) 'arrival': arrival,
      if (duration != null) 'duration': duration,
      if (trackerUrl != null) 'tracker_url': trackerUrl,
    });
  }

  FlightsCompanion copyWith({
    Value<int>? tripId,
    Value<String?>? bookingRef,
    Value<String?>? status,
    Value<String?>? seat,
    Value<int>? id,
    Value<String?>? airline,
    Value<String>? flightNumber,
    Value<String>? origin,
    Value<String>? destination,
    Value<String?>? originTerminal,
    Value<String?>? destinationTerminal,
    Value<DateTime>? departure,
    Value<DateTime>? arrival,
    Value<String?>? duration,
    Value<String?>? trackerUrl,
  }) {
    return FlightsCompanion(
      tripId: tripId ?? this.tripId,
      bookingRef: bookingRef ?? this.bookingRef,
      status: status ?? this.status,
      seat: seat ?? this.seat,
      id: id ?? this.id,
      airline: airline ?? this.airline,
      flightNumber: flightNumber ?? this.flightNumber,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      originTerminal: originTerminal ?? this.originTerminal,
      destinationTerminal: destinationTerminal ?? this.destinationTerminal,
      departure: departure ?? this.departure,
      arrival: arrival ?? this.arrival,
      duration: duration ?? this.duration,
      trackerUrl: trackerUrl ?? this.trackerUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (bookingRef.present) {
      map['booking_ref'] = Variable<String>(bookingRef.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (seat.present) {
      map['seat'] = Variable<String>(seat.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (airline.present) {
      map['airline'] = Variable<String>(airline.value);
    }
    if (flightNumber.present) {
      map['flight_number'] = Variable<String>(flightNumber.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (originTerminal.present) {
      map['origin_terminal'] = Variable<String>(originTerminal.value);
    }
    if (destinationTerminal.present) {
      map['destination_terminal'] = Variable<String>(destinationTerminal.value);
    }
    if (departure.present) {
      map['departure'] = Variable<DateTime>(departure.value);
    }
    if (arrival.present) {
      map['arrival'] = Variable<DateTime>(arrival.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (trackerUrl.present) {
      map['tracker_url'] = Variable<String>(trackerUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('bookingRef: $bookingRef, ')
          ..write('status: $status, ')
          ..write('seat: $seat, ')
          ..write('id: $id, ')
          ..write('airline: $airline, ')
          ..write('flightNumber: $flightNumber, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('originTerminal: $originTerminal, ')
          ..write('destinationTerminal: $destinationTerminal, ')
          ..write('departure: $departure, ')
          ..write('arrival: $arrival, ')
          ..write('duration: $duration, ')
          ..write('trackerUrl: $trackerUrl')
          ..write(')'))
        .toString();
  }
}

class $TrainsTable extends Trains with TableInfo<$TrainsTable, Train> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _bookingRefMeta = const VerificationMeta(
    'bookingRef',
  );
  @override
  late final GeneratedColumn<String> bookingRef = GeneratedColumn<String>(
    'booking_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seatMeta = const VerificationMeta('seat');
  @override
  late final GeneratedColumn<String> seat = GeneratedColumn<String>(
    'seat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _trainNumberMeta = const VerificationMeta(
    'trainNumber',
  );
  @override
  late final GeneratedColumn<String> trainNumber = GeneratedColumn<String>(
    'train_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departureMeta = const VerificationMeta(
    'departure',
  );
  @override
  late final GeneratedColumn<DateTime> departure = GeneratedColumn<DateTime>(
    'departure',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivalMeta = const VerificationMeta(
    'arrival',
  );
  @override
  late final GeneratedColumn<DateTime> arrival = GeneratedColumn<DateTime>(
    'arrival',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ticketPricePerPersonMeta =
      const VerificationMeta('ticketPricePerPerson');
  @override
  late final GeneratedColumn<double> ticketPricePerPerson =
      GeneratedColumn<double>(
        'ticket_price_per_person',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bookingFeePerPersonMeta =
      const VerificationMeta('bookingFeePerPerson');
  @override
  late final GeneratedColumn<double> bookingFeePerPerson =
      GeneratedColumn<double>(
        'booking_fee_per_person',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _totalPricePerPersonMeta =
      const VerificationMeta('totalPricePerPerson');
  @override
  late final GeneratedColumn<double> totalPricePerPerson =
      GeneratedColumn<double>(
        'total_price_per_person',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    bookingRef,
    status,
    seat,
    id,
    trainNumber,
    origin,
    destination,
    departure,
    arrival,
    duration,
    platform,
    ticketPricePerPerson,
    bookingFeePerPerson,
    totalPricePerPerson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trains';
  @override
  VerificationContext validateIntegrity(
    Insertable<Train> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('booking_ref')) {
      context.handle(
        _bookingRefMeta,
        bookingRef.isAcceptableOrUnknown(data['booking_ref']!, _bookingRefMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('seat')) {
      context.handle(
        _seatMeta,
        seat.isAcceptableOrUnknown(data['seat']!, _seatMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('train_number')) {
      context.handle(
        _trainNumberMeta,
        trainNumber.isAcceptableOrUnknown(
          data['train_number']!,
          _trainNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trainNumberMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('departure')) {
      context.handle(
        _departureMeta,
        departure.isAcceptableOrUnknown(data['departure']!, _departureMeta),
      );
    } else if (isInserting) {
      context.missing(_departureMeta);
    }
    if (data.containsKey('arrival')) {
      context.handle(
        _arrivalMeta,
        arrival.isAcceptableOrUnknown(data['arrival']!, _arrivalMeta),
      );
    } else if (isInserting) {
      context.missing(_arrivalMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    }
    if (data.containsKey('ticket_price_per_person')) {
      context.handle(
        _ticketPricePerPersonMeta,
        ticketPricePerPerson.isAcceptableOrUnknown(
          data['ticket_price_per_person']!,
          _ticketPricePerPersonMeta,
        ),
      );
    }
    if (data.containsKey('booking_fee_per_person')) {
      context.handle(
        _bookingFeePerPersonMeta,
        bookingFeePerPerson.isAcceptableOrUnknown(
          data['booking_fee_per_person']!,
          _bookingFeePerPersonMeta,
        ),
      );
    }
    if (data.containsKey('total_price_per_person')) {
      context.handle(
        _totalPricePerPersonMeta,
        totalPricePerPerson.isAcceptableOrUnknown(
          data['total_price_per_person']!,
          _totalPricePerPersonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Train map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Train(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      bookingRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_ref'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      seat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seat'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trainNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}train_number'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      )!,
      departure: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}departure'],
      )!,
      arrival: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrival'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      ),
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      ),
      ticketPricePerPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ticket_price_per_person'],
      ),
      bookingFeePerPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}booking_fee_per_person'],
      ),
      totalPricePerPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price_per_person'],
      ),
    );
  }

  @override
  $TrainsTable createAlias(String alias) {
    return $TrainsTable(attachedDatabase, alias);
  }
}

class Train extends DataClass implements Insertable<Train> {
  final int tripId;
  final String? bookingRef;
  final String? status;
  final String? seat;
  final int id;
  final String trainNumber;
  final String origin;
  final String destination;
  final DateTime departure;
  final DateTime arrival;
  final String? duration;
  final String? platform;
  final double? ticketPricePerPerson;
  final double? bookingFeePerPerson;
  final double? totalPricePerPerson;
  const Train({
    required this.tripId,
    this.bookingRef,
    this.status,
    this.seat,
    required this.id,
    required this.trainNumber,
    required this.origin,
    required this.destination,
    required this.departure,
    required this.arrival,
    this.duration,
    this.platform,
    this.ticketPricePerPerson,
    this.bookingFeePerPerson,
    this.totalPricePerPerson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    if (!nullToAbsent || bookingRef != null) {
      map['booking_ref'] = Variable<String>(bookingRef);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || seat != null) {
      map['seat'] = Variable<String>(seat);
    }
    map['id'] = Variable<int>(id);
    map['train_number'] = Variable<String>(trainNumber);
    map['origin'] = Variable<String>(origin);
    map['destination'] = Variable<String>(destination);
    map['departure'] = Variable<DateTime>(departure);
    map['arrival'] = Variable<DateTime>(arrival);
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<String>(duration);
    }
    if (!nullToAbsent || platform != null) {
      map['platform'] = Variable<String>(platform);
    }
    if (!nullToAbsent || ticketPricePerPerson != null) {
      map['ticket_price_per_person'] = Variable<double>(ticketPricePerPerson);
    }
    if (!nullToAbsent || bookingFeePerPerson != null) {
      map['booking_fee_per_person'] = Variable<double>(bookingFeePerPerson);
    }
    if (!nullToAbsent || totalPricePerPerson != null) {
      map['total_price_per_person'] = Variable<double>(totalPricePerPerson);
    }
    return map;
  }

  TrainsCompanion toCompanion(bool nullToAbsent) {
    return TrainsCompanion(
      tripId: Value(tripId),
      bookingRef: bookingRef == null && nullToAbsent
          ? const Value.absent()
          : Value(bookingRef),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      seat: seat == null && nullToAbsent ? const Value.absent() : Value(seat),
      id: Value(id),
      trainNumber: Value(trainNumber),
      origin: Value(origin),
      destination: Value(destination),
      departure: Value(departure),
      arrival: Value(arrival),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      ticketPricePerPerson: ticketPricePerPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(ticketPricePerPerson),
      bookingFeePerPerson: bookingFeePerPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(bookingFeePerPerson),
      totalPricePerPerson: totalPricePerPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPricePerPerson),
    );
  }

  factory Train.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Train(
      tripId: serializer.fromJson<int>(json['tripId']),
      bookingRef: serializer.fromJson<String?>(json['bookingRef']),
      status: serializer.fromJson<String?>(json['status']),
      seat: serializer.fromJson<String?>(json['seat']),
      id: serializer.fromJson<int>(json['id']),
      trainNumber: serializer.fromJson<String>(json['trainNumber']),
      origin: serializer.fromJson<String>(json['origin']),
      destination: serializer.fromJson<String>(json['destination']),
      departure: serializer.fromJson<DateTime>(json['departure']),
      arrival: serializer.fromJson<DateTime>(json['arrival']),
      duration: serializer.fromJson<String?>(json['duration']),
      platform: serializer.fromJson<String?>(json['platform']),
      ticketPricePerPerson: serializer.fromJson<double?>(
        json['ticketPricePerPerson'],
      ),
      bookingFeePerPerson: serializer.fromJson<double?>(
        json['bookingFeePerPerson'],
      ),
      totalPricePerPerson: serializer.fromJson<double?>(
        json['totalPricePerPerson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'bookingRef': serializer.toJson<String?>(bookingRef),
      'status': serializer.toJson<String?>(status),
      'seat': serializer.toJson<String?>(seat),
      'id': serializer.toJson<int>(id),
      'trainNumber': serializer.toJson<String>(trainNumber),
      'origin': serializer.toJson<String>(origin),
      'destination': serializer.toJson<String>(destination),
      'departure': serializer.toJson<DateTime>(departure),
      'arrival': serializer.toJson<DateTime>(arrival),
      'duration': serializer.toJson<String?>(duration),
      'platform': serializer.toJson<String?>(platform),
      'ticketPricePerPerson': serializer.toJson<double?>(ticketPricePerPerson),
      'bookingFeePerPerson': serializer.toJson<double?>(bookingFeePerPerson),
      'totalPricePerPerson': serializer.toJson<double?>(totalPricePerPerson),
    };
  }

  Train copyWith({
    int? tripId,
    Value<String?> bookingRef = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<String?> seat = const Value.absent(),
    int? id,
    String? trainNumber,
    String? origin,
    String? destination,
    DateTime? departure,
    DateTime? arrival,
    Value<String?> duration = const Value.absent(),
    Value<String?> platform = const Value.absent(),
    Value<double?> ticketPricePerPerson = const Value.absent(),
    Value<double?> bookingFeePerPerson = const Value.absent(),
    Value<double?> totalPricePerPerson = const Value.absent(),
  }) => Train(
    tripId: tripId ?? this.tripId,
    bookingRef: bookingRef.present ? bookingRef.value : this.bookingRef,
    status: status.present ? status.value : this.status,
    seat: seat.present ? seat.value : this.seat,
    id: id ?? this.id,
    trainNumber: trainNumber ?? this.trainNumber,
    origin: origin ?? this.origin,
    destination: destination ?? this.destination,
    departure: departure ?? this.departure,
    arrival: arrival ?? this.arrival,
    duration: duration.present ? duration.value : this.duration,
    platform: platform.present ? platform.value : this.platform,
    ticketPricePerPerson: ticketPricePerPerson.present
        ? ticketPricePerPerson.value
        : this.ticketPricePerPerson,
    bookingFeePerPerson: bookingFeePerPerson.present
        ? bookingFeePerPerson.value
        : this.bookingFeePerPerson,
    totalPricePerPerson: totalPricePerPerson.present
        ? totalPricePerPerson.value
        : this.totalPricePerPerson,
  );
  Train copyWithCompanion(TrainsCompanion data) {
    return Train(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      bookingRef: data.bookingRef.present
          ? data.bookingRef.value
          : this.bookingRef,
      status: data.status.present ? data.status.value : this.status,
      seat: data.seat.present ? data.seat.value : this.seat,
      id: data.id.present ? data.id.value : this.id,
      trainNumber: data.trainNumber.present
          ? data.trainNumber.value
          : this.trainNumber,
      origin: data.origin.present ? data.origin.value : this.origin,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      departure: data.departure.present ? data.departure.value : this.departure,
      arrival: data.arrival.present ? data.arrival.value : this.arrival,
      duration: data.duration.present ? data.duration.value : this.duration,
      platform: data.platform.present ? data.platform.value : this.platform,
      ticketPricePerPerson: data.ticketPricePerPerson.present
          ? data.ticketPricePerPerson.value
          : this.ticketPricePerPerson,
      bookingFeePerPerson: data.bookingFeePerPerson.present
          ? data.bookingFeePerPerson.value
          : this.bookingFeePerPerson,
      totalPricePerPerson: data.totalPricePerPerson.present
          ? data.totalPricePerPerson.value
          : this.totalPricePerPerson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Train(')
          ..write('tripId: $tripId, ')
          ..write('bookingRef: $bookingRef, ')
          ..write('status: $status, ')
          ..write('seat: $seat, ')
          ..write('id: $id, ')
          ..write('trainNumber: $trainNumber, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('departure: $departure, ')
          ..write('arrival: $arrival, ')
          ..write('duration: $duration, ')
          ..write('platform: $platform, ')
          ..write('ticketPricePerPerson: $ticketPricePerPerson, ')
          ..write('bookingFeePerPerson: $bookingFeePerPerson, ')
          ..write('totalPricePerPerson: $totalPricePerPerson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tripId,
    bookingRef,
    status,
    seat,
    id,
    trainNumber,
    origin,
    destination,
    departure,
    arrival,
    duration,
    platform,
    ticketPricePerPerson,
    bookingFeePerPerson,
    totalPricePerPerson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Train &&
          other.tripId == this.tripId &&
          other.bookingRef == this.bookingRef &&
          other.status == this.status &&
          other.seat == this.seat &&
          other.id == this.id &&
          other.trainNumber == this.trainNumber &&
          other.origin == this.origin &&
          other.destination == this.destination &&
          other.departure == this.departure &&
          other.arrival == this.arrival &&
          other.duration == this.duration &&
          other.platform == this.platform &&
          other.ticketPricePerPerson == this.ticketPricePerPerson &&
          other.bookingFeePerPerson == this.bookingFeePerPerson &&
          other.totalPricePerPerson == this.totalPricePerPerson);
}

class TrainsCompanion extends UpdateCompanion<Train> {
  final Value<int> tripId;
  final Value<String?> bookingRef;
  final Value<String?> status;
  final Value<String?> seat;
  final Value<int> id;
  final Value<String> trainNumber;
  final Value<String> origin;
  final Value<String> destination;
  final Value<DateTime> departure;
  final Value<DateTime> arrival;
  final Value<String?> duration;
  final Value<String?> platform;
  final Value<double?> ticketPricePerPerson;
  final Value<double?> bookingFeePerPerson;
  final Value<double?> totalPricePerPerson;
  const TrainsCompanion({
    this.tripId = const Value.absent(),
    this.bookingRef = const Value.absent(),
    this.status = const Value.absent(),
    this.seat = const Value.absent(),
    this.id = const Value.absent(),
    this.trainNumber = const Value.absent(),
    this.origin = const Value.absent(),
    this.destination = const Value.absent(),
    this.departure = const Value.absent(),
    this.arrival = const Value.absent(),
    this.duration = const Value.absent(),
    this.platform = const Value.absent(),
    this.ticketPricePerPerson = const Value.absent(),
    this.bookingFeePerPerson = const Value.absent(),
    this.totalPricePerPerson = const Value.absent(),
  });
  TrainsCompanion.insert({
    required int tripId,
    this.bookingRef = const Value.absent(),
    this.status = const Value.absent(),
    this.seat = const Value.absent(),
    this.id = const Value.absent(),
    required String trainNumber,
    required String origin,
    required String destination,
    required DateTime departure,
    required DateTime arrival,
    this.duration = const Value.absent(),
    this.platform = const Value.absent(),
    this.ticketPricePerPerson = const Value.absent(),
    this.bookingFeePerPerson = const Value.absent(),
    this.totalPricePerPerson = const Value.absent(),
  }) : tripId = Value(tripId),
       trainNumber = Value(trainNumber),
       origin = Value(origin),
       destination = Value(destination),
       departure = Value(departure),
       arrival = Value(arrival);
  static Insertable<Train> custom({
    Expression<int>? tripId,
    Expression<String>? bookingRef,
    Expression<String>? status,
    Expression<String>? seat,
    Expression<int>? id,
    Expression<String>? trainNumber,
    Expression<String>? origin,
    Expression<String>? destination,
    Expression<DateTime>? departure,
    Expression<DateTime>? arrival,
    Expression<String>? duration,
    Expression<String>? platform,
    Expression<double>? ticketPricePerPerson,
    Expression<double>? bookingFeePerPerson,
    Expression<double>? totalPricePerPerson,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (bookingRef != null) 'booking_ref': bookingRef,
      if (status != null) 'status': status,
      if (seat != null) 'seat': seat,
      if (id != null) 'id': id,
      if (trainNumber != null) 'train_number': trainNumber,
      if (origin != null) 'origin': origin,
      if (destination != null) 'destination': destination,
      if (departure != null) 'departure': departure,
      if (arrival != null) 'arrival': arrival,
      if (duration != null) 'duration': duration,
      if (platform != null) 'platform': platform,
      if (ticketPricePerPerson != null)
        'ticket_price_per_person': ticketPricePerPerson,
      if (bookingFeePerPerson != null)
        'booking_fee_per_person': bookingFeePerPerson,
      if (totalPricePerPerson != null)
        'total_price_per_person': totalPricePerPerson,
    });
  }

  TrainsCompanion copyWith({
    Value<int>? tripId,
    Value<String?>? bookingRef,
    Value<String?>? status,
    Value<String?>? seat,
    Value<int>? id,
    Value<String>? trainNumber,
    Value<String>? origin,
    Value<String>? destination,
    Value<DateTime>? departure,
    Value<DateTime>? arrival,
    Value<String?>? duration,
    Value<String?>? platform,
    Value<double?>? ticketPricePerPerson,
    Value<double?>? bookingFeePerPerson,
    Value<double?>? totalPricePerPerson,
  }) {
    return TrainsCompanion(
      tripId: tripId ?? this.tripId,
      bookingRef: bookingRef ?? this.bookingRef,
      status: status ?? this.status,
      seat: seat ?? this.seat,
      id: id ?? this.id,
      trainNumber: trainNumber ?? this.trainNumber,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departure: departure ?? this.departure,
      arrival: arrival ?? this.arrival,
      duration: duration ?? this.duration,
      platform: platform ?? this.platform,
      ticketPricePerPerson: ticketPricePerPerson ?? this.ticketPricePerPerson,
      bookingFeePerPerson: bookingFeePerPerson ?? this.bookingFeePerPerson,
      totalPricePerPerson: totalPricePerPerson ?? this.totalPricePerPerson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (bookingRef.present) {
      map['booking_ref'] = Variable<String>(bookingRef.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (seat.present) {
      map['seat'] = Variable<String>(seat.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trainNumber.present) {
      map['train_number'] = Variable<String>(trainNumber.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (departure.present) {
      map['departure'] = Variable<DateTime>(departure.value);
    }
    if (arrival.present) {
      map['arrival'] = Variable<DateTime>(arrival.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (ticketPricePerPerson.present) {
      map['ticket_price_per_person'] = Variable<double>(
        ticketPricePerPerson.value,
      );
    }
    if (bookingFeePerPerson.present) {
      map['booking_fee_per_person'] = Variable<double>(
        bookingFeePerPerson.value,
      );
    }
    if (totalPricePerPerson.present) {
      map['total_price_per_person'] = Variable<double>(
        totalPricePerPerson.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('bookingRef: $bookingRef, ')
          ..write('status: $status, ')
          ..write('seat: $seat, ')
          ..write('id: $id, ')
          ..write('trainNumber: $trainNumber, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('departure: $departure, ')
          ..write('arrival: $arrival, ')
          ..write('duration: $duration, ')
          ..write('platform: $platform, ')
          ..write('ticketPricePerPerson: $ticketPricePerPerson, ')
          ..write('bookingFeePerPerson: $bookingFeePerPerson, ')
          ..write('totalPricePerPerson: $totalPricePerPerson')
          ..write(')'))
        .toString();
  }
}

class $ItineraryTable extends Itinerary
    with TableInfo<$ItineraryTable, ItineraryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItineraryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<int> cityId = GeneratedColumn<int>(
    'city_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cities (id)',
    ),
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressEnMeta = const VerificationMeta(
    'addressEn',
  );
  @override
  late final GeneratedColumn<String> addressEn = GeneratedColumn<String>(
    'address_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLocalMeta = const VerificationMeta(
    'addressLocal',
  );
  @override
  late final GeneratedColumn<String> addressLocal = GeneratedColumn<String>(
    'address_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mapUrlMeta = const VerificationMeta('mapUrl');
  @override
  late final GeneratedColumn<String> mapUrl = GeneratedColumn<String>(
    'map_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _availabilityMeta = const VerificationMeta(
    'availability',
  );
  @override
  late final GeneratedColumn<String> availability = GeneratedColumn<String>(
    'availability',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookedAtMeta = const VerificationMeta(
    'bookedAt',
  );
  @override
  late final GeneratedColumn<DateTime> bookedAt = GeneratedColumn<DateTime>(
    'booked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flightIdMeta = const VerificationMeta(
    'flightId',
  );
  @override
  late final GeneratedColumn<int> flightId = GeneratedColumn<int>(
    'flight_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flights (id)',
    ),
  );
  static const VerificationMeta _trainIdMeta = const VerificationMeta(
    'trainId',
  );
  @override
  late final GeneratedColumn<int> trainId = GeneratedColumn<int>(
    'train_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trains (id)',
    ),
  );
  static const VerificationMeta _hotelIdMeta = const VerificationMeta(
    'hotelId',
  );
  @override
  late final GeneratedColumn<int> hotelId = GeneratedColumn<int>(
    'hotel_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hotels (id)',
    ),
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cityId,
    lat,
    lng,
    id,
    date,
    time,
    title,
    type,
    location,
    addressEn,
    addressLocal,
    mapUrl,
    notes,
    url,
    price,
    currency,
    duration,
    availability,
    status,
    bookedAt,
    flightId,
    trainId,
    hotelId,
    image,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'itinerary';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItineraryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('city_id')) {
      context.handle(
        _cityIdMeta,
        cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('address_en')) {
      context.handle(
        _addressEnMeta,
        addressEn.isAcceptableOrUnknown(data['address_en']!, _addressEnMeta),
      );
    }
    if (data.containsKey('address_local')) {
      context.handle(
        _addressLocalMeta,
        addressLocal.isAcceptableOrUnknown(
          data['address_local']!,
          _addressLocalMeta,
        ),
      );
    }
    if (data.containsKey('map_url')) {
      context.handle(
        _mapUrlMeta,
        mapUrl.isAcceptableOrUnknown(data['map_url']!, _mapUrlMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('availability')) {
      context.handle(
        _availabilityMeta,
        availability.isAcceptableOrUnknown(
          data['availability']!,
          _availabilityMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('booked_at')) {
      context.handle(
        _bookedAtMeta,
        bookedAt.isAcceptableOrUnknown(data['booked_at']!, _bookedAtMeta),
      );
    }
    if (data.containsKey('flight_id')) {
      context.handle(
        _flightIdMeta,
        flightId.isAcceptableOrUnknown(data['flight_id']!, _flightIdMeta),
      );
    }
    if (data.containsKey('train_id')) {
      context.handle(
        _trainIdMeta,
        trainId.isAcceptableOrUnknown(data['train_id']!, _trainIdMeta),
      );
    }
    if (data.containsKey('hotel_id')) {
      context.handle(
        _hotelIdMeta,
        hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItineraryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItineraryData(
      cityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}city_id'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      addressEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_en'],
      ),
      addressLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_local'],
      ),
      mapUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}map_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      availability: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      bookedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}booked_at'],
      ),
      flightId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flight_id'],
      ),
      trainId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}train_id'],
      ),
      hotelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hotel_id'],
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
    );
  }

  @override
  $ItineraryTable createAlias(String alias) {
    return $ItineraryTable(attachedDatabase, alias);
  }
}

class ItineraryData extends DataClass implements Insertable<ItineraryData> {
  final int cityId;
  final double? lat;
  final double? lng;
  final int id;
  final DateTime date;
  final String? time;
  final String title;
  final String? type;
  final String? location;
  final String? addressEn;
  final String? addressLocal;
  final String? mapUrl;
  final String? notes;
  final String? url;
  final double? price;
  final String? currency;
  final int? duration;
  final String? availability;
  final String? status;
  final DateTime? bookedAt;
  final int? flightId;
  final int? trainId;
  final int? hotelId;
  final String? image;
  const ItineraryData({
    required this.cityId,
    this.lat,
    this.lng,
    required this.id,
    required this.date,
    this.time,
    required this.title,
    this.type,
    this.location,
    this.addressEn,
    this.addressLocal,
    this.mapUrl,
    this.notes,
    this.url,
    this.price,
    this.currency,
    this.duration,
    this.availability,
    this.status,
    this.bookedAt,
    this.flightId,
    this.trainId,
    this.hotelId,
    this.image,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['city_id'] = Variable<int>(cityId);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || addressEn != null) {
      map['address_en'] = Variable<String>(addressEn);
    }
    if (!nullToAbsent || addressLocal != null) {
      map['address_local'] = Variable<String>(addressLocal);
    }
    if (!nullToAbsent || mapUrl != null) {
      map['map_url'] = Variable<String>(mapUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || availability != null) {
      map['availability'] = Variable<String>(availability);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || bookedAt != null) {
      map['booked_at'] = Variable<DateTime>(bookedAt);
    }
    if (!nullToAbsent || flightId != null) {
      map['flight_id'] = Variable<int>(flightId);
    }
    if (!nullToAbsent || trainId != null) {
      map['train_id'] = Variable<int>(trainId);
    }
    if (!nullToAbsent || hotelId != null) {
      map['hotel_id'] = Variable<int>(hotelId);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    return map;
  }

  ItineraryCompanion toCompanion(bool nullToAbsent) {
    return ItineraryCompanion(
      cityId: Value(cityId),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      id: Value(id),
      date: Value(date),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      title: Value(title),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      addressEn: addressEn == null && nullToAbsent
          ? const Value.absent()
          : Value(addressEn),
      addressLocal: addressLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLocal),
      mapUrl: mapUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mapUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      availability: availability == null && nullToAbsent
          ? const Value.absent()
          : Value(availability),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      bookedAt: bookedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(bookedAt),
      flightId: flightId == null && nullToAbsent
          ? const Value.absent()
          : Value(flightId),
      trainId: trainId == null && nullToAbsent
          ? const Value.absent()
          : Value(trainId),
      hotelId: hotelId == null && nullToAbsent
          ? const Value.absent()
          : Value(hotelId),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
    );
  }

  factory ItineraryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItineraryData(
      cityId: serializer.fromJson<int>(json['cityId']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      time: serializer.fromJson<String?>(json['time']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String?>(json['type']),
      location: serializer.fromJson<String?>(json['location']),
      addressEn: serializer.fromJson<String?>(json['addressEn']),
      addressLocal: serializer.fromJson<String?>(json['addressLocal']),
      mapUrl: serializer.fromJson<String?>(json['mapUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      url: serializer.fromJson<String?>(json['url']),
      price: serializer.fromJson<double?>(json['price']),
      currency: serializer.fromJson<String?>(json['currency']),
      duration: serializer.fromJson<int?>(json['duration']),
      availability: serializer.fromJson<String?>(json['availability']),
      status: serializer.fromJson<String?>(json['status']),
      bookedAt: serializer.fromJson<DateTime?>(json['bookedAt']),
      flightId: serializer.fromJson<int?>(json['flightId']),
      trainId: serializer.fromJson<int?>(json['trainId']),
      hotelId: serializer.fromJson<int?>(json['hotelId']),
      image: serializer.fromJson<String?>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cityId': serializer.toJson<int>(cityId),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'time': serializer.toJson<String?>(time),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String?>(type),
      'location': serializer.toJson<String?>(location),
      'addressEn': serializer.toJson<String?>(addressEn),
      'addressLocal': serializer.toJson<String?>(addressLocal),
      'mapUrl': serializer.toJson<String?>(mapUrl),
      'notes': serializer.toJson<String?>(notes),
      'url': serializer.toJson<String?>(url),
      'price': serializer.toJson<double?>(price),
      'currency': serializer.toJson<String?>(currency),
      'duration': serializer.toJson<int?>(duration),
      'availability': serializer.toJson<String?>(availability),
      'status': serializer.toJson<String?>(status),
      'bookedAt': serializer.toJson<DateTime?>(bookedAt),
      'flightId': serializer.toJson<int?>(flightId),
      'trainId': serializer.toJson<int?>(trainId),
      'hotelId': serializer.toJson<int?>(hotelId),
      'image': serializer.toJson<String?>(image),
    };
  }

  ItineraryData copyWith({
    int? cityId,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    int? id,
    DateTime? date,
    Value<String?> time = const Value.absent(),
    String? title,
    Value<String?> type = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> addressEn = const Value.absent(),
    Value<String?> addressLocal = const Value.absent(),
    Value<String?> mapUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<double?> price = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    Value<String?> availability = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<DateTime?> bookedAt = const Value.absent(),
    Value<int?> flightId = const Value.absent(),
    Value<int?> trainId = const Value.absent(),
    Value<int?> hotelId = const Value.absent(),
    Value<String?> image = const Value.absent(),
  }) => ItineraryData(
    cityId: cityId ?? this.cityId,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    id: id ?? this.id,
    date: date ?? this.date,
    time: time.present ? time.value : this.time,
    title: title ?? this.title,
    type: type.present ? type.value : this.type,
    location: location.present ? location.value : this.location,
    addressEn: addressEn.present ? addressEn.value : this.addressEn,
    addressLocal: addressLocal.present ? addressLocal.value : this.addressLocal,
    mapUrl: mapUrl.present ? mapUrl.value : this.mapUrl,
    notes: notes.present ? notes.value : this.notes,
    url: url.present ? url.value : this.url,
    price: price.present ? price.value : this.price,
    currency: currency.present ? currency.value : this.currency,
    duration: duration.present ? duration.value : this.duration,
    availability: availability.present ? availability.value : this.availability,
    status: status.present ? status.value : this.status,
    bookedAt: bookedAt.present ? bookedAt.value : this.bookedAt,
    flightId: flightId.present ? flightId.value : this.flightId,
    trainId: trainId.present ? trainId.value : this.trainId,
    hotelId: hotelId.present ? hotelId.value : this.hotelId,
    image: image.present ? image.value : this.image,
  );
  ItineraryData copyWithCompanion(ItineraryCompanion data) {
    return ItineraryData(
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      location: data.location.present ? data.location.value : this.location,
      addressEn: data.addressEn.present ? data.addressEn.value : this.addressEn,
      addressLocal: data.addressLocal.present
          ? data.addressLocal.value
          : this.addressLocal,
      mapUrl: data.mapUrl.present ? data.mapUrl.value : this.mapUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      url: data.url.present ? data.url.value : this.url,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      duration: data.duration.present ? data.duration.value : this.duration,
      availability: data.availability.present
          ? data.availability.value
          : this.availability,
      status: data.status.present ? data.status.value : this.status,
      bookedAt: data.bookedAt.present ? data.bookedAt.value : this.bookedAt,
      flightId: data.flightId.present ? data.flightId.value : this.flightId,
      trainId: data.trainId.present ? data.trainId.value : this.trainId,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      image: data.image.present ? data.image.value : this.image,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItineraryData(')
          ..write('cityId: $cityId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('addressEn: $addressEn, ')
          ..write('addressLocal: $addressLocal, ')
          ..write('mapUrl: $mapUrl, ')
          ..write('notes: $notes, ')
          ..write('url: $url, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('duration: $duration, ')
          ..write('availability: $availability, ')
          ..write('status: $status, ')
          ..write('bookedAt: $bookedAt, ')
          ..write('flightId: $flightId, ')
          ..write('trainId: $trainId, ')
          ..write('hotelId: $hotelId, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    cityId,
    lat,
    lng,
    id,
    date,
    time,
    title,
    type,
    location,
    addressEn,
    addressLocal,
    mapUrl,
    notes,
    url,
    price,
    currency,
    duration,
    availability,
    status,
    bookedAt,
    flightId,
    trainId,
    hotelId,
    image,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItineraryData &&
          other.cityId == this.cityId &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.id == this.id &&
          other.date == this.date &&
          other.time == this.time &&
          other.title == this.title &&
          other.type == this.type &&
          other.location == this.location &&
          other.addressEn == this.addressEn &&
          other.addressLocal == this.addressLocal &&
          other.mapUrl == this.mapUrl &&
          other.notes == this.notes &&
          other.url == this.url &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.duration == this.duration &&
          other.availability == this.availability &&
          other.status == this.status &&
          other.bookedAt == this.bookedAt &&
          other.flightId == this.flightId &&
          other.trainId == this.trainId &&
          other.hotelId == this.hotelId &&
          other.image == this.image);
}

class ItineraryCompanion extends UpdateCompanion<ItineraryData> {
  final Value<int> cityId;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String?> time;
  final Value<String> title;
  final Value<String?> type;
  final Value<String?> location;
  final Value<String?> addressEn;
  final Value<String?> addressLocal;
  final Value<String?> mapUrl;
  final Value<String?> notes;
  final Value<String?> url;
  final Value<double?> price;
  final Value<String?> currency;
  final Value<int?> duration;
  final Value<String?> availability;
  final Value<String?> status;
  final Value<DateTime?> bookedAt;
  final Value<int?> flightId;
  final Value<int?> trainId;
  final Value<int?> hotelId;
  final Value<String?> image;
  const ItineraryCompanion({
    this.cityId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.location = const Value.absent(),
    this.addressEn = const Value.absent(),
    this.addressLocal = const Value.absent(),
    this.mapUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.url = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.duration = const Value.absent(),
    this.availability = const Value.absent(),
    this.status = const Value.absent(),
    this.bookedAt = const Value.absent(),
    this.flightId = const Value.absent(),
    this.trainId = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.image = const Value.absent(),
  });
  ItineraryCompanion.insert({
    required int cityId,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.id = const Value.absent(),
    required DateTime date,
    this.time = const Value.absent(),
    required String title,
    this.type = const Value.absent(),
    this.location = const Value.absent(),
    this.addressEn = const Value.absent(),
    this.addressLocal = const Value.absent(),
    this.mapUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.url = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.duration = const Value.absent(),
    this.availability = const Value.absent(),
    this.status = const Value.absent(),
    this.bookedAt = const Value.absent(),
    this.flightId = const Value.absent(),
    this.trainId = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.image = const Value.absent(),
  }) : cityId = Value(cityId),
       date = Value(date),
       title = Value(title);
  static Insertable<ItineraryData> custom({
    Expression<int>? cityId,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? time,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? location,
    Expression<String>? addressEn,
    Expression<String>? addressLocal,
    Expression<String>? mapUrl,
    Expression<String>? notes,
    Expression<String>? url,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<int>? duration,
    Expression<String>? availability,
    Expression<String>? status,
    Expression<DateTime>? bookedAt,
    Expression<int>? flightId,
    Expression<int>? trainId,
    Expression<int>? hotelId,
    Expression<String>? image,
  }) {
    return RawValuesInsertable({
      if (cityId != null) 'city_id': cityId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (location != null) 'location': location,
      if (addressEn != null) 'address_en': addressEn,
      if (addressLocal != null) 'address_local': addressLocal,
      if (mapUrl != null) 'map_url': mapUrl,
      if (notes != null) 'notes': notes,
      if (url != null) 'url': url,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (duration != null) 'duration': duration,
      if (availability != null) 'availability': availability,
      if (status != null) 'status': status,
      if (bookedAt != null) 'booked_at': bookedAt,
      if (flightId != null) 'flight_id': flightId,
      if (trainId != null) 'train_id': trainId,
      if (hotelId != null) 'hotel_id': hotelId,
      if (image != null) 'image': image,
    });
  }

  ItineraryCompanion copyWith({
    Value<int>? cityId,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<int>? id,
    Value<DateTime>? date,
    Value<String?>? time,
    Value<String>? title,
    Value<String?>? type,
    Value<String?>? location,
    Value<String?>? addressEn,
    Value<String?>? addressLocal,
    Value<String?>? mapUrl,
    Value<String?>? notes,
    Value<String?>? url,
    Value<double?>? price,
    Value<String?>? currency,
    Value<int?>? duration,
    Value<String?>? availability,
    Value<String?>? status,
    Value<DateTime?>? bookedAt,
    Value<int?>? flightId,
    Value<int?>? trainId,
    Value<int?>? hotelId,
    Value<String?>? image,
  }) {
    return ItineraryCompanion(
      cityId: cityId ?? this.cityId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      title: title ?? this.title,
      type: type ?? this.type,
      location: location ?? this.location,
      addressEn: addressEn ?? this.addressEn,
      addressLocal: addressLocal ?? this.addressLocal,
      mapUrl: mapUrl ?? this.mapUrl,
      notes: notes ?? this.notes,
      url: url ?? this.url,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      duration: duration ?? this.duration,
      availability: availability ?? this.availability,
      status: status ?? this.status,
      bookedAt: bookedAt ?? this.bookedAt,
      flightId: flightId ?? this.flightId,
      trainId: trainId ?? this.trainId,
      hotelId: hotelId ?? this.hotelId,
      image: image ?? this.image,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cityId.present) {
      map['city_id'] = Variable<int>(cityId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (addressEn.present) {
      map['address_en'] = Variable<String>(addressEn.value);
    }
    if (addressLocal.present) {
      map['address_local'] = Variable<String>(addressLocal.value);
    }
    if (mapUrl.present) {
      map['map_url'] = Variable<String>(mapUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (availability.present) {
      map['availability'] = Variable<String>(availability.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bookedAt.present) {
      map['booked_at'] = Variable<DateTime>(bookedAt.value);
    }
    if (flightId.present) {
      map['flight_id'] = Variable<int>(flightId.value);
    }
    if (trainId.present) {
      map['train_id'] = Variable<int>(trainId.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<int>(hotelId.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItineraryCompanion(')
          ..write('cityId: $cityId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('addressEn: $addressEn, ')
          ..write('addressLocal: $addressLocal, ')
          ..write('mapUrl: $mapUrl, ')
          ..write('notes: $notes, ')
          ..write('url: $url, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('duration: $duration, ')
          ..write('availability: $availability, ')
          ..write('status: $status, ')
          ..write('bookedAt: $bookedAt, ')
          ..write('flightId: $flightId, ')
          ..write('trainId: $trainId, ')
          ..write('hotelId: $hotelId, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }
}

class $PackingItemsTable extends PackingItems
    with TableInfo<$PackingItemsTable, PackingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
    'item',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isPackedMeta = const VerificationMeta(
    'isPacked',
  );
  @override
  late final GeneratedColumn<bool> isPacked = GeneratedColumn<bool>(
    'is_packed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_packed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    id,
    item,
    category,
    quantity,
    isPacked,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packing_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item')) {
      context.handle(
        _itemMeta,
        item.isAcceptableOrUnknown(data['item']!, _itemMeta),
      );
    } else if (isInserting) {
      context.missing(_itemMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('is_packed')) {
      context.handle(
        _isPackedMeta,
        isPacked.isAcceptableOrUnknown(data['is_packed']!, _isPackedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackingItem(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      item: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      isPacked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_packed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PackingItemsTable createAlias(String alias) {
    return $PackingItemsTable(attachedDatabase, alias);
  }
}

class PackingItem extends DataClass implements Insertable<PackingItem> {
  final int tripId;
  final int id;
  final String item;
  final String? category;
  final int quantity;
  final bool isPacked;
  final String? notes;
  const PackingItem({
    required this.tripId,
    required this.id,
    required this.item,
    this.category,
    required this.quantity,
    required this.isPacked,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    map['id'] = Variable<int>(id);
    map['item'] = Variable<String>(item);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['quantity'] = Variable<int>(quantity);
    map['is_packed'] = Variable<bool>(isPacked);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PackingItemsCompanion toCompanion(bool nullToAbsent) {
    return PackingItemsCompanion(
      tripId: Value(tripId),
      id: Value(id),
      item: Value(item),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      quantity: Value(quantity),
      isPacked: Value(isPacked),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PackingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackingItem(
      tripId: serializer.fromJson<int>(json['tripId']),
      id: serializer.fromJson<int>(json['id']),
      item: serializer.fromJson<String>(json['item']),
      category: serializer.fromJson<String?>(json['category']),
      quantity: serializer.fromJson<int>(json['quantity']),
      isPacked: serializer.fromJson<bool>(json['isPacked']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'id': serializer.toJson<int>(id),
      'item': serializer.toJson<String>(item),
      'category': serializer.toJson<String?>(category),
      'quantity': serializer.toJson<int>(quantity),
      'isPacked': serializer.toJson<bool>(isPacked),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PackingItem copyWith({
    int? tripId,
    int? id,
    String? item,
    Value<String?> category = const Value.absent(),
    int? quantity,
    bool? isPacked,
    Value<String?> notes = const Value.absent(),
  }) => PackingItem(
    tripId: tripId ?? this.tripId,
    id: id ?? this.id,
    item: item ?? this.item,
    category: category.present ? category.value : this.category,
    quantity: quantity ?? this.quantity,
    isPacked: isPacked ?? this.isPacked,
    notes: notes.present ? notes.value : this.notes,
  );
  PackingItem copyWithCompanion(PackingItemsCompanion data) {
    return PackingItem(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      id: data.id.present ? data.id.value : this.id,
      item: data.item.present ? data.item.value : this.item,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      isPacked: data.isPacked.present ? data.isPacked.value : this.isPacked,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackingItem(')
          ..write('tripId: $tripId, ')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('isPacked: $isPacked, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tripId, id, item, category, quantity, isPacked, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackingItem &&
          other.tripId == this.tripId &&
          other.id == this.id &&
          other.item == this.item &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.isPacked == this.isPacked &&
          other.notes == this.notes);
}

class PackingItemsCompanion extends UpdateCompanion<PackingItem> {
  final Value<int> tripId;
  final Value<int> id;
  final Value<String> item;
  final Value<String?> category;
  final Value<int> quantity;
  final Value<bool> isPacked;
  final Value<String?> notes;
  const PackingItemsCompanion({
    this.tripId = const Value.absent(),
    this.id = const Value.absent(),
    this.item = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isPacked = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PackingItemsCompanion.insert({
    required int tripId,
    this.id = const Value.absent(),
    required String item,
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isPacked = const Value.absent(),
    this.notes = const Value.absent(),
  }) : tripId = Value(tripId),
       item = Value(item);
  static Insertable<PackingItem> custom({
    Expression<int>? tripId,
    Expression<int>? id,
    Expression<String>? item,
    Expression<String>? category,
    Expression<int>? quantity,
    Expression<bool>? isPacked,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (id != null) 'id': id,
      if (item != null) 'item': item,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (isPacked != null) 'is_packed': isPacked,
      if (notes != null) 'notes': notes,
    });
  }

  PackingItemsCompanion copyWith({
    Value<int>? tripId,
    Value<int>? id,
    Value<String>? item,
    Value<String?>? category,
    Value<int>? quantity,
    Value<bool>? isPacked,
    Value<String?>? notes,
  }) {
    return PackingItemsCompanion(
      tripId: tripId ?? this.tripId,
      id: id ?? this.id,
      item: item ?? this.item,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      isPacked: isPacked ?? this.isPacked,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (isPacked.present) {
      map['is_packed'] = Variable<bool>(isPacked.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackingItemsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('isPacked: $isPacked, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $TripTipsTable extends TripTips with TableInfo<$TripTipsTable, TripTip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripTipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<int> cityId = GeneratedColumn<int>(
    'city_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cities (id)',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    id,
    cityId,
    category,
    title,
    content,
    language,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_tips';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripTip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('city_id')) {
      context.handle(
        _cityIdMeta,
        cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripTip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripTip(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}city_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
    );
  }

  @override
  $TripTipsTable createAlias(String alias) {
    return $TripTipsTable(attachedDatabase, alias);
  }
}

class TripTip extends DataClass implements Insertable<TripTip> {
  final int tripId;
  final int id;
  final int? cityId;
  final String category;
  final String title;
  final String content;
  final String? language;
  const TripTip({
    required this.tripId,
    required this.id,
    this.cityId,
    required this.category,
    required this.title,
    required this.content,
    this.language,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || cityId != null) {
      map['city_id'] = Variable<int>(cityId);
    }
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    return map;
  }

  TripTipsCompanion toCompanion(bool nullToAbsent) {
    return TripTipsCompanion(
      tripId: Value(tripId),
      id: Value(id),
      cityId: cityId == null && nullToAbsent
          ? const Value.absent()
          : Value(cityId),
      category: Value(category),
      title: Value(title),
      content: Value(content),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
    );
  }

  factory TripTip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripTip(
      tripId: serializer.fromJson<int>(json['tripId']),
      id: serializer.fromJson<int>(json['id']),
      cityId: serializer.fromJson<int?>(json['cityId']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      language: serializer.fromJson<String?>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'id': serializer.toJson<int>(id),
      'cityId': serializer.toJson<int?>(cityId),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'language': serializer.toJson<String?>(language),
    };
  }

  TripTip copyWith({
    int? tripId,
    int? id,
    Value<int?> cityId = const Value.absent(),
    String? category,
    String? title,
    String? content,
    Value<String?> language = const Value.absent(),
  }) => TripTip(
    tripId: tripId ?? this.tripId,
    id: id ?? this.id,
    cityId: cityId.present ? cityId.value : this.cityId,
    category: category ?? this.category,
    title: title ?? this.title,
    content: content ?? this.content,
    language: language.present ? language.value : this.language,
  );
  TripTip copyWithCompanion(TripTipsCompanion data) {
    return TripTip(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      id: data.id.present ? data.id.value : this.id,
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      language: data.language.present ? data.language.value : this.language,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripTip(')
          ..write('tripId: $tripId, ')
          ..write('id: $id, ')
          ..write('cityId: $cityId, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tripId, id, cityId, category, title, content, language);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripTip &&
          other.tripId == this.tripId &&
          other.id == this.id &&
          other.cityId == this.cityId &&
          other.category == this.category &&
          other.title == this.title &&
          other.content == this.content &&
          other.language == this.language);
}

class TripTipsCompanion extends UpdateCompanion<TripTip> {
  final Value<int> tripId;
  final Value<int> id;
  final Value<int?> cityId;
  final Value<String> category;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> language;
  const TripTipsCompanion({
    this.tripId = const Value.absent(),
    this.id = const Value.absent(),
    this.cityId = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.language = const Value.absent(),
  });
  TripTipsCompanion.insert({
    required int tripId,
    this.id = const Value.absent(),
    this.cityId = const Value.absent(),
    required String category,
    required String title,
    required String content,
    this.language = const Value.absent(),
  }) : tripId = Value(tripId),
       category = Value(category),
       title = Value(title),
       content = Value(content);
  static Insertable<TripTip> custom({
    Expression<int>? tripId,
    Expression<int>? id,
    Expression<int>? cityId,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? language,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (id != null) 'id': id,
      if (cityId != null) 'city_id': cityId,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (language != null) 'language': language,
    });
  }

  TripTipsCompanion copyWith({
    Value<int>? tripId,
    Value<int>? id,
    Value<int?>? cityId,
    Value<String>? category,
    Value<String>? title,
    Value<String>? content,
    Value<String?>? language,
  }) {
    return TripTipsCompanion(
      tripId: tripId ?? this.tripId,
      id: id ?? this.id,
      cityId: cityId ?? this.cityId,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      language: language ?? this.language,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cityId.present) {
      map['city_id'] = Variable<int>(cityId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripTipsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('id: $id, ')
          ..write('cityId: $cityId, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }
}

class $CitySummariesTable extends CitySummaries
    with TableInfo<$CitySummariesTable, CitySummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitySummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<int> cityId = GeneratedColumn<int>(
    'city_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cities (id)',
    ),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _summaryTextMeta = const VerificationMeta(
    'summaryText',
  );
  @override
  late final GeneratedColumn<String> summaryText = GeneratedColumn<String>(
    'summary_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLanguageMeta = const VerificationMeta(
    'sourceLanguage',
  );
  @override
  late final GeneratedColumn<String> sourceLanguage = GeneratedColumn<String>(
    'source_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    cityId,
    id,
    summaryText,
    sourceLanguage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'city_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitySummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('city_id')) {
      context.handle(
        _cityIdMeta,
        cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('summary_text')) {
      context.handle(
        _summaryTextMeta,
        summaryText.isAcceptableOrUnknown(
          data['summary_text']!,
          _summaryTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_summaryTextMeta);
    }
    if (data.containsKey('source_language')) {
      context.handle(
        _sourceLanguageMeta,
        sourceLanguage.isAcceptableOrUnknown(
          data['source_language']!,
          _sourceLanguageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CitySummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitySummary(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      cityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}city_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      summaryText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_text'],
      )!,
      sourceLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_language'],
      ),
    );
  }

  @override
  $CitySummariesTable createAlias(String alias) {
    return $CitySummariesTable(attachedDatabase, alias);
  }
}

class CitySummary extends DataClass implements Insertable<CitySummary> {
  final int tripId;
  final int cityId;
  final int id;
  final String summaryText;
  final String? sourceLanguage;
  const CitySummary({
    required this.tripId,
    required this.cityId,
    required this.id,
    required this.summaryText,
    this.sourceLanguage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    map['city_id'] = Variable<int>(cityId);
    map['id'] = Variable<int>(id);
    map['summary_text'] = Variable<String>(summaryText);
    if (!nullToAbsent || sourceLanguage != null) {
      map['source_language'] = Variable<String>(sourceLanguage);
    }
    return map;
  }

  CitySummariesCompanion toCompanion(bool nullToAbsent) {
    return CitySummariesCompanion(
      tripId: Value(tripId),
      cityId: Value(cityId),
      id: Value(id),
      summaryText: Value(summaryText),
      sourceLanguage: sourceLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLanguage),
    );
  }

  factory CitySummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitySummary(
      tripId: serializer.fromJson<int>(json['tripId']),
      cityId: serializer.fromJson<int>(json['cityId']),
      id: serializer.fromJson<int>(json['id']),
      summaryText: serializer.fromJson<String>(json['summaryText']),
      sourceLanguage: serializer.fromJson<String?>(json['sourceLanguage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'cityId': serializer.toJson<int>(cityId),
      'id': serializer.toJson<int>(id),
      'summaryText': serializer.toJson<String>(summaryText),
      'sourceLanguage': serializer.toJson<String?>(sourceLanguage),
    };
  }

  CitySummary copyWith({
    int? tripId,
    int? cityId,
    int? id,
    String? summaryText,
    Value<String?> sourceLanguage = const Value.absent(),
  }) => CitySummary(
    tripId: tripId ?? this.tripId,
    cityId: cityId ?? this.cityId,
    id: id ?? this.id,
    summaryText: summaryText ?? this.summaryText,
    sourceLanguage: sourceLanguage.present
        ? sourceLanguage.value
        : this.sourceLanguage,
  );
  CitySummary copyWithCompanion(CitySummariesCompanion data) {
    return CitySummary(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      id: data.id.present ? data.id.value : this.id,
      summaryText: data.summaryText.present
          ? data.summaryText.value
          : this.summaryText,
      sourceLanguage: data.sourceLanguage.present
          ? data.sourceLanguage.value
          : this.sourceLanguage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitySummary(')
          ..write('tripId: $tripId, ')
          ..write('cityId: $cityId, ')
          ..write('id: $id, ')
          ..write('summaryText: $summaryText, ')
          ..write('sourceLanguage: $sourceLanguage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tripId, cityId, id, summaryText, sourceLanguage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitySummary &&
          other.tripId == this.tripId &&
          other.cityId == this.cityId &&
          other.id == this.id &&
          other.summaryText == this.summaryText &&
          other.sourceLanguage == this.sourceLanguage);
}

class CitySummariesCompanion extends UpdateCompanion<CitySummary> {
  final Value<int> tripId;
  final Value<int> cityId;
  final Value<int> id;
  final Value<String> summaryText;
  final Value<String?> sourceLanguage;
  const CitySummariesCompanion({
    this.tripId = const Value.absent(),
    this.cityId = const Value.absent(),
    this.id = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
  });
  CitySummariesCompanion.insert({
    required int tripId,
    required int cityId,
    this.id = const Value.absent(),
    required String summaryText,
    this.sourceLanguage = const Value.absent(),
  }) : tripId = Value(tripId),
       cityId = Value(cityId),
       summaryText = Value(summaryText);
  static Insertable<CitySummary> custom({
    Expression<int>? tripId,
    Expression<int>? cityId,
    Expression<int>? id,
    Expression<String>? summaryText,
    Expression<String>? sourceLanguage,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (cityId != null) 'city_id': cityId,
      if (id != null) 'id': id,
      if (summaryText != null) 'summary_text': summaryText,
      if (sourceLanguage != null) 'source_language': sourceLanguage,
    });
  }

  CitySummariesCompanion copyWith({
    Value<int>? tripId,
    Value<int>? cityId,
    Value<int>? id,
    Value<String>? summaryText,
    Value<String?>? sourceLanguage,
  }) {
    return CitySummariesCompanion(
      tripId: tripId ?? this.tripId,
      cityId: cityId ?? this.cityId,
      id: id ?? this.id,
      summaryText: summaryText ?? this.summaryText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (cityId.present) {
      map['city_id'] = Variable<int>(cityId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (summaryText.present) {
      map['summary_text'] = Variable<String>(summaryText.value);
    }
    if (sourceLanguage.present) {
      map['source_language'] = Variable<String>(sourceLanguage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitySummariesCompanion(')
          ..write('tripId: $tripId, ')
          ..write('cityId: $cityId, ')
          ..write('id: $id, ')
          ..write('summaryText: $summaryText, ')
          ..write('sourceLanguage: $sourceLanguage')
          ..write(')'))
        .toString();
  }
}

class $FoodsTable extends Foods with TableInfo<$FoodsTable, Food> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<int> cityId = GeneratedColumn<int>(
    'city_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cities (id)',
    ),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amapUrlMeta = const VerificationMeta(
    'amapUrl',
  );
  @override
  late final GeneratedColumn<String> amapUrl = GeneratedColumn<String>(
    'amap_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgPriceCnyMeta = const VerificationMeta(
    'avgPriceCny',
  );
  @override
  late final GeneratedColumn<double> avgPriceCny = GeneratedColumn<double>(
    'avg_price_cny',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgPriceEurMeta = const VerificationMeta(
    'avgPriceEur',
  );
  @override
  late final GeneratedColumn<double> avgPriceEur = GeneratedColumn<double>(
    'avg_price_eur',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recommendedDishesMeta = const VerificationMeta(
    'recommendedDishes',
  );
  @override
  late final GeneratedColumn<String> recommendedDishes =
      GeneratedColumn<String>(
        'recommended_dishes',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    cityId,
    id,
    name,
    category,
    amapUrl,
    avgPriceCny,
    avgPriceEur,
    recommendedDishes,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Food> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('city_id')) {
      context.handle(
        _cityIdMeta,
        cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('amap_url')) {
      context.handle(
        _amapUrlMeta,
        amapUrl.isAcceptableOrUnknown(data['amap_url']!, _amapUrlMeta),
      );
    }
    if (data.containsKey('avg_price_cny')) {
      context.handle(
        _avgPriceCnyMeta,
        avgPriceCny.isAcceptableOrUnknown(
          data['avg_price_cny']!,
          _avgPriceCnyMeta,
        ),
      );
    }
    if (data.containsKey('avg_price_eur')) {
      context.handle(
        _avgPriceEurMeta,
        avgPriceEur.isAcceptableOrUnknown(
          data['avg_price_eur']!,
          _avgPriceEurMeta,
        ),
      );
    }
    if (data.containsKey('recommended_dishes')) {
      context.handle(
        _recommendedDishesMeta,
        recommendedDishes.isAcceptableOrUnknown(
          data['recommended_dishes']!,
          _recommendedDishesMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Food map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Food(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      cityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}city_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      amapUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amap_url'],
      ),
      avgPriceCny: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_price_cny'],
      ),
      avgPriceEur: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_price_eur'],
      ),
      recommendedDishes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommended_dishes'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class Food extends DataClass implements Insertable<Food> {
  final int tripId;
  final int cityId;
  final int id;
  final String name;
  final String? category;
  final String? amapUrl;
  final double? avgPriceCny;
  final double? avgPriceEur;
  final String? recommendedDishes;
  final String? notes;
  const Food({
    required this.tripId,
    required this.cityId,
    required this.id,
    required this.name,
    this.category,
    this.amapUrl,
    this.avgPriceCny,
    this.avgPriceEur,
    this.recommendedDishes,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    map['city_id'] = Variable<int>(cityId);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || amapUrl != null) {
      map['amap_url'] = Variable<String>(amapUrl);
    }
    if (!nullToAbsent || avgPriceCny != null) {
      map['avg_price_cny'] = Variable<double>(avgPriceCny);
    }
    if (!nullToAbsent || avgPriceEur != null) {
      map['avg_price_eur'] = Variable<double>(avgPriceEur);
    }
    if (!nullToAbsent || recommendedDishes != null) {
      map['recommended_dishes'] = Variable<String>(recommendedDishes);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      tripId: Value(tripId),
      cityId: Value(cityId),
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      amapUrl: amapUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(amapUrl),
      avgPriceCny: avgPriceCny == null && nullToAbsent
          ? const Value.absent()
          : Value(avgPriceCny),
      avgPriceEur: avgPriceEur == null && nullToAbsent
          ? const Value.absent()
          : Value(avgPriceEur),
      recommendedDishes: recommendedDishes == null && nullToAbsent
          ? const Value.absent()
          : Value(recommendedDishes),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Food.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Food(
      tripId: serializer.fromJson<int>(json['tripId']),
      cityId: serializer.fromJson<int>(json['cityId']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      amapUrl: serializer.fromJson<String?>(json['amapUrl']),
      avgPriceCny: serializer.fromJson<double?>(json['avgPriceCny']),
      avgPriceEur: serializer.fromJson<double?>(json['avgPriceEur']),
      recommendedDishes: serializer.fromJson<String?>(
        json['recommendedDishes'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'cityId': serializer.toJson<int>(cityId),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'amapUrl': serializer.toJson<String?>(amapUrl),
      'avgPriceCny': serializer.toJson<double?>(avgPriceCny),
      'avgPriceEur': serializer.toJson<double?>(avgPriceEur),
      'recommendedDishes': serializer.toJson<String?>(recommendedDishes),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Food copyWith({
    int? tripId,
    int? cityId,
    int? id,
    String? name,
    Value<String?> category = const Value.absent(),
    Value<String?> amapUrl = const Value.absent(),
    Value<double?> avgPriceCny = const Value.absent(),
    Value<double?> avgPriceEur = const Value.absent(),
    Value<String?> recommendedDishes = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Food(
    tripId: tripId ?? this.tripId,
    cityId: cityId ?? this.cityId,
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    amapUrl: amapUrl.present ? amapUrl.value : this.amapUrl,
    avgPriceCny: avgPriceCny.present ? avgPriceCny.value : this.avgPriceCny,
    avgPriceEur: avgPriceEur.present ? avgPriceEur.value : this.avgPriceEur,
    recommendedDishes: recommendedDishes.present
        ? recommendedDishes.value
        : this.recommendedDishes,
    notes: notes.present ? notes.value : this.notes,
  );
  Food copyWithCompanion(FoodsCompanion data) {
    return Food(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      amapUrl: data.amapUrl.present ? data.amapUrl.value : this.amapUrl,
      avgPriceCny: data.avgPriceCny.present
          ? data.avgPriceCny.value
          : this.avgPriceCny,
      avgPriceEur: data.avgPriceEur.present
          ? data.avgPriceEur.value
          : this.avgPriceEur,
      recommendedDishes: data.recommendedDishes.present
          ? data.recommendedDishes.value
          : this.recommendedDishes,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Food(')
          ..write('tripId: $tripId, ')
          ..write('cityId: $cityId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('amapUrl: $amapUrl, ')
          ..write('avgPriceCny: $avgPriceCny, ')
          ..write('avgPriceEur: $avgPriceEur, ')
          ..write('recommendedDishes: $recommendedDishes, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tripId,
    cityId,
    id,
    name,
    category,
    amapUrl,
    avgPriceCny,
    avgPriceEur,
    recommendedDishes,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Food &&
          other.tripId == this.tripId &&
          other.cityId == this.cityId &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.amapUrl == this.amapUrl &&
          other.avgPriceCny == this.avgPriceCny &&
          other.avgPriceEur == this.avgPriceEur &&
          other.recommendedDishes == this.recommendedDishes &&
          other.notes == this.notes);
}

class FoodsCompanion extends UpdateCompanion<Food> {
  final Value<int> tripId;
  final Value<int> cityId;
  final Value<int> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<String?> amapUrl;
  final Value<double?> avgPriceCny;
  final Value<double?> avgPriceEur;
  final Value<String?> recommendedDishes;
  final Value<String?> notes;
  const FoodsCompanion({
    this.tripId = const Value.absent(),
    this.cityId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.amapUrl = const Value.absent(),
    this.avgPriceCny = const Value.absent(),
    this.avgPriceEur = const Value.absent(),
    this.recommendedDishes = const Value.absent(),
    this.notes = const Value.absent(),
  });
  FoodsCompanion.insert({
    required int tripId,
    required int cityId,
    this.id = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    this.amapUrl = const Value.absent(),
    this.avgPriceCny = const Value.absent(),
    this.avgPriceEur = const Value.absent(),
    this.recommendedDishes = const Value.absent(),
    this.notes = const Value.absent(),
  }) : tripId = Value(tripId),
       cityId = Value(cityId),
       name = Value(name);
  static Insertable<Food> custom({
    Expression<int>? tripId,
    Expression<int>? cityId,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? amapUrl,
    Expression<double>? avgPriceCny,
    Expression<double>? avgPriceEur,
    Expression<String>? recommendedDishes,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (cityId != null) 'city_id': cityId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (amapUrl != null) 'amap_url': amapUrl,
      if (avgPriceCny != null) 'avg_price_cny': avgPriceCny,
      if (avgPriceEur != null) 'avg_price_eur': avgPriceEur,
      if (recommendedDishes != null) 'recommended_dishes': recommendedDishes,
      if (notes != null) 'notes': notes,
    });
  }

  FoodsCompanion copyWith({
    Value<int>? tripId,
    Value<int>? cityId,
    Value<int>? id,
    Value<String>? name,
    Value<String?>? category,
    Value<String?>? amapUrl,
    Value<double?>? avgPriceCny,
    Value<double?>? avgPriceEur,
    Value<String?>? recommendedDishes,
    Value<String?>? notes,
  }) {
    return FoodsCompanion(
      tripId: tripId ?? this.tripId,
      cityId: cityId ?? this.cityId,
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      amapUrl: amapUrl ?? this.amapUrl,
      avgPriceCny: avgPriceCny ?? this.avgPriceCny,
      avgPriceEur: avgPriceEur ?? this.avgPriceEur,
      recommendedDishes: recommendedDishes ?? this.recommendedDishes,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (cityId.present) {
      map['city_id'] = Variable<int>(cityId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amapUrl.present) {
      map['amap_url'] = Variable<String>(amapUrl.value);
    }
    if (avgPriceCny.present) {
      map['avg_price_cny'] = Variable<double>(avgPriceCny.value);
    }
    if (avgPriceEur.present) {
      map['avg_price_eur'] = Variable<double>(avgPriceEur.value);
    }
    if (recommendedDishes.present) {
      map['recommended_dishes'] = Variable<String>(recommendedDishes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('cityId: $cityId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('amapUrl: $amapUrl, ')
          ..write('avgPriceCny: $avgPriceCny, ')
          ..write('avgPriceEur: $avgPriceEur, ')
          ..write('recommendedDishes: $recommendedDishes, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<int> cityId = GeneratedColumn<int>(
    'city_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cities (id)',
    ),
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressEnMeta = const VerificationMeta(
    'addressEn',
  );
  @override
  late final GeneratedColumn<String> addressEn = GeneratedColumn<String>(
    'address_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLocalMeta = const VerificationMeta(
    'addressLocal',
  );
  @override
  late final GeneratedColumn<String> addressLocal = GeneratedColumn<String>(
    'address_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mapUrlMeta = const VerificationMeta('mapUrl');
  @override
  late final GeneratedColumn<String> mapUrl = GeneratedColumn<String>(
    'map_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTableMeta = const VerificationMeta(
    'sourceTable',
  );
  @override
  late final GeneratedColumn<String> sourceTable = GeneratedColumn<String>(
    'source_table',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    cityId,
    lat,
    lng,
    id,
    name,
    type,
    category,
    addressEn,
    addressLocal,
    mapUrl,
    image,
    notes,
    phone,
    website,
    sourceTable,
    sourceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Location> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('city_id')) {
      context.handle(
        _cityIdMeta,
        cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('address_en')) {
      context.handle(
        _addressEnMeta,
        addressEn.isAcceptableOrUnknown(data['address_en']!, _addressEnMeta),
      );
    }
    if (data.containsKey('address_local')) {
      context.handle(
        _addressLocalMeta,
        addressLocal.isAcceptableOrUnknown(
          data['address_local']!,
          _addressLocalMeta,
        ),
      );
    }
    if (data.containsKey('map_url')) {
      context.handle(
        _mapUrlMeta,
        mapUrl.isAcceptableOrUnknown(data['map_url']!, _mapUrlMeta),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('source_table')) {
      context.handle(
        _sourceTableMeta,
        sourceTable.isAcceptableOrUnknown(
          data['source_table']!,
          _sourceTableMeta,
        ),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Location(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      cityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}city_id'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      addressEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_en'],
      ),
      addressLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_local'],
      ),
      mapUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}map_url'],
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      sourceTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_table'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final int tripId;
  final int cityId;
  final double? lat;
  final double? lng;
  final int id;
  final String name;
  final String type;
  final String? category;
  final String? addressEn;
  final String? addressLocal;
  final String? mapUrl;
  final String? image;
  final String? notes;
  final String? phone;
  final String? website;
  final String? sourceTable;
  final String? sourceId;
  const Location({
    required this.tripId,
    required this.cityId,
    this.lat,
    this.lng,
    required this.id,
    required this.name,
    required this.type,
    this.category,
    this.addressEn,
    this.addressLocal,
    this.mapUrl,
    this.image,
    this.notes,
    this.phone,
    this.website,
    this.sourceTable,
    this.sourceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    map['city_id'] = Variable<int>(cityId);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || addressEn != null) {
      map['address_en'] = Variable<String>(addressEn);
    }
    if (!nullToAbsent || addressLocal != null) {
      map['address_local'] = Variable<String>(addressLocal);
    }
    if (!nullToAbsent || mapUrl != null) {
      map['map_url'] = Variable<String>(mapUrl);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || sourceTable != null) {
      map['source_table'] = Variable<String>(sourceTable);
    }
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      tripId: Value(tripId),
      cityId: Value(cityId),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      id: Value(id),
      name: Value(name),
      type: Value(type),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      addressEn: addressEn == null && nullToAbsent
          ? const Value.absent()
          : Value(addressEn),
      addressLocal: addressLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLocal),
      mapUrl: mapUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mapUrl),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      sourceTable: sourceTable == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceTable),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
    );
  }

  factory Location.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      tripId: serializer.fromJson<int>(json['tripId']),
      cityId: serializer.fromJson<int>(json['cityId']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String?>(json['category']),
      addressEn: serializer.fromJson<String?>(json['addressEn']),
      addressLocal: serializer.fromJson<String?>(json['addressLocal']),
      mapUrl: serializer.fromJson<String?>(json['mapUrl']),
      image: serializer.fromJson<String?>(json['image']),
      notes: serializer.fromJson<String?>(json['notes']),
      phone: serializer.fromJson<String?>(json['phone']),
      website: serializer.fromJson<String?>(json['website']),
      sourceTable: serializer.fromJson<String?>(json['sourceTable']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'cityId': serializer.toJson<int>(cityId),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String?>(category),
      'addressEn': serializer.toJson<String?>(addressEn),
      'addressLocal': serializer.toJson<String?>(addressLocal),
      'mapUrl': serializer.toJson<String?>(mapUrl),
      'image': serializer.toJson<String?>(image),
      'notes': serializer.toJson<String?>(notes),
      'phone': serializer.toJson<String?>(phone),
      'website': serializer.toJson<String?>(website),
      'sourceTable': serializer.toJson<String?>(sourceTable),
      'sourceId': serializer.toJson<String?>(sourceId),
    };
  }

  Location copyWith({
    int? tripId,
    int? cityId,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    int? id,
    String? name,
    String? type,
    Value<String?> category = const Value.absent(),
    Value<String?> addressEn = const Value.absent(),
    Value<String?> addressLocal = const Value.absent(),
    Value<String?> mapUrl = const Value.absent(),
    Value<String?> image = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> sourceTable = const Value.absent(),
    Value<String?> sourceId = const Value.absent(),
  }) => Location(
    tripId: tripId ?? this.tripId,
    cityId: cityId ?? this.cityId,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    category: category.present ? category.value : this.category,
    addressEn: addressEn.present ? addressEn.value : this.addressEn,
    addressLocal: addressLocal.present ? addressLocal.value : this.addressLocal,
    mapUrl: mapUrl.present ? mapUrl.value : this.mapUrl,
    image: image.present ? image.value : this.image,
    notes: notes.present ? notes.value : this.notes,
    phone: phone.present ? phone.value : this.phone,
    website: website.present ? website.value : this.website,
    sourceTable: sourceTable.present ? sourceTable.value : this.sourceTable,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
  );
  Location copyWithCompanion(LocationsCompanion data) {
    return Location(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      addressEn: data.addressEn.present ? data.addressEn.value : this.addressEn,
      addressLocal: data.addressLocal.present
          ? data.addressLocal.value
          : this.addressLocal,
      mapUrl: data.mapUrl.present ? data.mapUrl.value : this.mapUrl,
      image: data.image.present ? data.image.value : this.image,
      notes: data.notes.present ? data.notes.value : this.notes,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
      sourceTable: data.sourceTable.present
          ? data.sourceTable.value
          : this.sourceTable,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('tripId: $tripId, ')
          ..write('cityId: $cityId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('addressEn: $addressEn, ')
          ..write('addressLocal: $addressLocal, ')
          ..write('mapUrl: $mapUrl, ')
          ..write('image: $image, ')
          ..write('notes: $notes, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('sourceTable: $sourceTable, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tripId,
    cityId,
    lat,
    lng,
    id,
    name,
    type,
    category,
    addressEn,
    addressLocal,
    mapUrl,
    image,
    notes,
    phone,
    website,
    sourceTable,
    sourceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.tripId == this.tripId &&
          other.cityId == this.cityId &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.category == this.category &&
          other.addressEn == this.addressEn &&
          other.addressLocal == this.addressLocal &&
          other.mapUrl == this.mapUrl &&
          other.image == this.image &&
          other.notes == this.notes &&
          other.phone == this.phone &&
          other.website == this.website &&
          other.sourceTable == this.sourceTable &&
          other.sourceId == this.sourceId);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<int> tripId;
  final Value<int> cityId;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> category;
  final Value<String?> addressEn;
  final Value<String?> addressLocal;
  final Value<String?> mapUrl;
  final Value<String?> image;
  final Value<String?> notes;
  final Value<String?> phone;
  final Value<String?> website;
  final Value<String?> sourceTable;
  final Value<String?> sourceId;
  const LocationsCompanion({
    this.tripId = const Value.absent(),
    this.cityId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.addressEn = const Value.absent(),
    this.addressLocal = const Value.absent(),
    this.mapUrl = const Value.absent(),
    this.image = const Value.absent(),
    this.notes = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.sourceTable = const Value.absent(),
    this.sourceId = const Value.absent(),
  });
  LocationsCompanion.insert({
    required int tripId,
    required int cityId,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.category = const Value.absent(),
    this.addressEn = const Value.absent(),
    this.addressLocal = const Value.absent(),
    this.mapUrl = const Value.absent(),
    this.image = const Value.absent(),
    this.notes = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.sourceTable = const Value.absent(),
    this.sourceId = const Value.absent(),
  }) : tripId = Value(tripId),
       cityId = Value(cityId),
       name = Value(name),
       type = Value(type);
  static Insertable<Location> custom({
    Expression<int>? tripId,
    Expression<int>? cityId,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? addressEn,
    Expression<String>? addressLocal,
    Expression<String>? mapUrl,
    Expression<String>? image,
    Expression<String>? notes,
    Expression<String>? phone,
    Expression<String>? website,
    Expression<String>? sourceTable,
    Expression<String>? sourceId,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (cityId != null) 'city_id': cityId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (addressEn != null) 'address_en': addressEn,
      if (addressLocal != null) 'address_local': addressLocal,
      if (mapUrl != null) 'map_url': mapUrl,
      if (image != null) 'image': image,
      if (notes != null) 'notes': notes,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (sourceTable != null) 'source_table': sourceTable,
      if (sourceId != null) 'source_id': sourceId,
    });
  }

  LocationsCompanion copyWith({
    Value<int>? tripId,
    Value<int>? cityId,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? category,
    Value<String?>? addressEn,
    Value<String?>? addressLocal,
    Value<String?>? mapUrl,
    Value<String?>? image,
    Value<String?>? notes,
    Value<String?>? phone,
    Value<String?>? website,
    Value<String?>? sourceTable,
    Value<String?>? sourceId,
  }) {
    return LocationsCompanion(
      tripId: tripId ?? this.tripId,
      cityId: cityId ?? this.cityId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      category: category ?? this.category,
      addressEn: addressEn ?? this.addressEn,
      addressLocal: addressLocal ?? this.addressLocal,
      mapUrl: mapUrl ?? this.mapUrl,
      image: image ?? this.image,
      notes: notes ?? this.notes,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      sourceTable: sourceTable ?? this.sourceTable,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (cityId.present) {
      map['city_id'] = Variable<int>(cityId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (addressEn.present) {
      map['address_en'] = Variable<String>(addressEn.value);
    }
    if (addressLocal.present) {
      map['address_local'] = Variable<String>(addressLocal.value);
    }
    if (mapUrl.present) {
      map['map_url'] = Variable<String>(mapUrl.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (sourceTable.present) {
      map['source_table'] = Variable<String>(sourceTable.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('cityId: $cityId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('addressEn: $addressEn, ')
          ..write('addressLocal: $addressLocal, ')
          ..write('mapUrl: $mapUrl, ')
          ..write('image: $image, ')
          ..write('notes: $notes, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('sourceTable: $sourceTable, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $CitiesTable cities = $CitiesTable(this);
  late final $HotelsTable hotels = $HotelsTable(this);
  late final $FlightsTable flights = $FlightsTable(this);
  late final $TrainsTable trains = $TrainsTable(this);
  late final $ItineraryTable itinerary = $ItineraryTable(this);
  late final $PackingItemsTable packingItems = $PackingItemsTable(this);
  late final $TripTipsTable tripTips = $TripTipsTable(this);
  late final $CitySummariesTable citySummaries = $CitySummariesTable(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trips,
    contacts,
    cities,
    hotels,
    flights,
    trains,
    itinerary,
    packingItems,
    tripTips,
    citySummaries,
    foods,
    locations,
  ];
}

typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime startDate,
      required DateTime endDate,
      Value<String?> notes,
      Value<String?> coverImage,
      Value<String?> currency,
      Value<String?> timezone,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String?> notes,
      Value<String?> coverImage,
      Value<String?> currency,
      Value<String?> timezone,
    });

final class $$TripsTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTable, Trip> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContactsTable, List<Contact>> _contactsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.contacts,
    aliasName: $_aliasNameGenerator(db.trips.id, db.contacts.tripId),
  );

  $$ContactsTableProcessedTableManager get contactsRefs {
    final manager = $$ContactsTableTableManager(
      $_db,
      $_db.contacts,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contactsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CitiesTable, List<City>> _citiesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cities,
    aliasName: $_aliasNameGenerator(db.trips.id, db.cities.tripId),
  );

  $$CitiesTableProcessedTableManager get citiesRefs {
    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_citiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FlightsTable, List<Flight>> _flightsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.flights,
    aliasName: $_aliasNameGenerator(db.trips.id, db.flights.tripId),
  );

  $$FlightsTableProcessedTableManager get flightsRefs {
    final manager = $$FlightsTableTableManager(
      $_db,
      $_db.flights,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_flightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrainsTable, List<Train>> _trainsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.trains,
    aliasName: $_aliasNameGenerator(db.trips.id, db.trains.tripId),
  );

  $$TrainsTableProcessedTableManager get trainsRefs {
    final manager = $$TrainsTableTableManager(
      $_db,
      $_db.trains,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trainsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PackingItemsTable, List<PackingItem>>
  _packingItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packingItems,
    aliasName: $_aliasNameGenerator(db.trips.id, db.packingItems.tripId),
  );

  $$PackingItemsTableProcessedTableManager get packingItemsRefs {
    final manager = $$PackingItemsTableTableManager(
      $_db,
      $_db.packingItems,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_packingItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TripTipsTable, List<TripTip>> _tripTipsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tripTips,
    aliasName: $_aliasNameGenerator(db.trips.id, db.tripTips.tripId),
  );

  $$TripTipsTableProcessedTableManager get tripTipsRefs {
    final manager = $$TripTipsTableTableManager(
      $_db,
      $_db.tripTips,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripTipsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CitySummariesTable, List<CitySummary>>
  _citySummariesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.citySummaries,
    aliasName: $_aliasNameGenerator(db.trips.id, db.citySummaries.tripId),
  );

  $$CitySummariesTableProcessedTableManager get citySummariesRefs {
    final manager = $$CitySummariesTableTableManager(
      $_db,
      $_db.citySummaries,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_citySummariesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FoodsTable, List<Food>> _foodsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.foods,
    aliasName: $_aliasNameGenerator(db.trips.id, db.foods.tripId),
  );

  $$FoodsTableProcessedTableManager get foodsRefs {
    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LocationsTable, List<Location>>
  _locationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.locations,
    aliasName: $_aliasNameGenerator(db.trips.id, db.locations.tripId),
  );

  $$LocationsTableProcessedTableManager get locationsRefs {
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_locationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contactsRefs(
    Expression<bool> Function($$ContactsTableFilterComposer f) f,
  ) {
    final $$ContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableFilterComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> citiesRefs(
    Expression<bool> Function($$CitiesTableFilterComposer f) f,
  ) {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> flightsRefs(
    Expression<bool> Function($$FlightsTableFilterComposer f) f,
  ) {
    final $$FlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableFilterComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trainsRefs(
    Expression<bool> Function($$TrainsTableFilterComposer f) f,
  ) {
    final $$TrainsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trains,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainsTableFilterComposer(
            $db: $db,
            $table: $db.trains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> packingItemsRefs(
    Expression<bool> Function($$PackingItemsTableFilterComposer f) f,
  ) {
    final $$PackingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packingItems,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackingItemsTableFilterComposer(
            $db: $db,
            $table: $db.packingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tripTipsRefs(
    Expression<bool> Function($$TripTipsTableFilterComposer f) f,
  ) {
    final $$TripTipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripTips,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripTipsTableFilterComposer(
            $db: $db,
            $table: $db.tripTips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> citySummariesRefs(
    Expression<bool> Function($$CitySummariesTableFilterComposer f) f,
  ) {
    final $$CitySummariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.citySummaries,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitySummariesTableFilterComposer(
            $db: $db,
            $table: $db.citySummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> foodsRefs(
    Expression<bool> Function($$FoodsTableFilterComposer f) f,
  ) {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> locationsRefs(
    Expression<bool> Function($$LocationsTableFilterComposer f) f,
  ) {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  Expression<T> contactsRefs<T extends Object>(
    Expression<T> Function($$ContactsTableAnnotationComposer a) f,
  ) {
    final $$ContactsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableAnnotationComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> citiesRefs<T extends Object>(
    Expression<T> Function($$CitiesTableAnnotationComposer a) f,
  ) {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> flightsRefs<T extends Object>(
    Expression<T> Function($$FlightsTableAnnotationComposer a) f,
  ) {
    final $$FlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trainsRefs<T extends Object>(
    Expression<T> Function($$TrainsTableAnnotationComposer a) f,
  ) {
    final $$TrainsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trains,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainsTableAnnotationComposer(
            $db: $db,
            $table: $db.trains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> packingItemsRefs<T extends Object>(
    Expression<T> Function($$PackingItemsTableAnnotationComposer a) f,
  ) {
    final $$PackingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packingItems,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.packingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tripTipsRefs<T extends Object>(
    Expression<T> Function($$TripTipsTableAnnotationComposer a) f,
  ) {
    final $$TripTipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripTips,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripTipsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripTips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> citySummariesRefs<T extends Object>(
    Expression<T> Function($$CitySummariesTableAnnotationComposer a) f,
  ) {
    final $$CitySummariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.citySummaries,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitySummariesTableAnnotationComposer(
            $db: $db,
            $table: $db.citySummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> foodsRefs<T extends Object>(
    Expression<T> Function($$FoodsTableAnnotationComposer a) f,
  ) {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> locationsRefs<T extends Object>(
    Expression<T> Function($$LocationsTableAnnotationComposer a) f,
  ) {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          Trip,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (Trip, $$TripsTableReferences),
          Trip,
          PrefetchHooks Function({
            bool contactsRefs,
            bool citiesRefs,
            bool flightsRefs,
            bool trainsRefs,
            bool packingItemsRefs,
            bool tripTipsRefs,
            bool citySummariesRefs,
            bool foodsRefs,
            bool locationsRefs,
          })
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> coverImage = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> timezone = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                notes: notes,
                coverImage: coverImage,
                currency: currency,
                timezone: timezone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime startDate,
                required DateTime endDate,
                Value<String?> notes = const Value.absent(),
                Value<String?> coverImage = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> timezone = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                notes: notes,
                coverImage: coverImage,
                currency: currency,
                timezone: timezone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TripsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                contactsRefs = false,
                citiesRefs = false,
                flightsRefs = false,
                trainsRefs = false,
                packingItemsRefs = false,
                tripTipsRefs = false,
                citySummariesRefs = false,
                foodsRefs = false,
                locationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contactsRefs) db.contacts,
                    if (citiesRefs) db.cities,
                    if (flightsRefs) db.flights,
                    if (trainsRefs) db.trains,
                    if (packingItemsRefs) db.packingItems,
                    if (tripTipsRefs) db.tripTips,
                    if (citySummariesRefs) db.citySummaries,
                    if (foodsRefs) db.foods,
                    if (locationsRefs) db.locations,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contactsRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, Contact>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._contactsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).contactsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (citiesRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, City>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._citiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(db, table, p0).citiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (flightsRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, Flight>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._flightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(db, table, p0).flightsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trainsRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, Train>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._trainsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(db, table, p0).trainsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (packingItemsRefs)
                        await $_getPrefetchedData<
                          Trip,
                          $TripsTable,
                          PackingItem
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._packingItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).packingItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tripTipsRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, TripTip>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._tripTipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).tripTipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (citySummariesRefs)
                        await $_getPrefetchedData<
                          Trip,
                          $TripsTable,
                          CitySummary
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._citySummariesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).citySummariesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (foodsRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, Food>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._foodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(db, table, p0).foodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (locationsRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, Location>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._locationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).locationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      Trip,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (Trip, $$TripsTableReferences),
      Trip,
      PrefetchHooks Function({
        bool contactsRefs,
        bool citiesRefs,
        bool flightsRefs,
        bool trainsRefs,
        bool packingItemsRefs,
        bool tripTipsRefs,
        bool citySummariesRefs,
        bool foodsRefs,
        bool locationsRefs,
      })
    >;
typedef $$ContactsTableCreateCompanionBuilder =
    ContactsCompanion Function({
      required int tripId,
      Value<int> id,
      required String name,
      Value<String?> role,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> notes,
    });
typedef $$ContactsTableUpdateCompanionBuilder =
    ContactsCompanion Function({
      Value<int> tripId,
      Value<int> id,
      Value<String> name,
      Value<String?> role,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> notes,
    });

final class $$ContactsTableReferences
    extends BaseReferences<_$AppDatabase, $ContactsTable, Contact> {
  $$ContactsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips.createAlias(
    $_aliasNameGenerator(db.contacts.tripId, db.trips.id),
  );

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, $$ContactsTableReferences),
          Contact,
          PrefetchHooks Function({bool tripId})
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ContactsCompanion(
                tripId: tripId,
                id: id,
                name: name,
                role: role,
                phone: phone,
                email: email,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> role = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ContactsCompanion.insert(
                tripId: tripId,
                id: id,
                name: name,
                role: role,
                phone: phone,
                email: email,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$ContactsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$ContactsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, $$ContactsTableReferences),
      Contact,
      PrefetchHooks Function({bool tripId})
    >;
typedef $$CitiesTableCreateCompanionBuilder =
    CitiesCompanion Function({
      required int tripId,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> id,
      required String name,
      required String country,
      Value<String?> notes,
      Value<DateTime?> arrivalDate,
      Value<DateTime?> departureDate,
      Value<String?> cityImage,
    });
typedef $$CitiesTableUpdateCompanionBuilder =
    CitiesCompanion Function({
      Value<int> tripId,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> id,
      Value<String> name,
      Value<String> country,
      Value<String?> notes,
      Value<DateTime?> arrivalDate,
      Value<DateTime?> departureDate,
      Value<String?> cityImage,
    });

final class $$CitiesTableReferences
    extends BaseReferences<_$AppDatabase, $CitiesTable, City> {
  $$CitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias($_aliasNameGenerator(db.cities.tripId, db.trips.id));

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HotelsTable, List<Hotel>> _hotelsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.hotels,
    aliasName: $_aliasNameGenerator(db.cities.id, db.hotels.cityId),
  );

  $$HotelsTableProcessedTableManager get hotelsRefs {
    final manager = $$HotelsTableTableManager(
      $_db,
      $_db.hotels,
    ).filter((f) => f.cityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hotelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItineraryTable, List<ItineraryData>>
  _itineraryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itinerary,
    aliasName: $_aliasNameGenerator(db.cities.id, db.itinerary.cityId),
  );

  $$ItineraryTableProcessedTableManager get itineraryRefs {
    final manager = $$ItineraryTableTableManager(
      $_db,
      $_db.itinerary,
    ).filter((f) => f.cityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itineraryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TripTipsTable, List<TripTip>> _tripTipsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tripTips,
    aliasName: $_aliasNameGenerator(db.cities.id, db.tripTips.cityId),
  );

  $$TripTipsTableProcessedTableManager get tripTipsRefs {
    final manager = $$TripTipsTableTableManager(
      $_db,
      $_db.tripTips,
    ).filter((f) => f.cityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripTipsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CitySummariesTable, List<CitySummary>>
  _citySummariesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.citySummaries,
    aliasName: $_aliasNameGenerator(db.cities.id, db.citySummaries.cityId),
  );

  $$CitySummariesTableProcessedTableManager get citySummariesRefs {
    final manager = $$CitySummariesTableTableManager(
      $_db,
      $_db.citySummaries,
    ).filter((f) => f.cityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_citySummariesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FoodsTable, List<Food>> _foodsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.foods,
    aliasName: $_aliasNameGenerator(db.cities.id, db.foods.cityId),
  );

  $$FoodsTableProcessedTableManager get foodsRefs {
    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.cityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LocationsTable, List<Location>>
  _locationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.locations,
    aliasName: $_aliasNameGenerator(db.cities.id, db.locations.cityId),
  );

  $$LocationsTableProcessedTableManager get locationsRefs {
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.cityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_locationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CitiesTableFilterComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrivalDate => $composableBuilder(
    column: $table.arrivalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get departureDate => $composableBuilder(
    column: $table.departureDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cityImage => $composableBuilder(
    column: $table.cityImage,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> hotelsRefs(
    Expression<bool> Function($$HotelsTableFilterComposer f) f,
  ) {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hotels,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HotelsTableFilterComposer(
            $db: $db,
            $table: $db.hotels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itineraryRefs(
    Expression<bool> Function($$ItineraryTableFilterComposer f) f,
  ) {
    final $$ItineraryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itinerary,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItineraryTableFilterComposer(
            $db: $db,
            $table: $db.itinerary,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tripTipsRefs(
    Expression<bool> Function($$TripTipsTableFilterComposer f) f,
  ) {
    final $$TripTipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripTips,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripTipsTableFilterComposer(
            $db: $db,
            $table: $db.tripTips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> citySummariesRefs(
    Expression<bool> Function($$CitySummariesTableFilterComposer f) f,
  ) {
    final $$CitySummariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.citySummaries,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitySummariesTableFilterComposer(
            $db: $db,
            $table: $db.citySummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> foodsRefs(
    Expression<bool> Function($$FoodsTableFilterComposer f) f,
  ) {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> locationsRefs(
    Expression<bool> Function($$LocationsTableFilterComposer f) f,
  ) {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrivalDate => $composableBuilder(
    column: $table.arrivalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get departureDate => $composableBuilder(
    column: $table.departureDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cityImage => $composableBuilder(
    column: $table.cityImage,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get arrivalDate => $composableBuilder(
    column: $table.arrivalDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get departureDate => $composableBuilder(
    column: $table.departureDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cityImage =>
      $composableBuilder(column: $table.cityImage, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> hotelsRefs<T extends Object>(
    Expression<T> Function($$HotelsTableAnnotationComposer a) f,
  ) {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hotels,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HotelsTableAnnotationComposer(
            $db: $db,
            $table: $db.hotels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itineraryRefs<T extends Object>(
    Expression<T> Function($$ItineraryTableAnnotationComposer a) f,
  ) {
    final $$ItineraryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itinerary,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItineraryTableAnnotationComposer(
            $db: $db,
            $table: $db.itinerary,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tripTipsRefs<T extends Object>(
    Expression<T> Function($$TripTipsTableAnnotationComposer a) f,
  ) {
    final $$TripTipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripTips,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripTipsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripTips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> citySummariesRefs<T extends Object>(
    Expression<T> Function($$CitySummariesTableAnnotationComposer a) f,
  ) {
    final $$CitySummariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.citySummaries,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitySummariesTableAnnotationComposer(
            $db: $db,
            $table: $db.citySummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> foodsRefs<T extends Object>(
    Expression<T> Function($$FoodsTableAnnotationComposer a) f,
  ) {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> locationsRefs<T extends Object>(
    Expression<T> Function($$LocationsTableAnnotationComposer a) f,
  ) {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CitiesTable,
          City,
          $$CitiesTableFilterComposer,
          $$CitiesTableOrderingComposer,
          $$CitiesTableAnnotationComposer,
          $$CitiesTableCreateCompanionBuilder,
          $$CitiesTableUpdateCompanionBuilder,
          (City, $$CitiesTableReferences),
          City,
          PrefetchHooks Function({
            bool tripId,
            bool hotelsRefs,
            bool itineraryRefs,
            bool tripTipsRefs,
            bool citySummariesRefs,
            bool foodsRefs,
            bool locationsRefs,
          })
        > {
  $$CitiesTableTableManager(_$AppDatabase db, $CitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> arrivalDate = const Value.absent(),
                Value<DateTime?> departureDate = const Value.absent(),
                Value<String?> cityImage = const Value.absent(),
              }) => CitiesCompanion(
                tripId: tripId,
                lat: lat,
                lng: lng,
                id: id,
                name: name,
                country: country,
                notes: notes,
                arrivalDate: arrivalDate,
                departureDate: departureDate,
                cityImage: cityImage,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                required String country,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> arrivalDate = const Value.absent(),
                Value<DateTime?> departureDate = const Value.absent(),
                Value<String?> cityImage = const Value.absent(),
              }) => CitiesCompanion.insert(
                tripId: tripId,
                lat: lat,
                lng: lng,
                id: id,
                name: name,
                country: country,
                notes: notes,
                arrivalDate: arrivalDate,
                departureDate: departureDate,
                cityImage: cityImage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CitiesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tripId = false,
                hotelsRefs = false,
                itineraryRefs = false,
                tripTipsRefs = false,
                citySummariesRefs = false,
                foodsRefs = false,
                locationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (hotelsRefs) db.hotels,
                    if (itineraryRefs) db.itinerary,
                    if (tripTipsRefs) db.tripTips,
                    if (citySummariesRefs) db.citySummaries,
                    if (foodsRefs) db.foods,
                    if (locationsRefs) db.locations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable: $$CitiesTableReferences
                                        ._tripIdTable(db),
                                    referencedColumn: $$CitiesTableReferences
                                        ._tripIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (hotelsRefs)
                        await $_getPrefetchedData<City, $CitiesTable, Hotel>(
                          currentTable: table,
                          referencedTable: $$CitiesTableReferences
                              ._hotelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CitiesTableReferences(db, table, p0).hotelsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itineraryRefs)
                        await $_getPrefetchedData<
                          City,
                          $CitiesTable,
                          ItineraryData
                        >(
                          currentTable: table,
                          referencedTable: $$CitiesTableReferences
                              ._itineraryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).itineraryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tripTipsRefs)
                        await $_getPrefetchedData<City, $CitiesTable, TripTip>(
                          currentTable: table,
                          referencedTable: $$CitiesTableReferences
                              ._tripTipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).tripTipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (citySummariesRefs)
                        await $_getPrefetchedData<
                          City,
                          $CitiesTable,
                          CitySummary
                        >(
                          currentTable: table,
                          referencedTable: $$CitiesTableReferences
                              ._citySummariesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).citySummariesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (foodsRefs)
                        await $_getPrefetchedData<City, $CitiesTable, Food>(
                          currentTable: table,
                          referencedTable: $$CitiesTableReferences
                              ._foodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CitiesTableReferences(db, table, p0).foodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (locationsRefs)
                        await $_getPrefetchedData<City, $CitiesTable, Location>(
                          currentTable: table,
                          referencedTable: $$CitiesTableReferences
                              ._locationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).locationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cityId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CitiesTable,
      City,
      $$CitiesTableFilterComposer,
      $$CitiesTableOrderingComposer,
      $$CitiesTableAnnotationComposer,
      $$CitiesTableCreateCompanionBuilder,
      $$CitiesTableUpdateCompanionBuilder,
      (City, $$CitiesTableReferences),
      City,
      PrefetchHooks Function({
        bool tripId,
        bool hotelsRefs,
        bool itineraryRefs,
        bool tripTipsRefs,
        bool citySummariesRefs,
        bool foodsRefs,
        bool locationsRefs,
      })
    >;
typedef $$HotelsTableCreateCompanionBuilder =
    HotelsCompanion Function({
      required int cityId,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> id,
      required String name,
      Value<String?> localName,
      Value<DateTime?> checkIn,
      Value<DateTime?> checkOut,
      Value<String?> checkInTime,
      Value<String?> checkOutTime,
      Value<String?> confirmation,
      Value<double?> totalPrice,
      Value<double?> pricePerPerson,
      Value<double?> pricePerPersonNight,
      Value<String?> mapUrl,
      Value<String?> hotelImage,
      Value<String?> addressEn,
      Value<String?> addressLocal,
      Value<String?> phone,
      Value<String?> website,
    });
typedef $$HotelsTableUpdateCompanionBuilder =
    HotelsCompanion Function({
      Value<int> cityId,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> id,
      Value<String> name,
      Value<String?> localName,
      Value<DateTime?> checkIn,
      Value<DateTime?> checkOut,
      Value<String?> checkInTime,
      Value<String?> checkOutTime,
      Value<String?> confirmation,
      Value<double?> totalPrice,
      Value<double?> pricePerPerson,
      Value<double?> pricePerPersonNight,
      Value<String?> mapUrl,
      Value<String?> hotelImage,
      Value<String?> addressEn,
      Value<String?> addressLocal,
      Value<String?> phone,
      Value<String?> website,
    });

final class $$HotelsTableReferences
    extends BaseReferences<_$AppDatabase, $HotelsTable, Hotel> {
  $$HotelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CitiesTable _cityIdTable(_$AppDatabase db) => db.cities.createAlias(
    $_aliasNameGenerator(db.hotels.cityId, db.cities.id),
  );

  $$CitiesTableProcessedTableManager get cityId {
    final $_column = $_itemColumn<int>('city_id')!;

    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItineraryTable, List<ItineraryData>>
  _itineraryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itinerary,
    aliasName: $_aliasNameGenerator(db.hotels.id, db.itinerary.hotelId),
  );

  $$ItineraryTableProcessedTableManager get itineraryRefs {
    final manager = $$ItineraryTableTableManager(
      $_db,
      $_db.itinerary,
    ).filter((f) => f.hotelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itineraryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HotelsTableFilterComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localName => $composableBuilder(
    column: $table.localName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkIn => $composableBuilder(
    column: $table.checkIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkOut => $composableBuilder(
    column: $table.checkOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkOutTime => $composableBuilder(
    column: $table.checkOutTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmation => $composableBuilder(
    column: $table.confirmation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerPerson => $composableBuilder(
    column: $table.pricePerPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerPersonNight => $composableBuilder(
    column: $table.pricePerPersonNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mapUrl => $composableBuilder(
    column: $table.mapUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hotelImage => $composableBuilder(
    column: $table.hotelImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressEn => $composableBuilder(
    column: $table.addressEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  $$CitiesTableFilterComposer get cityId {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itineraryRefs(
    Expression<bool> Function($$ItineraryTableFilterComposer f) f,
  ) {
    final $$ItineraryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itinerary,
      getReferencedColumn: (t) => t.hotelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItineraryTableFilterComposer(
            $db: $db,
            $table: $db.itinerary,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HotelsTableOrderingComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localName => $composableBuilder(
    column: $table.localName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkIn => $composableBuilder(
    column: $table.checkIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkOut => $composableBuilder(
    column: $table.checkOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkOutTime => $composableBuilder(
    column: $table.checkOutTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmation => $composableBuilder(
    column: $table.confirmation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerPerson => $composableBuilder(
    column: $table.pricePerPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerPersonNight => $composableBuilder(
    column: $table.pricePerPersonNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mapUrl => $composableBuilder(
    column: $table.mapUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hotelImage => $composableBuilder(
    column: $table.hotelImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressEn => $composableBuilder(
    column: $table.addressEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  $$CitiesTableOrderingComposer get cityId {
    final $$CitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableOrderingComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HotelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get localName =>
      $composableBuilder(column: $table.localName, builder: (column) => column);

  GeneratedColumn<DateTime> get checkIn =>
      $composableBuilder(column: $table.checkIn, builder: (column) => column);

  GeneratedColumn<DateTime> get checkOut =>
      $composableBuilder(column: $table.checkOut, builder: (column) => column);

  GeneratedColumn<String> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checkOutTime => $composableBuilder(
    column: $table.checkOutTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmation => $composableBuilder(
    column: $table.confirmation,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pricePerPerson => $composableBuilder(
    column: $table.pricePerPerson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pricePerPersonNight => $composableBuilder(
    column: $table.pricePerPersonNight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mapUrl =>
      $composableBuilder(column: $table.mapUrl, builder: (column) => column);

  GeneratedColumn<String> get hotelImage => $composableBuilder(
    column: $table.hotelImage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressEn =>
      $composableBuilder(column: $table.addressEn, builder: (column) => column);

  GeneratedColumn<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  $$CitiesTableAnnotationComposer get cityId {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itineraryRefs<T extends Object>(
    Expression<T> Function($$ItineraryTableAnnotationComposer a) f,
  ) {
    final $$ItineraryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itinerary,
      getReferencedColumn: (t) => t.hotelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItineraryTableAnnotationComposer(
            $db: $db,
            $table: $db.itinerary,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HotelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HotelsTable,
          Hotel,
          $$HotelsTableFilterComposer,
          $$HotelsTableOrderingComposer,
          $$HotelsTableAnnotationComposer,
          $$HotelsTableCreateCompanionBuilder,
          $$HotelsTableUpdateCompanionBuilder,
          (Hotel, $$HotelsTableReferences),
          Hotel,
          PrefetchHooks Function({bool cityId, bool itineraryRefs})
        > {
  $$HotelsTableTableManager(_$AppDatabase db, $HotelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HotelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HotelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HotelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> cityId = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> localName = const Value.absent(),
                Value<DateTime?> checkIn = const Value.absent(),
                Value<DateTime?> checkOut = const Value.absent(),
                Value<String?> checkInTime = const Value.absent(),
                Value<String?> checkOutTime = const Value.absent(),
                Value<String?> confirmation = const Value.absent(),
                Value<double?> totalPrice = const Value.absent(),
                Value<double?> pricePerPerson = const Value.absent(),
                Value<double?> pricePerPersonNight = const Value.absent(),
                Value<String?> mapUrl = const Value.absent(),
                Value<String?> hotelImage = const Value.absent(),
                Value<String?> addressEn = const Value.absent(),
                Value<String?> addressLocal = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
              }) => HotelsCompanion(
                cityId: cityId,
                lat: lat,
                lng: lng,
                id: id,
                name: name,
                localName: localName,
                checkIn: checkIn,
                checkOut: checkOut,
                checkInTime: checkInTime,
                checkOutTime: checkOutTime,
                confirmation: confirmation,
                totalPrice: totalPrice,
                pricePerPerson: pricePerPerson,
                pricePerPersonNight: pricePerPersonNight,
                mapUrl: mapUrl,
                hotelImage: hotelImage,
                addressEn: addressEn,
                addressLocal: addressLocal,
                phone: phone,
                website: website,
              ),
          createCompanionCallback:
              ({
                required int cityId,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> localName = const Value.absent(),
                Value<DateTime?> checkIn = const Value.absent(),
                Value<DateTime?> checkOut = const Value.absent(),
                Value<String?> checkInTime = const Value.absent(),
                Value<String?> checkOutTime = const Value.absent(),
                Value<String?> confirmation = const Value.absent(),
                Value<double?> totalPrice = const Value.absent(),
                Value<double?> pricePerPerson = const Value.absent(),
                Value<double?> pricePerPersonNight = const Value.absent(),
                Value<String?> mapUrl = const Value.absent(),
                Value<String?> hotelImage = const Value.absent(),
                Value<String?> addressEn = const Value.absent(),
                Value<String?> addressLocal = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
              }) => HotelsCompanion.insert(
                cityId: cityId,
                lat: lat,
                lng: lng,
                id: id,
                name: name,
                localName: localName,
                checkIn: checkIn,
                checkOut: checkOut,
                checkInTime: checkInTime,
                checkOutTime: checkOutTime,
                confirmation: confirmation,
                totalPrice: totalPrice,
                pricePerPerson: pricePerPerson,
                pricePerPersonNight: pricePerPersonNight,
                mapUrl: mapUrl,
                hotelImage: hotelImage,
                addressEn: addressEn,
                addressLocal: addressLocal,
                phone: phone,
                website: website,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HotelsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({cityId = false, itineraryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itineraryRefs) db.itinerary],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cityId,
                                referencedTable: $$HotelsTableReferences
                                    ._cityIdTable(db),
                                referencedColumn: $$HotelsTableReferences
                                    ._cityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itineraryRefs)
                    await $_getPrefetchedData<
                      Hotel,
                      $HotelsTable,
                      ItineraryData
                    >(
                      currentTable: table,
                      referencedTable: $$HotelsTableReferences
                          ._itineraryRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HotelsTableReferences(db, table, p0).itineraryRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.hotelId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HotelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HotelsTable,
      Hotel,
      $$HotelsTableFilterComposer,
      $$HotelsTableOrderingComposer,
      $$HotelsTableAnnotationComposer,
      $$HotelsTableCreateCompanionBuilder,
      $$HotelsTableUpdateCompanionBuilder,
      (Hotel, $$HotelsTableReferences),
      Hotel,
      PrefetchHooks Function({bool cityId, bool itineraryRefs})
    >;
typedef $$FlightsTableCreateCompanionBuilder =
    FlightsCompanion Function({
      required int tripId,
      Value<String?> bookingRef,
      Value<String?> status,
      Value<String?> seat,
      Value<int> id,
      Value<String?> airline,
      required String flightNumber,
      required String origin,
      required String destination,
      Value<String?> originTerminal,
      Value<String?> destinationTerminal,
      required DateTime departure,
      required DateTime arrival,
      Value<String?> duration,
      Value<String?> trackerUrl,
    });
typedef $$FlightsTableUpdateCompanionBuilder =
    FlightsCompanion Function({
      Value<int> tripId,
      Value<String?> bookingRef,
      Value<String?> status,
      Value<String?> seat,
      Value<int> id,
      Value<String?> airline,
      Value<String> flightNumber,
      Value<String> origin,
      Value<String> destination,
      Value<String?> originTerminal,
      Value<String?> destinationTerminal,
      Value<DateTime> departure,
      Value<DateTime> arrival,
      Value<String?> duration,
      Value<String?> trackerUrl,
    });

final class $$FlightsTableReferences
    extends BaseReferences<_$AppDatabase, $FlightsTable, Flight> {
  $$FlightsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips.createAlias(
    $_aliasNameGenerator(db.flights.tripId, db.trips.id),
  );

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItineraryTable, List<ItineraryData>>
  _itineraryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itinerary,
    aliasName: $_aliasNameGenerator(db.flights.id, db.itinerary.flightId),
  );

  $$ItineraryTableProcessedTableManager get itineraryRefs {
    final manager = $$ItineraryTableTableManager(
      $_db,
      $_db.itinerary,
    ).filter((f) => f.flightId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itineraryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FlightsTableFilterComposer
    extends Composer<_$AppDatabase, $FlightsTable> {
  $$FlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seat => $composableBuilder(
    column: $table.seat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get airline => $composableBuilder(
    column: $table.airline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originTerminal => $composableBuilder(
    column: $table.originTerminal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationTerminal => $composableBuilder(
    column: $table.destinationTerminal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get departure => $composableBuilder(
    column: $table.departure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrival => $composableBuilder(
    column: $table.arrival,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerUrl => $composableBuilder(
    column: $table.trackerUrl,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itineraryRefs(
    Expression<bool> Function($$ItineraryTableFilterComposer f) f,
  ) {
    final $$ItineraryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itinerary,
      getReferencedColumn: (t) => t.flightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItineraryTableFilterComposer(
            $db: $db,
            $table: $db.itinerary,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlightsTable> {
  $$FlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seat => $composableBuilder(
    column: $table.seat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get airline => $composableBuilder(
    column: $table.airline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originTerminal => $composableBuilder(
    column: $table.originTerminal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationTerminal => $composableBuilder(
    column: $table.destinationTerminal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get departure => $composableBuilder(
    column: $table.departure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrival => $composableBuilder(
    column: $table.arrival,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerUrl => $composableBuilder(
    column: $table.trackerUrl,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlightsTable> {
  $$FlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get seat =>
      $composableBuilder(column: $table.seat, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get airline =>
      $composableBuilder(column: $table.airline, builder: (column) => column);

  GeneratedColumn<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originTerminal => $composableBuilder(
    column: $table.originTerminal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationTerminal => $composableBuilder(
    column: $table.destinationTerminal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get departure =>
      $composableBuilder(column: $table.departure, builder: (column) => column);

  GeneratedColumn<DateTime> get arrival =>
      $composableBuilder(column: $table.arrival, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get trackerUrl => $composableBuilder(
    column: $table.trackerUrl,
    builder: (column) => column,
  );

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itineraryRefs<T extends Object>(
    Expression<T> Function($$ItineraryTableAnnotationComposer a) f,
  ) {
    final $$ItineraryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itinerary,
      getReferencedColumn: (t) => t.flightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItineraryTableAnnotationComposer(
            $db: $db,
            $table: $db.itinerary,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlightsTable,
          Flight,
          $$FlightsTableFilterComposer,
          $$FlightsTableOrderingComposer,
          $$FlightsTableAnnotationComposer,
          $$FlightsTableCreateCompanionBuilder,
          $$FlightsTableUpdateCompanionBuilder,
          (Flight, $$FlightsTableReferences),
          Flight,
          PrefetchHooks Function({bool tripId, bool itineraryRefs})
        > {
  $$FlightsTableTableManager(_$AppDatabase db, $FlightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<String?> bookingRef = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> seat = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String?> airline = const Value.absent(),
                Value<String> flightNumber = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String> destination = const Value.absent(),
                Value<String?> originTerminal = const Value.absent(),
                Value<String?> destinationTerminal = const Value.absent(),
                Value<DateTime> departure = const Value.absent(),
                Value<DateTime> arrival = const Value.absent(),
                Value<String?> duration = const Value.absent(),
                Value<String?> trackerUrl = const Value.absent(),
              }) => FlightsCompanion(
                tripId: tripId,
                bookingRef: bookingRef,
                status: status,
                seat: seat,
                id: id,
                airline: airline,
                flightNumber: flightNumber,
                origin: origin,
                destination: destination,
                originTerminal: originTerminal,
                destinationTerminal: destinationTerminal,
                departure: departure,
                arrival: arrival,
                duration: duration,
                trackerUrl: trackerUrl,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                Value<String?> bookingRef = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> seat = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String?> airline = const Value.absent(),
                required String flightNumber,
                required String origin,
                required String destination,
                Value<String?> originTerminal = const Value.absent(),
                Value<String?> destinationTerminal = const Value.absent(),
                required DateTime departure,
                required DateTime arrival,
                Value<String?> duration = const Value.absent(),
                Value<String?> trackerUrl = const Value.absent(),
              }) => FlightsCompanion.insert(
                tripId: tripId,
                bookingRef: bookingRef,
                status: status,
                seat: seat,
                id: id,
                airline: airline,
                flightNumber: flightNumber,
                origin: origin,
                destination: destination,
                originTerminal: originTerminal,
                destinationTerminal: destinationTerminal,
                departure: departure,
                arrival: arrival,
                duration: duration,
                trackerUrl: trackerUrl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlightsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false, itineraryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itineraryRefs) db.itinerary],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$FlightsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$FlightsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itineraryRefs)
                    await $_getPrefetchedData<
                      Flight,
                      $FlightsTable,
                      ItineraryData
                    >(
                      currentTable: table,
                      referencedTable: $$FlightsTableReferences
                          ._itineraryRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FlightsTableReferences(db, table, p0).itineraryRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.flightId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FlightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlightsTable,
      Flight,
      $$FlightsTableFilterComposer,
      $$FlightsTableOrderingComposer,
      $$FlightsTableAnnotationComposer,
      $$FlightsTableCreateCompanionBuilder,
      $$FlightsTableUpdateCompanionBuilder,
      (Flight, $$FlightsTableReferences),
      Flight,
      PrefetchHooks Function({bool tripId, bool itineraryRefs})
    >;
typedef $$TrainsTableCreateCompanionBuilder =
    TrainsCompanion Function({
      required int tripId,
      Value<String?> bookingRef,
      Value<String?> status,
      Value<String?> seat,
      Value<int> id,
      required String trainNumber,
      required String origin,
      required String destination,
      required DateTime departure,
      required DateTime arrival,
      Value<String?> duration,
      Value<String?> platform,
      Value<double?> ticketPricePerPerson,
      Value<double?> bookingFeePerPerson,
      Value<double?> totalPricePerPerson,
    });
typedef $$TrainsTableUpdateCompanionBuilder =
    TrainsCompanion Function({
      Value<int> tripId,
      Value<String?> bookingRef,
      Value<String?> status,
      Value<String?> seat,
      Value<int> id,
      Value<String> trainNumber,
      Value<String> origin,
      Value<String> destination,
      Value<DateTime> departure,
      Value<DateTime> arrival,
      Value<String?> duration,
      Value<String?> platform,
      Value<double?> ticketPricePerPerson,
      Value<double?> bookingFeePerPerson,
      Value<double?> totalPricePerPerson,
    });

final class $$TrainsTableReferences
    extends BaseReferences<_$AppDatabase, $TrainsTable, Train> {
  $$TrainsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias($_aliasNameGenerator(db.trains.tripId, db.trips.id));

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItineraryTable, List<ItineraryData>>
  _itineraryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itinerary,
    aliasName: $_aliasNameGenerator(db.trains.id, db.itinerary.trainId),
  );

  $$ItineraryTableProcessedTableManager get itineraryRefs {
    final manager = $$ItineraryTableTableManager(
      $_db,
      $_db.itinerary,
    ).filter((f) => f.trainId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itineraryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrainsTableFilterComposer
    extends Composer<_$AppDatabase, $TrainsTable> {
  $$TrainsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seat => $composableBuilder(
    column: $table.seat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainNumber => $composableBuilder(
    column: $table.trainNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get departure => $composableBuilder(
    column: $table.departure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrival => $composableBuilder(
    column: $table.arrival,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ticketPricePerPerson => $composableBuilder(
    column: $table.ticketPricePerPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bookingFeePerPerson => $composableBuilder(
    column: $table.bookingFeePerPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPricePerPerson => $composableBuilder(
    column: $table.totalPricePerPerson,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itineraryRefs(
    Expression<bool> Function($$ItineraryTableFilterComposer f) f,
  ) {
    final $$ItineraryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itinerary,
      getReferencedColumn: (t) => t.trainId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItineraryTableFilterComposer(
            $db: $db,
            $table: $db.itinerary,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainsTable> {
  $$TrainsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seat => $composableBuilder(
    column: $table.seat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainNumber => $composableBuilder(
    column: $table.trainNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get departure => $composableBuilder(
    column: $table.departure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrival => $composableBuilder(
    column: $table.arrival,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ticketPricePerPerson => $composableBuilder(
    column: $table.ticketPricePerPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bookingFeePerPerson => $composableBuilder(
    column: $table.bookingFeePerPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPricePerPerson => $composableBuilder(
    column: $table.totalPricePerPerson,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainsTable> {
  $$TrainsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get seat =>
      $composableBuilder(column: $table.seat, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trainNumber => $composableBuilder(
    column: $table.trainNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get departure =>
      $composableBuilder(column: $table.departure, builder: (column) => column);

  GeneratedColumn<DateTime> get arrival =>
      $composableBuilder(column: $table.arrival, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<double> get ticketPricePerPerson => $composableBuilder(
    column: $table.ticketPricePerPerson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bookingFeePerPerson => $composableBuilder(
    column: $table.bookingFeePerPerson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPricePerPerson => $composableBuilder(
    column: $table.totalPricePerPerson,
    builder: (column) => column,
  );

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itineraryRefs<T extends Object>(
    Expression<T> Function($$ItineraryTableAnnotationComposer a) f,
  ) {
    final $$ItineraryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itinerary,
      getReferencedColumn: (t) => t.trainId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItineraryTableAnnotationComposer(
            $db: $db,
            $table: $db.itinerary,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainsTable,
          Train,
          $$TrainsTableFilterComposer,
          $$TrainsTableOrderingComposer,
          $$TrainsTableAnnotationComposer,
          $$TrainsTableCreateCompanionBuilder,
          $$TrainsTableUpdateCompanionBuilder,
          (Train, $$TrainsTableReferences),
          Train,
          PrefetchHooks Function({bool tripId, bool itineraryRefs})
        > {
  $$TrainsTableTableManager(_$AppDatabase db, $TrainsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<String?> bookingRef = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> seat = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> trainNumber = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String> destination = const Value.absent(),
                Value<DateTime> departure = const Value.absent(),
                Value<DateTime> arrival = const Value.absent(),
                Value<String?> duration = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<double?> ticketPricePerPerson = const Value.absent(),
                Value<double?> bookingFeePerPerson = const Value.absent(),
                Value<double?> totalPricePerPerson = const Value.absent(),
              }) => TrainsCompanion(
                tripId: tripId,
                bookingRef: bookingRef,
                status: status,
                seat: seat,
                id: id,
                trainNumber: trainNumber,
                origin: origin,
                destination: destination,
                departure: departure,
                arrival: arrival,
                duration: duration,
                platform: platform,
                ticketPricePerPerson: ticketPricePerPerson,
                bookingFeePerPerson: bookingFeePerPerson,
                totalPricePerPerson: totalPricePerPerson,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                Value<String?> bookingRef = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> seat = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String trainNumber,
                required String origin,
                required String destination,
                required DateTime departure,
                required DateTime arrival,
                Value<String?> duration = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<double?> ticketPricePerPerson = const Value.absent(),
                Value<double?> bookingFeePerPerson = const Value.absent(),
                Value<double?> totalPricePerPerson = const Value.absent(),
              }) => TrainsCompanion.insert(
                tripId: tripId,
                bookingRef: bookingRef,
                status: status,
                seat: seat,
                id: id,
                trainNumber: trainNumber,
                origin: origin,
                destination: destination,
                departure: departure,
                arrival: arrival,
                duration: duration,
                platform: platform,
                ticketPricePerPerson: ticketPricePerPerson,
                bookingFeePerPerson: bookingFeePerPerson,
                totalPricePerPerson: totalPricePerPerson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TrainsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false, itineraryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itineraryRefs) db.itinerary],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$TrainsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$TrainsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itineraryRefs)
                    await $_getPrefetchedData<
                      Train,
                      $TrainsTable,
                      ItineraryData
                    >(
                      currentTable: table,
                      referencedTable: $$TrainsTableReferences
                          ._itineraryRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TrainsTableReferences(db, table, p0).itineraryRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.trainId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TrainsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainsTable,
      Train,
      $$TrainsTableFilterComposer,
      $$TrainsTableOrderingComposer,
      $$TrainsTableAnnotationComposer,
      $$TrainsTableCreateCompanionBuilder,
      $$TrainsTableUpdateCompanionBuilder,
      (Train, $$TrainsTableReferences),
      Train,
      PrefetchHooks Function({bool tripId, bool itineraryRefs})
    >;
typedef $$ItineraryTableCreateCompanionBuilder =
    ItineraryCompanion Function({
      required int cityId,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> id,
      required DateTime date,
      Value<String?> time,
      required String title,
      Value<String?> type,
      Value<String?> location,
      Value<String?> addressEn,
      Value<String?> addressLocal,
      Value<String?> mapUrl,
      Value<String?> notes,
      Value<String?> url,
      Value<double?> price,
      Value<String?> currency,
      Value<int?> duration,
      Value<String?> availability,
      Value<String?> status,
      Value<DateTime?> bookedAt,
      Value<int?> flightId,
      Value<int?> trainId,
      Value<int?> hotelId,
      Value<String?> image,
    });
typedef $$ItineraryTableUpdateCompanionBuilder =
    ItineraryCompanion Function({
      Value<int> cityId,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> id,
      Value<DateTime> date,
      Value<String?> time,
      Value<String> title,
      Value<String?> type,
      Value<String?> location,
      Value<String?> addressEn,
      Value<String?> addressLocal,
      Value<String?> mapUrl,
      Value<String?> notes,
      Value<String?> url,
      Value<double?> price,
      Value<String?> currency,
      Value<int?> duration,
      Value<String?> availability,
      Value<String?> status,
      Value<DateTime?> bookedAt,
      Value<int?> flightId,
      Value<int?> trainId,
      Value<int?> hotelId,
      Value<String?> image,
    });

final class $$ItineraryTableReferences
    extends BaseReferences<_$AppDatabase, $ItineraryTable, ItineraryData> {
  $$ItineraryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CitiesTable _cityIdTable(_$AppDatabase db) => db.cities.createAlias(
    $_aliasNameGenerator(db.itinerary.cityId, db.cities.id),
  );

  $$CitiesTableProcessedTableManager get cityId {
    final $_column = $_itemColumn<int>('city_id')!;

    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FlightsTable _flightIdTable(_$AppDatabase db) => db.flights
      .createAlias($_aliasNameGenerator(db.itinerary.flightId, db.flights.id));

  $$FlightsTableProcessedTableManager? get flightId {
    final $_column = $_itemColumn<int>('flight_id');
    if ($_column == null) return null;
    final manager = $$FlightsTableTableManager(
      $_db,
      $_db.flights,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flightIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TrainsTable _trainIdTable(_$AppDatabase db) => db.trains.createAlias(
    $_aliasNameGenerator(db.itinerary.trainId, db.trains.id),
  );

  $$TrainsTableProcessedTableManager? get trainId {
    final $_column = $_itemColumn<int>('train_id');
    if ($_column == null) return null;
    final manager = $$TrainsTableTableManager(
      $_db,
      $_db.trains,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trainIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels.createAlias(
    $_aliasNameGenerator(db.itinerary.hotelId, db.hotels.id),
  );

  $$HotelsTableProcessedTableManager? get hotelId {
    final $_column = $_itemColumn<int>('hotel_id');
    if ($_column == null) return null;
    final manager = $$HotelsTableTableManager(
      $_db,
      $_db.hotels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItineraryTableFilterComposer
    extends Composer<_$AppDatabase, $ItineraryTable> {
  $$ItineraryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressEn => $composableBuilder(
    column: $table.addressEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mapUrl => $composableBuilder(
    column: $table.mapUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bookedAt => $composableBuilder(
    column: $table.bookedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  $$CitiesTableFilterComposer get cityId {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FlightsTableFilterComposer get flightId {
    final $$FlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableFilterComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrainsTableFilterComposer get trainId {
    final $$TrainsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trainId,
      referencedTable: $db.trains,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainsTableFilterComposer(
            $db: $db,
            $table: $db.trains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hotelId,
      referencedTable: $db.hotels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HotelsTableFilterComposer(
            $db: $db,
            $table: $db.hotels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItineraryTableOrderingComposer
    extends Composer<_$AppDatabase, $ItineraryTable> {
  $$ItineraryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressEn => $composableBuilder(
    column: $table.addressEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mapUrl => $composableBuilder(
    column: $table.mapUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bookedAt => $composableBuilder(
    column: $table.bookedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  $$CitiesTableOrderingComposer get cityId {
    final $$CitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableOrderingComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FlightsTableOrderingComposer get flightId {
    final $$FlightsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableOrderingComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrainsTableOrderingComposer get trainId {
    final $$TrainsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trainId,
      referencedTable: $db.trains,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainsTableOrderingComposer(
            $db: $db,
            $table: $db.trains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hotelId,
      referencedTable: $db.hotels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HotelsTableOrderingComposer(
            $db: $db,
            $table: $db.hotels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItineraryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItineraryTable> {
  $$ItineraryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get addressEn =>
      $composableBuilder(column: $table.addressEn, builder: (column) => column);

  GeneratedColumn<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mapUrl =>
      $composableBuilder(column: $table.mapUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get bookedAt =>
      $composableBuilder(column: $table.bookedAt, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  $$CitiesTableAnnotationComposer get cityId {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FlightsTableAnnotationComposer get flightId {
    final $$FlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrainsTableAnnotationComposer get trainId {
    final $$TrainsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trainId,
      referencedTable: $db.trains,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainsTableAnnotationComposer(
            $db: $db,
            $table: $db.trains,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hotelId,
      referencedTable: $db.hotels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HotelsTableAnnotationComposer(
            $db: $db,
            $table: $db.hotels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItineraryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItineraryTable,
          ItineraryData,
          $$ItineraryTableFilterComposer,
          $$ItineraryTableOrderingComposer,
          $$ItineraryTableAnnotationComposer,
          $$ItineraryTableCreateCompanionBuilder,
          $$ItineraryTableUpdateCompanionBuilder,
          (ItineraryData, $$ItineraryTableReferences),
          ItineraryData,
          PrefetchHooks Function({
            bool cityId,
            bool flightId,
            bool trainId,
            bool hotelId,
          })
        > {
  $$ItineraryTableTableManager(_$AppDatabase db, $ItineraryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItineraryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItineraryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItineraryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> cityId = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> addressEn = const Value.absent(),
                Value<String?> addressLocal = const Value.absent(),
                Value<String?> mapUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> availability = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime?> bookedAt = const Value.absent(),
                Value<int?> flightId = const Value.absent(),
                Value<int?> trainId = const Value.absent(),
                Value<int?> hotelId = const Value.absent(),
                Value<String?> image = const Value.absent(),
              }) => ItineraryCompanion(
                cityId: cityId,
                lat: lat,
                lng: lng,
                id: id,
                date: date,
                time: time,
                title: title,
                type: type,
                location: location,
                addressEn: addressEn,
                addressLocal: addressLocal,
                mapUrl: mapUrl,
                notes: notes,
                url: url,
                price: price,
                currency: currency,
                duration: duration,
                availability: availability,
                status: status,
                bookedAt: bookedAt,
                flightId: flightId,
                trainId: trainId,
                hotelId: hotelId,
                image: image,
              ),
          createCompanionCallback:
              ({
                required int cityId,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<String?> time = const Value.absent(),
                required String title,
                Value<String?> type = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> addressEn = const Value.absent(),
                Value<String?> addressLocal = const Value.absent(),
                Value<String?> mapUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> availability = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime?> bookedAt = const Value.absent(),
                Value<int?> flightId = const Value.absent(),
                Value<int?> trainId = const Value.absent(),
                Value<int?> hotelId = const Value.absent(),
                Value<String?> image = const Value.absent(),
              }) => ItineraryCompanion.insert(
                cityId: cityId,
                lat: lat,
                lng: lng,
                id: id,
                date: date,
                time: time,
                title: title,
                type: type,
                location: location,
                addressEn: addressEn,
                addressLocal: addressLocal,
                mapUrl: mapUrl,
                notes: notes,
                url: url,
                price: price,
                currency: currency,
                duration: duration,
                availability: availability,
                status: status,
                bookedAt: bookedAt,
                flightId: flightId,
                trainId: trainId,
                hotelId: hotelId,
                image: image,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ItineraryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cityId = false,
                flightId = false,
                trainId = false,
                hotelId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cityId,
                                    referencedTable: $$ItineraryTableReferences
                                        ._cityIdTable(db),
                                    referencedColumn: $$ItineraryTableReferences
                                        ._cityIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (flightId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.flightId,
                                    referencedTable: $$ItineraryTableReferences
                                        ._flightIdTable(db),
                                    referencedColumn: $$ItineraryTableReferences
                                        ._flightIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (trainId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.trainId,
                                    referencedTable: $$ItineraryTableReferences
                                        ._trainIdTable(db),
                                    referencedColumn: $$ItineraryTableReferences
                                        ._trainIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (hotelId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.hotelId,
                                    referencedTable: $$ItineraryTableReferences
                                        ._hotelIdTable(db),
                                    referencedColumn: $$ItineraryTableReferences
                                        ._hotelIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ItineraryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItineraryTable,
      ItineraryData,
      $$ItineraryTableFilterComposer,
      $$ItineraryTableOrderingComposer,
      $$ItineraryTableAnnotationComposer,
      $$ItineraryTableCreateCompanionBuilder,
      $$ItineraryTableUpdateCompanionBuilder,
      (ItineraryData, $$ItineraryTableReferences),
      ItineraryData,
      PrefetchHooks Function({
        bool cityId,
        bool flightId,
        bool trainId,
        bool hotelId,
      })
    >;
typedef $$PackingItemsTableCreateCompanionBuilder =
    PackingItemsCompanion Function({
      required int tripId,
      Value<int> id,
      required String item,
      Value<String?> category,
      Value<int> quantity,
      Value<bool> isPacked,
      Value<String?> notes,
    });
typedef $$PackingItemsTableUpdateCompanionBuilder =
    PackingItemsCompanion Function({
      Value<int> tripId,
      Value<int> id,
      Value<String> item,
      Value<String?> category,
      Value<int> quantity,
      Value<bool> isPacked,
      Value<String?> notes,
    });

final class $$PackingItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PackingItemsTable, PackingItem> {
  $$PackingItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips.createAlias(
    $_aliasNameGenerator(db.packingItems.tripId, db.trips.id),
  );

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PackingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PackingItemsTable> {
  $$PackingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPacked => $composableBuilder(
    column: $table.isPacked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PackingItemsTable> {
  $$PackingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPacked => $composableBuilder(
    column: $table.isPacked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackingItemsTable> {
  $$PackingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get isPacked =>
      $composableBuilder(column: $table.isPacked, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackingItemsTable,
          PackingItem,
          $$PackingItemsTableFilterComposer,
          $$PackingItemsTableOrderingComposer,
          $$PackingItemsTableAnnotationComposer,
          $$PackingItemsTableCreateCompanionBuilder,
          $$PackingItemsTableUpdateCompanionBuilder,
          (PackingItem, $$PackingItemsTableReferences),
          PackingItem,
          PrefetchHooks Function({bool tripId})
        > {
  $$PackingItemsTableTableManager(_$AppDatabase db, $PackingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> isPacked = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => PackingItemsCompanion(
                tripId: tripId,
                id: id,
                item: item,
                category: category,
                quantity: quantity,
                isPacked: isPacked,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                Value<int> id = const Value.absent(),
                required String item,
                Value<String?> category = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> isPacked = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => PackingItemsCompanion.insert(
                tripId: tripId,
                id: id,
                item: item,
                category: category,
                quantity: quantity,
                isPacked: isPacked,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PackingItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$PackingItemsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$PackingItemsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PackingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackingItemsTable,
      PackingItem,
      $$PackingItemsTableFilterComposer,
      $$PackingItemsTableOrderingComposer,
      $$PackingItemsTableAnnotationComposer,
      $$PackingItemsTableCreateCompanionBuilder,
      $$PackingItemsTableUpdateCompanionBuilder,
      (PackingItem, $$PackingItemsTableReferences),
      PackingItem,
      PrefetchHooks Function({bool tripId})
    >;
typedef $$TripTipsTableCreateCompanionBuilder =
    TripTipsCompanion Function({
      required int tripId,
      Value<int> id,
      Value<int?> cityId,
      required String category,
      required String title,
      required String content,
      Value<String?> language,
    });
typedef $$TripTipsTableUpdateCompanionBuilder =
    TripTipsCompanion Function({
      Value<int> tripId,
      Value<int> id,
      Value<int?> cityId,
      Value<String> category,
      Value<String> title,
      Value<String> content,
      Value<String?> language,
    });

final class $$TripTipsTableReferences
    extends BaseReferences<_$AppDatabase, $TripTipsTable, TripTip> {
  $$TripTipsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips.createAlias(
    $_aliasNameGenerator(db.tripTips.tripId, db.trips.id),
  );

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CitiesTable _cityIdTable(_$AppDatabase db) => db.cities.createAlias(
    $_aliasNameGenerator(db.tripTips.cityId, db.cities.id),
  );

  $$CitiesTableProcessedTableManager? get cityId {
    final $_column = $_itemColumn<int>('city_id');
    if ($_column == null) return null;
    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TripTipsTableFilterComposer
    extends Composer<_$AppDatabase, $TripTipsTable> {
  $$TripTipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableFilterComposer get cityId {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripTipsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripTipsTable> {
  $$TripTipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableOrderingComposer get cityId {
    final $$CitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableOrderingComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripTipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripTipsTable> {
  $$TripTipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableAnnotationComposer get cityId {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripTipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripTipsTable,
          TripTip,
          $$TripTipsTableFilterComposer,
          $$TripTipsTableOrderingComposer,
          $$TripTipsTableAnnotationComposer,
          $$TripTipsTableCreateCompanionBuilder,
          $$TripTipsTableUpdateCompanionBuilder,
          (TripTip, $$TripTipsTableReferences),
          TripTip,
          PrefetchHooks Function({bool tripId, bool cityId})
        > {
  $$TripTipsTableTableManager(_$AppDatabase db, $TripTipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripTipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripTipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripTipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int?> cityId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> language = const Value.absent(),
              }) => TripTipsCompanion(
                tripId: tripId,
                id: id,
                cityId: cityId,
                category: category,
                title: title,
                content: content,
                language: language,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                Value<int> id = const Value.absent(),
                Value<int?> cityId = const Value.absent(),
                required String category,
                required String title,
                required String content,
                Value<String?> language = const Value.absent(),
              }) => TripTipsCompanion.insert(
                tripId: tripId,
                id: id,
                cityId: cityId,
                category: category,
                title: title,
                content: content,
                language: language,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TripTipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false, cityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$TripTipsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$TripTipsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (cityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cityId,
                                referencedTable: $$TripTipsTableReferences
                                    ._cityIdTable(db),
                                referencedColumn: $$TripTipsTableReferences
                                    ._cityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TripTipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripTipsTable,
      TripTip,
      $$TripTipsTableFilterComposer,
      $$TripTipsTableOrderingComposer,
      $$TripTipsTableAnnotationComposer,
      $$TripTipsTableCreateCompanionBuilder,
      $$TripTipsTableUpdateCompanionBuilder,
      (TripTip, $$TripTipsTableReferences),
      TripTip,
      PrefetchHooks Function({bool tripId, bool cityId})
    >;
typedef $$CitySummariesTableCreateCompanionBuilder =
    CitySummariesCompanion Function({
      required int tripId,
      required int cityId,
      Value<int> id,
      required String summaryText,
      Value<String?> sourceLanguage,
    });
typedef $$CitySummariesTableUpdateCompanionBuilder =
    CitySummariesCompanion Function({
      Value<int> tripId,
      Value<int> cityId,
      Value<int> id,
      Value<String> summaryText,
      Value<String?> sourceLanguage,
    });

final class $$CitySummariesTableReferences
    extends BaseReferences<_$AppDatabase, $CitySummariesTable, CitySummary> {
  $$CitySummariesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips.createAlias(
    $_aliasNameGenerator(db.citySummaries.tripId, db.trips.id),
  );

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CitiesTable _cityIdTable(_$AppDatabase db) => db.cities.createAlias(
    $_aliasNameGenerator(db.citySummaries.cityId, db.cities.id),
  );

  $$CitiesTableProcessedTableManager get cityId {
    final $_column = $_itemColumn<int>('city_id')!;

    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CitySummariesTableFilterComposer
    extends Composer<_$AppDatabase, $CitySummariesTable> {
  $$CitySummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableFilterComposer get cityId {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CitySummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $CitySummariesTable> {
  $$CitySummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableOrderingComposer get cityId {
    final $$CitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableOrderingComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CitySummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CitySummariesTable> {
  $$CitySummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => column,
  );

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableAnnotationComposer get cityId {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CitySummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CitySummariesTable,
          CitySummary,
          $$CitySummariesTableFilterComposer,
          $$CitySummariesTableOrderingComposer,
          $$CitySummariesTableAnnotationComposer,
          $$CitySummariesTableCreateCompanionBuilder,
          $$CitySummariesTableUpdateCompanionBuilder,
          (CitySummary, $$CitySummariesTableReferences),
          CitySummary,
          PrefetchHooks Function({bool tripId, bool cityId})
        > {
  $$CitySummariesTableTableManager(_$AppDatabase db, $CitySummariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitySummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitySummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CitySummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<int> cityId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> summaryText = const Value.absent(),
                Value<String?> sourceLanguage = const Value.absent(),
              }) => CitySummariesCompanion(
                tripId: tripId,
                cityId: cityId,
                id: id,
                summaryText: summaryText,
                sourceLanguage: sourceLanguage,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                required int cityId,
                Value<int> id = const Value.absent(),
                required String summaryText,
                Value<String?> sourceLanguage = const Value.absent(),
              }) => CitySummariesCompanion.insert(
                tripId: tripId,
                cityId: cityId,
                id: id,
                summaryText: summaryText,
                sourceLanguage: sourceLanguage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CitySummariesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false, cityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$CitySummariesTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$CitySummariesTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (cityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cityId,
                                referencedTable: $$CitySummariesTableReferences
                                    ._cityIdTable(db),
                                referencedColumn: $$CitySummariesTableReferences
                                    ._cityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CitySummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CitySummariesTable,
      CitySummary,
      $$CitySummariesTableFilterComposer,
      $$CitySummariesTableOrderingComposer,
      $$CitySummariesTableAnnotationComposer,
      $$CitySummariesTableCreateCompanionBuilder,
      $$CitySummariesTableUpdateCompanionBuilder,
      (CitySummary, $$CitySummariesTableReferences),
      CitySummary,
      PrefetchHooks Function({bool tripId, bool cityId})
    >;
typedef $$FoodsTableCreateCompanionBuilder =
    FoodsCompanion Function({
      required int tripId,
      required int cityId,
      Value<int> id,
      required String name,
      Value<String?> category,
      Value<String?> amapUrl,
      Value<double?> avgPriceCny,
      Value<double?> avgPriceEur,
      Value<String?> recommendedDishes,
      Value<String?> notes,
    });
typedef $$FoodsTableUpdateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> tripId,
      Value<int> cityId,
      Value<int> id,
      Value<String> name,
      Value<String?> category,
      Value<String?> amapUrl,
      Value<double?> avgPriceCny,
      Value<double?> avgPriceEur,
      Value<String?> recommendedDishes,
      Value<String?> notes,
    });

final class $$FoodsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodsTable, Food> {
  $$FoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias($_aliasNameGenerator(db.foods.tripId, db.trips.id));

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CitiesTable _cityIdTable(_$AppDatabase db) => db.cities.createAlias(
    $_aliasNameGenerator(db.foods.cityId, db.cities.id),
  );

  $$CitiesTableProcessedTableManager get cityId {
    final $_column = $_itemColumn<int>('city_id')!;

    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amapUrl => $composableBuilder(
    column: $table.amapUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgPriceCny => $composableBuilder(
    column: $table.avgPriceCny,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgPriceEur => $composableBuilder(
    column: $table.avgPriceEur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendedDishes => $composableBuilder(
    column: $table.recommendedDishes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableFilterComposer get cityId {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amapUrl => $composableBuilder(
    column: $table.amapUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgPriceCny => $composableBuilder(
    column: $table.avgPriceCny,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgPriceEur => $composableBuilder(
    column: $table.avgPriceEur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendedDishes => $composableBuilder(
    column: $table.recommendedDishes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableOrderingComposer get cityId {
    final $$CitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableOrderingComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get amapUrl =>
      $composableBuilder(column: $table.amapUrl, builder: (column) => column);

  GeneratedColumn<double> get avgPriceCny => $composableBuilder(
    column: $table.avgPriceCny,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgPriceEur => $composableBuilder(
    column: $table.avgPriceEur,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recommendedDishes => $composableBuilder(
    column: $table.recommendedDishes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableAnnotationComposer get cityId {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          Food,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (Food, $$FoodsTableReferences),
          Food,
          PrefetchHooks Function({bool tripId, bool cityId})
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<int> cityId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> amapUrl = const Value.absent(),
                Value<double?> avgPriceCny = const Value.absent(),
                Value<double?> avgPriceEur = const Value.absent(),
                Value<String?> recommendedDishes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => FoodsCompanion(
                tripId: tripId,
                cityId: cityId,
                id: id,
                name: name,
                category: category,
                amapUrl: amapUrl,
                avgPriceCny: avgPriceCny,
                avgPriceEur: avgPriceEur,
                recommendedDishes: recommendedDishes,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                required int cityId,
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> category = const Value.absent(),
                Value<String?> amapUrl = const Value.absent(),
                Value<double?> avgPriceCny = const Value.absent(),
                Value<double?> avgPriceEur = const Value.absent(),
                Value<String?> recommendedDishes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => FoodsCompanion.insert(
                tripId: tripId,
                cityId: cityId,
                id: id,
                name: name,
                category: category,
                amapUrl: amapUrl,
                avgPriceCny: avgPriceCny,
                avgPriceEur: avgPriceEur,
                recommendedDishes: recommendedDishes,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FoodsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false, cityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$FoodsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$FoodsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (cityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cityId,
                                referencedTable: $$FoodsTableReferences
                                    ._cityIdTable(db),
                                referencedColumn: $$FoodsTableReferences
                                    ._cityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      Food,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (Food, $$FoodsTableReferences),
      Food,
      PrefetchHooks Function({bool tripId, bool cityId})
    >;
typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      required int tripId,
      required int cityId,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> id,
      required String name,
      required String type,
      Value<String?> category,
      Value<String?> addressEn,
      Value<String?> addressLocal,
      Value<String?> mapUrl,
      Value<String?> image,
      Value<String?> notes,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> sourceTable,
      Value<String?> sourceId,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<int> tripId,
      Value<int> cityId,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<String?> category,
      Value<String?> addressEn,
      Value<String?> addressLocal,
      Value<String?> mapUrl,
      Value<String?> image,
      Value<String?> notes,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> sourceTable,
      Value<String?> sourceId,
    });

final class $$LocationsTableReferences
    extends BaseReferences<_$AppDatabase, $LocationsTable, Location> {
  $$LocationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips.createAlias(
    $_aliasNameGenerator(db.locations.tripId, db.trips.id),
  );

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CitiesTable _cityIdTable(_$AppDatabase db) => db.cities.createAlias(
    $_aliasNameGenerator(db.locations.cityId, db.cities.id),
  );

  $$CitiesTableProcessedTableManager get cityId {
    final $_column = $_itemColumn<int>('city_id')!;

    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressEn => $composableBuilder(
    column: $table.addressEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mapUrl => $composableBuilder(
    column: $table.mapUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTable => $composableBuilder(
    column: $table.sourceTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableFilterComposer get cityId {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressEn => $composableBuilder(
    column: $table.addressEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mapUrl => $composableBuilder(
    column: $table.mapUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTable => $composableBuilder(
    column: $table.sourceTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableOrderingComposer get cityId {
    final $$CitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableOrderingComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get addressEn =>
      $composableBuilder(column: $table.addressEn, builder: (column) => column);

  GeneratedColumn<String> get addressLocal => $composableBuilder(
    column: $table.addressLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mapUrl =>
      $composableBuilder(column: $table.mapUrl, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get sourceTable => $composableBuilder(
    column: $table.sourceTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CitiesTableAnnotationComposer get cityId {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          Location,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (Location, $$LocationsTableReferences),
          Location,
          PrefetchHooks Function({bool tripId, bool cityId})
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<int> cityId = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> addressEn = const Value.absent(),
                Value<String?> addressLocal = const Value.absent(),
                Value<String?> mapUrl = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> sourceTable = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
              }) => LocationsCompanion(
                tripId: tripId,
                cityId: cityId,
                lat: lat,
                lng: lng,
                id: id,
                name: name,
                type: type,
                category: category,
                addressEn: addressEn,
                addressLocal: addressLocal,
                mapUrl: mapUrl,
                image: image,
                notes: notes,
                phone: phone,
                website: website,
                sourceTable: sourceTable,
                sourceId: sourceId,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                required int cityId,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                Value<String?> category = const Value.absent(),
                Value<String?> addressEn = const Value.absent(),
                Value<String?> addressLocal = const Value.absent(),
                Value<String?> mapUrl = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> sourceTable = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
              }) => LocationsCompanion.insert(
                tripId: tripId,
                cityId: cityId,
                lat: lat,
                lng: lng,
                id: id,
                name: name,
                type: type,
                category: category,
                addressEn: addressEn,
                addressLocal: addressLocal,
                mapUrl: mapUrl,
                image: image,
                notes: notes,
                phone: phone,
                website: website,
                sourceTable: sourceTable,
                sourceId: sourceId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false, cityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$LocationsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$LocationsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (cityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cityId,
                                referencedTable: $$LocationsTableReferences
                                    ._cityIdTable(db),
                                referencedColumn: $$LocationsTableReferences
                                    ._cityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      Location,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (Location, $$LocationsTableReferences),
      Location,
      PrefetchHooks Function({bool tripId, bool cityId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$CitiesTableTableManager get cities =>
      $$CitiesTableTableManager(_db, _db.cities);
  $$HotelsTableTableManager get hotels =>
      $$HotelsTableTableManager(_db, _db.hotels);
  $$FlightsTableTableManager get flights =>
      $$FlightsTableTableManager(_db, _db.flights);
  $$TrainsTableTableManager get trains =>
      $$TrainsTableTableManager(_db, _db.trains);
  $$ItineraryTableTableManager get itinerary =>
      $$ItineraryTableTableManager(_db, _db.itinerary);
  $$PackingItemsTableTableManager get packingItems =>
      $$PackingItemsTableTableManager(_db, _db.packingItems);
  $$TripTipsTableTableManager get tripTips =>
      $$TripTipsTableTableManager(_db, _db.tripTips);
  $$CitySummariesTableTableManager get citySummaries =>
      $$CitySummariesTableTableManager(_db, _db.citySummaries);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
}
