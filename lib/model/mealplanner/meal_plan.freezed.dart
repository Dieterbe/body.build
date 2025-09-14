// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealPlan _$MealPlanFromJson(Map<String, dynamic> json) {
  return _MealPlan.fromJson(json);
}

/// @nodoc
mixin _$MealPlan {
  String get name => throw _privateConstructorUsedError;
  List<DayPlan> get dayplans => throw _privateConstructorUsedError; // to support the wizard.
  CalorieCyclingType get calorieCycling => throw _privateConstructorUsedError;
  int get mealsPerDay => throw _privateConstructorUsedError;
  int get trainingDaysPerWeek => throw _privateConstructorUsedError;

  /// Serializes this MealPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlanCopyWith<MealPlan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanCopyWith<$Res> {
  factory $MealPlanCopyWith(MealPlan value, $Res Function(MealPlan) then) =
      _$MealPlanCopyWithImpl<$Res, MealPlan>;
  @useResult
  $Res call(
      {String name,
      List<DayPlan> dayplans,
      CalorieCyclingType calorieCycling,
      int mealsPerDay,
      int trainingDaysPerWeek});
}

/// @nodoc
class _$MealPlanCopyWithImpl<$Res, $Val extends MealPlan> implements $MealPlanCopyWith<$Res> {
  _$MealPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dayplans = null,
    Object? calorieCycling = null,
    Object? mealsPerDay = null,
    Object? trainingDaysPerWeek = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dayplans: null == dayplans
          ? _value.dayplans
          : dayplans // ignore: cast_nullable_to_non_nullable
              as List<DayPlan>,
      calorieCycling: null == calorieCycling
          ? _value.calorieCycling
          : calorieCycling // ignore: cast_nullable_to_non_nullable
              as CalorieCyclingType,
      mealsPerDay: null == mealsPerDay
          ? _value.mealsPerDay
          : mealsPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      trainingDaysPerWeek: null == trainingDaysPerWeek
          ? _value.trainingDaysPerWeek
          : trainingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealPlanImplCopyWith<$Res> implements $MealPlanCopyWith<$Res> {
  factory _$$MealPlanImplCopyWith(_$MealPlanImpl value, $Res Function(_$MealPlanImpl) then) =
      __$$MealPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      List<DayPlan> dayplans,
      CalorieCyclingType calorieCycling,
      int mealsPerDay,
      int trainingDaysPerWeek});
}

/// @nodoc
class __$$MealPlanImplCopyWithImpl<$Res> extends _$MealPlanCopyWithImpl<$Res, _$MealPlanImpl>
    implements _$$MealPlanImplCopyWith<$Res> {
  __$$MealPlanImplCopyWithImpl(_$MealPlanImpl _value, $Res Function(_$MealPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dayplans = null,
    Object? calorieCycling = null,
    Object? mealsPerDay = null,
    Object? trainingDaysPerWeek = null,
  }) {
    return _then(_$MealPlanImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dayplans: null == dayplans
          ? _value._dayplans
          : dayplans // ignore: cast_nullable_to_non_nullable
              as List<DayPlan>,
      calorieCycling: null == calorieCycling
          ? _value.calorieCycling
          : calorieCycling // ignore: cast_nullable_to_non_nullable
              as CalorieCyclingType,
      mealsPerDay: null == mealsPerDay
          ? _value.mealsPerDay
          : mealsPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      trainingDaysPerWeek: null == trainingDaysPerWeek
          ? _value.trainingDaysPerWeek
          : trainingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlanImpl with DiagnosticableTreeMixin implements _MealPlan {
  const _$MealPlanImpl(
      {required this.name,
      final List<DayPlan> dayplans = const <DayPlan>[],
      this.calorieCycling = CalorieCyclingType.off,
      this.mealsPerDay = 4,
      this.trainingDaysPerWeek = 3})
      : _dayplans = dayplans;

  factory _$MealPlanImpl.fromJson(Map<String, dynamic> json) => _$$MealPlanImplFromJson(json);

  @override
  final String name;
  final List<DayPlan> _dayplans;
  @override
  @JsonKey()
  List<DayPlan> get dayplans {
    if (_dayplans is EqualUnmodifiableListView) return _dayplans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dayplans);
  }

// to support the wizard.
  @override
  @JsonKey()
  final CalorieCyclingType calorieCycling;
  @override
  @JsonKey()
  final int mealsPerDay;
  @override
  @JsonKey()
  final int trainingDaysPerWeek;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MealPlan(name: $name, dayplans: $dayplans, calorieCycling: $calorieCycling, mealsPerDay: $mealsPerDay, trainingDaysPerWeek: $trainingDaysPerWeek)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MealPlan'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('dayplans', dayplans))
      ..add(DiagnosticsProperty('calorieCycling', calorieCycling))
      ..add(DiagnosticsProperty('mealsPerDay', mealsPerDay))
      ..add(DiagnosticsProperty('trainingDaysPerWeek', trainingDaysPerWeek));
  }

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanImplCopyWith<_$MealPlanImpl> get copyWith =>
      __$$MealPlanImplCopyWithImpl<_$MealPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanImplToJson(
      this,
    );
  }
}

abstract class _MealPlan implements MealPlan {
  const factory _MealPlan(
      {required final String name,
      final List<DayPlan> dayplans,
      final CalorieCyclingType calorieCycling,
      final int mealsPerDay,
      final int trainingDaysPerWeek}) = _$MealPlanImpl;

  factory _MealPlan.fromJson(Map<String, dynamic> json) = _$MealPlanImpl.fromJson;

  @override
  String get name;
  @override
  List<DayPlan> get dayplans; // to support the wizard.
  @override
  CalorieCyclingType get calorieCycling;
  @override
  int get mealsPerDay;
  @override
  int get trainingDaysPerWeek;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlanImplCopyWith<_$MealPlanImpl> get copyWith => throw _privateConstructorUsedError;
}

DayPlan _$DayPlanFromJson(Map<String, dynamic> json) {
  return _DayPlan.fromJson(json);
}

/// @nodoc
mixin _$DayPlan {
  String get desc => throw _privateConstructorUsedError;
  Targets get targets => throw _privateConstructorUsedError;
  List<Event> get events =>
      throw _privateConstructorUsedError; // how many times this day is done within one plan (the plan duration is the sum of the num of all its days)
  int get num => throw _privateConstructorUsedError;

  /// Serializes this DayPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayPlanCopyWith<DayPlan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayPlanCopyWith<$Res> {
  factory $DayPlanCopyWith(DayPlan value, $Res Function(DayPlan) then) =
      _$DayPlanCopyWithImpl<$Res, DayPlan>;
  @useResult
  $Res call({String desc, Targets targets, List<Event> events, int num});

  $TargetsCopyWith<$Res> get targets;
}

/// @nodoc
class _$DayPlanCopyWithImpl<$Res, $Val extends DayPlan> implements $DayPlanCopyWith<$Res> {
  _$DayPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
    Object? targets = null,
    Object? events = null,
    Object? num = null,
  }) {
    return _then(_value.copyWith(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as Targets,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Event>,
      num: null == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TargetsCopyWith<$Res> get targets {
    return $TargetsCopyWith<$Res>(_value.targets, (value) {
      return _then(_value.copyWith(targets: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DayPlanImplCopyWith<$Res> implements $DayPlanCopyWith<$Res> {
  factory _$$DayPlanImplCopyWith(_$DayPlanImpl value, $Res Function(_$DayPlanImpl) then) =
      __$$DayPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String desc, Targets targets, List<Event> events, int num});

  @override
  $TargetsCopyWith<$Res> get targets;
}

/// @nodoc
class __$$DayPlanImplCopyWithImpl<$Res> extends _$DayPlanCopyWithImpl<$Res, _$DayPlanImpl>
    implements _$$DayPlanImplCopyWith<$Res> {
  __$$DayPlanImplCopyWithImpl(_$DayPlanImpl _value, $Res Function(_$DayPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
    Object? targets = null,
    Object? events = null,
    Object? num = null,
  }) {
    return _then(_$DayPlanImpl(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as Targets,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Event>,
      num: null == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DayPlanImpl with DiagnosticableTreeMixin implements _DayPlan {
  const _$DayPlanImpl(
      {required this.desc, required this.targets, required final List<Event> events, this.num = 1})
      : _events = events;

  factory _$DayPlanImpl.fromJson(Map<String, dynamic> json) => _$$DayPlanImplFromJson(json);

  @override
  final String desc;
  @override
  final Targets targets;
  final List<Event> _events;
  @override
  List<Event> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

// how many times this day is done within one plan (the plan duration is the sum of the num of all its days)
  @override
  @JsonKey()
  final int num;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DayPlan(desc: $desc, targets: $targets, events: $events, num: $num)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DayPlan'))
      ..add(DiagnosticsProperty('desc', desc))
      ..add(DiagnosticsProperty('targets', targets))
      ..add(DiagnosticsProperty('events', events))
      ..add(DiagnosticsProperty('num', num));
  }

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayPlanImplCopyWith<_$DayPlanImpl> get copyWith =>
      __$$DayPlanImplCopyWithImpl<_$DayPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DayPlanImplToJson(
      this,
    );
  }
}

abstract class _DayPlan implements DayPlan {
  const factory _DayPlan(
      {required final String desc,
      required final Targets targets,
      required final List<Event> events,
      final int num}) = _$DayPlanImpl;

  factory _DayPlan.fromJson(Map<String, dynamic> json) = _$DayPlanImpl.fromJson;

  @override
  String get desc;
  @override
  Targets get targets;
  @override
  List<Event>
      get events; // how many times this day is done within one plan (the plan duration is the sum of the num of all its days)
  @override
  int get num;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayPlanImplCopyWith<_$DayPlanImpl> get copyWith => throw _privateConstructorUsedError;
}

Event _$EventFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'meal':
      return MealEvent.fromJson(json);
    case 'strengthWorkout':
      return StrengthWorkoutEvent.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'runtimeType', 'Event', 'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$Event {
  String get desc => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String desc, Targets targets) meal,
    required TResult Function(String desc, double estimatedKcal) strengthWorkout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String desc, Targets targets)? meal,
    TResult? Function(String desc, double estimatedKcal)? strengthWorkout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String desc, Targets targets)? meal,
    TResult Function(String desc, double estimatedKcal)? strengthWorkout,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MealEvent value) meal,
    required TResult Function(StrengthWorkoutEvent value) strengthWorkout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MealEvent value)? meal,
    TResult? Function(StrengthWorkoutEvent value)? strengthWorkout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MealEvent value)? meal,
    TResult Function(StrengthWorkoutEvent value)? strengthWorkout,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) = _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call({String desc});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event> implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
  }) {
    return _then(_value.copyWith(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealEventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$MealEventImplCopyWith(_$MealEventImpl value, $Res Function(_$MealEventImpl) then) =
      __$$MealEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String desc, Targets targets});

  $TargetsCopyWith<$Res> get targets;
}

/// @nodoc
class __$$MealEventImplCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res, _$MealEventImpl>
    implements _$$MealEventImplCopyWith<$Res> {
  __$$MealEventImplCopyWithImpl(_$MealEventImpl _value, $Res Function(_$MealEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
    Object? targets = null,
  }) {
    return _then(_$MealEventImpl(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as Targets,
    ));
  }

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TargetsCopyWith<$Res> get targets {
    return $TargetsCopyWith<$Res>(_value.targets, (value) {
      return _then(_value.copyWith(targets: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$MealEventImpl with DiagnosticableTreeMixin implements MealEvent {
  const _$MealEventImpl({required this.desc, required this.targets, final String? $type})
      : $type = $type ?? 'meal';

  factory _$MealEventImpl.fromJson(Map<String, dynamic> json) => _$$MealEventImplFromJson(json);

  @override
  final String desc;
  @override
  final Targets targets;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Event.meal(desc: $desc, targets: $targets)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Event.meal'))
      ..add(DiagnosticsProperty('desc', desc))
      ..add(DiagnosticsProperty('targets', targets));
  }

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealEventImplCopyWith<_$MealEventImpl> get copyWith =>
      __$$MealEventImplCopyWithImpl<_$MealEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String desc, Targets targets) meal,
    required TResult Function(String desc, double estimatedKcal) strengthWorkout,
  }) {
    return meal(desc, targets);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String desc, Targets targets)? meal,
    TResult? Function(String desc, double estimatedKcal)? strengthWorkout,
  }) {
    return meal?.call(desc, targets);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String desc, Targets targets)? meal,
    TResult Function(String desc, double estimatedKcal)? strengthWorkout,
    required TResult orElse(),
  }) {
    if (meal != null) {
      return meal(desc, targets);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MealEvent value) meal,
    required TResult Function(StrengthWorkoutEvent value) strengthWorkout,
  }) {
    return meal(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MealEvent value)? meal,
    TResult? Function(StrengthWorkoutEvent value)? strengthWorkout,
  }) {
    return meal?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MealEvent value)? meal,
    TResult Function(StrengthWorkoutEvent value)? strengthWorkout,
    required TResult orElse(),
  }) {
    if (meal != null) {
      return meal(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MealEventImplToJson(
      this,
    );
  }
}

abstract class MealEvent implements Event {
  const factory MealEvent({required final String desc, required final Targets targets}) =
      _$MealEventImpl;

  factory MealEvent.fromJson(Map<String, dynamic> json) = _$MealEventImpl.fromJson;

  @override
  String get desc;
  Targets get targets;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealEventImplCopyWith<_$MealEventImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StrengthWorkoutEventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$StrengthWorkoutEventImplCopyWith(
          _$StrengthWorkoutEventImpl value, $Res Function(_$StrengthWorkoutEventImpl) then) =
      __$$StrengthWorkoutEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String desc, double estimatedKcal});
}

/// @nodoc
class __$$StrengthWorkoutEventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$StrengthWorkoutEventImpl>
    implements _$$StrengthWorkoutEventImplCopyWith<$Res> {
  __$$StrengthWorkoutEventImplCopyWithImpl(
      _$StrengthWorkoutEventImpl _value, $Res Function(_$StrengthWorkoutEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
    Object? estimatedKcal = null,
  }) {
    return _then(_$StrengthWorkoutEventImpl(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedKcal: null == estimatedKcal
          ? _value.estimatedKcal
          : estimatedKcal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StrengthWorkoutEventImpl with DiagnosticableTreeMixin implements StrengthWorkoutEvent {
  const _$StrengthWorkoutEventImpl(
      {required this.desc, required this.estimatedKcal, final String? $type})
      : $type = $type ?? 'strengthWorkout';

  factory _$StrengthWorkoutEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrengthWorkoutEventImplFromJson(json);

  @override
  final String desc;
  @override
  final double estimatedKcal;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Event.strengthWorkout(desc: $desc, estimatedKcal: $estimatedKcal)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Event.strengthWorkout'))
      ..add(DiagnosticsProperty('desc', desc))
      ..add(DiagnosticsProperty('estimatedKcal', estimatedKcal));
  }

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StrengthWorkoutEventImplCopyWith<_$StrengthWorkoutEventImpl> get copyWith =>
      __$$StrengthWorkoutEventImplCopyWithImpl<_$StrengthWorkoutEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String desc, Targets targets) meal,
    required TResult Function(String desc, double estimatedKcal) strengthWorkout,
  }) {
    return strengthWorkout(desc, estimatedKcal);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String desc, Targets targets)? meal,
    TResult? Function(String desc, double estimatedKcal)? strengthWorkout,
  }) {
    return strengthWorkout?.call(desc, estimatedKcal);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String desc, Targets targets)? meal,
    TResult Function(String desc, double estimatedKcal)? strengthWorkout,
    required TResult orElse(),
  }) {
    if (strengthWorkout != null) {
      return strengthWorkout(desc, estimatedKcal);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MealEvent value) meal,
    required TResult Function(StrengthWorkoutEvent value) strengthWorkout,
  }) {
    return strengthWorkout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MealEvent value)? meal,
    TResult? Function(StrengthWorkoutEvent value)? strengthWorkout,
  }) {
    return strengthWorkout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MealEvent value)? meal,
    TResult Function(StrengthWorkoutEvent value)? strengthWorkout,
    required TResult orElse(),
  }) {
    if (strengthWorkout != null) {
      return strengthWorkout(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StrengthWorkoutEventImplToJson(
      this,
    );
  }
}

abstract class StrengthWorkoutEvent implements Event {
  const factory StrengthWorkoutEvent(
      {required final String desc,
      required final double estimatedKcal}) = _$StrengthWorkoutEventImpl;

  factory StrengthWorkoutEvent.fromJson(Map<String, dynamic> json) =
      _$StrengthWorkoutEventImpl.fromJson;

  @override
  String get desc;
  double get estimatedKcal;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StrengthWorkoutEventImplCopyWith<_$StrengthWorkoutEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Targets _$TargetsFromJson(Map<String, dynamic> json) {
  return _Targets.fromJson(json);
}

/// @nodoc
mixin _$Targets {
  double get minProtein => throw _privateConstructorUsedError;
  double get maxProtein => throw _privateConstructorUsedError;
  double get minCarbs => throw _privateConstructorUsedError;
  double get maxCarbs => throw _privateConstructorUsedError;
  double get minFats => throw _privateConstructorUsedError;
  double get maxFats => throw _privateConstructorUsedError;
  double get kCal => throw _privateConstructorUsedError;

  /// Serializes this Targets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TargetsCopyWith<Targets> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TargetsCopyWith<$Res> {
  factory $TargetsCopyWith(Targets value, $Res Function(Targets) then) =
      _$TargetsCopyWithImpl<$Res, Targets>;
  @useResult
  $Res call(
      {double minProtein,
      double maxProtein,
      double minCarbs,
      double maxCarbs,
      double minFats,
      double maxFats,
      double kCal});
}

/// @nodoc
class _$TargetsCopyWithImpl<$Res, $Val extends Targets> implements $TargetsCopyWith<$Res> {
  _$TargetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minProtein = null,
    Object? maxProtein = null,
    Object? minCarbs = null,
    Object? maxCarbs = null,
    Object? minFats = null,
    Object? maxFats = null,
    Object? kCal = null,
  }) {
    return _then(_value.copyWith(
      minProtein: null == minProtein
          ? _value.minProtein
          : minProtein // ignore: cast_nullable_to_non_nullable
              as double,
      maxProtein: null == maxProtein
          ? _value.maxProtein
          : maxProtein // ignore: cast_nullable_to_non_nullable
              as double,
      minCarbs: null == minCarbs
          ? _value.minCarbs
          : minCarbs // ignore: cast_nullable_to_non_nullable
              as double,
      maxCarbs: null == maxCarbs
          ? _value.maxCarbs
          : maxCarbs // ignore: cast_nullable_to_non_nullable
              as double,
      minFats: null == minFats
          ? _value.minFats
          : minFats // ignore: cast_nullable_to_non_nullable
              as double,
      maxFats: null == maxFats
          ? _value.maxFats
          : maxFats // ignore: cast_nullable_to_non_nullable
              as double,
      kCal: null == kCal
          ? _value.kCal
          : kCal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TargetsImplCopyWith<$Res> implements $TargetsCopyWith<$Res> {
  factory _$$TargetsImplCopyWith(_$TargetsImpl value, $Res Function(_$TargetsImpl) then) =
      __$$TargetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double minProtein,
      double maxProtein,
      double minCarbs,
      double maxCarbs,
      double minFats,
      double maxFats,
      double kCal});
}

/// @nodoc
class __$$TargetsImplCopyWithImpl<$Res> extends _$TargetsCopyWithImpl<$Res, _$TargetsImpl>
    implements _$$TargetsImplCopyWith<$Res> {
  __$$TargetsImplCopyWithImpl(_$TargetsImpl _value, $Res Function(_$TargetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minProtein = null,
    Object? maxProtein = null,
    Object? minCarbs = null,
    Object? maxCarbs = null,
    Object? minFats = null,
    Object? maxFats = null,
    Object? kCal = null,
  }) {
    return _then(_$TargetsImpl(
      minProtein: null == minProtein
          ? _value.minProtein
          : minProtein // ignore: cast_nullable_to_non_nullable
              as double,
      maxProtein: null == maxProtein
          ? _value.maxProtein
          : maxProtein // ignore: cast_nullable_to_non_nullable
              as double,
      minCarbs: null == minCarbs
          ? _value.minCarbs
          : minCarbs // ignore: cast_nullable_to_non_nullable
              as double,
      maxCarbs: null == maxCarbs
          ? _value.maxCarbs
          : maxCarbs // ignore: cast_nullable_to_non_nullable
              as double,
      minFats: null == minFats
          ? _value.minFats
          : minFats // ignore: cast_nullable_to_non_nullable
              as double,
      maxFats: null == maxFats
          ? _value.maxFats
          : maxFats // ignore: cast_nullable_to_non_nullable
              as double,
      kCal: null == kCal
          ? _value.kCal
          : kCal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TargetsImpl with DiagnosticableTreeMixin implements _Targets {
  const _$TargetsImpl(
      {required this.minProtein,
      required this.maxProtein,
      required this.minCarbs,
      required this.maxCarbs,
      required this.minFats,
      required this.maxFats,
      required this.kCal});

  factory _$TargetsImpl.fromJson(Map<String, dynamic> json) => _$$TargetsImplFromJson(json);

  @override
  final double minProtein;
  @override
  final double maxProtein;
  @override
  final double minCarbs;
  @override
  final double maxCarbs;
  @override
  final double minFats;
  @override
  final double maxFats;
  @override
  final double kCal;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Targets(minProtein: $minProtein, maxProtein: $maxProtein, minCarbs: $minCarbs, maxCarbs: $maxCarbs, minFats: $minFats, maxFats: $maxFats, kCal: $kCal)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Targets'))
      ..add(DiagnosticsProperty('minProtein', minProtein))
      ..add(DiagnosticsProperty('maxProtein', maxProtein))
      ..add(DiagnosticsProperty('minCarbs', minCarbs))
      ..add(DiagnosticsProperty('maxCarbs', maxCarbs))
      ..add(DiagnosticsProperty('minFats', minFats))
      ..add(DiagnosticsProperty('maxFats', maxFats))
      ..add(DiagnosticsProperty('kCal', kCal));
  }

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TargetsImplCopyWith<_$TargetsImpl> get copyWith =>
      __$$TargetsImplCopyWithImpl<_$TargetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TargetsImplToJson(
      this,
    );
  }
}

abstract class _Targets implements Targets {
  const factory _Targets(
      {required final double minProtein,
      required final double maxProtein,
      required final double minCarbs,
      required final double maxCarbs,
      required final double minFats,
      required final double maxFats,
      required final double kCal}) = _$TargetsImpl;

  factory _Targets.fromJson(Map<String, dynamic> json) = _$TargetsImpl.fromJson;

  @override
  double get minProtein;
  @override
  double get maxProtein;
  @override
  double get minCarbs;
  @override
  double get maxCarbs;
  @override
  double get minFats;
  @override
  double get maxFats;
  @override
  double get kCal;

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TargetsImplCopyWith<_$TargetsImpl> get copyWith => throw _privateConstructorUsedError;
}
