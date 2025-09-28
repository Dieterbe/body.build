// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealPlan implements DiagnosticableTreeMixin {

 String get name; List<DayPlan> get dayplans;// to support the wizard.
 CalorieCyclingType get calorieCycling; int get mealsPerDay; int get trainingDaysPerWeek;
/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealPlanCopyWith<MealPlan> get copyWith => _$MealPlanCopyWithImpl<MealPlan>(this as MealPlan, _$identity);

  /// Serializes this MealPlan to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MealPlan'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('dayplans', dayplans))..add(DiagnosticsProperty('calorieCycling', calorieCycling))..add(DiagnosticsProperty('mealsPerDay', mealsPerDay))..add(DiagnosticsProperty('trainingDaysPerWeek', trainingDaysPerWeek));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MealPlan(name: $name, dayplans: $dayplans, calorieCycling: $calorieCycling, mealsPerDay: $mealsPerDay, trainingDaysPerWeek: $trainingDaysPerWeek)';
}


}

/// @nodoc
abstract mixin class $MealPlanCopyWith<$Res>  {
  factory $MealPlanCopyWith(MealPlan value, $Res Function(MealPlan) _then) = _$MealPlanCopyWithImpl;
@useResult
$Res call({
 String name, List<DayPlan> dayplans, CalorieCyclingType calorieCycling, int mealsPerDay, int trainingDaysPerWeek
});




}
/// @nodoc
class _$MealPlanCopyWithImpl<$Res>
    implements $MealPlanCopyWith<$Res> {
  _$MealPlanCopyWithImpl(this._self, this._then);

  final MealPlan _self;
  final $Res Function(MealPlan) _then;

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? dayplans = null,Object? calorieCycling = null,Object? mealsPerDay = null,Object? trainingDaysPerWeek = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dayplans: null == dayplans ? _self.dayplans : dayplans // ignore: cast_nullable_to_non_nullable
as List<DayPlan>,calorieCycling: null == calorieCycling ? _self.calorieCycling : calorieCycling // ignore: cast_nullable_to_non_nullable
as CalorieCyclingType,mealsPerDay: null == mealsPerDay ? _self.mealsPerDay : mealsPerDay // ignore: cast_nullable_to_non_nullable
as int,trainingDaysPerWeek: null == trainingDaysPerWeek ? _self.trainingDaysPerWeek : trainingDaysPerWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MealPlan].
extension MealPlanPatterns on MealPlan {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealPlan value)  $default,){
final _that = this;
switch (_that) {
case _MealPlan():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealPlan value)?  $default,){
final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<DayPlan> dayplans,  CalorieCyclingType calorieCycling,  int mealsPerDay,  int trainingDaysPerWeek)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
return $default(_that.name,_that.dayplans,_that.calorieCycling,_that.mealsPerDay,_that.trainingDaysPerWeek);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<DayPlan> dayplans,  CalorieCyclingType calorieCycling,  int mealsPerDay,  int trainingDaysPerWeek)  $default,) {final _that = this;
switch (_that) {
case _MealPlan():
return $default(_that.name,_that.dayplans,_that.calorieCycling,_that.mealsPerDay,_that.trainingDaysPerWeek);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<DayPlan> dayplans,  CalorieCyclingType calorieCycling,  int mealsPerDay,  int trainingDaysPerWeek)?  $default,) {final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
return $default(_that.name,_that.dayplans,_that.calorieCycling,_that.mealsPerDay,_that.trainingDaysPerWeek);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealPlan with DiagnosticableTreeMixin implements MealPlan {
  const _MealPlan({required this.name, final  List<DayPlan> dayplans = const <DayPlan>[], this.calorieCycling = CalorieCyclingType.off, this.mealsPerDay = 4, this.trainingDaysPerWeek = 3}): _dayplans = dayplans;
  factory _MealPlan.fromJson(Map<String, dynamic> json) => _$MealPlanFromJson(json);

@override final  String name;
 final  List<DayPlan> _dayplans;
@override@JsonKey() List<DayPlan> get dayplans {
  if (_dayplans is EqualUnmodifiableListView) return _dayplans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dayplans);
}

// to support the wizard.
@override@JsonKey() final  CalorieCyclingType calorieCycling;
@override@JsonKey() final  int mealsPerDay;
@override@JsonKey() final  int trainingDaysPerWeek;

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealPlanCopyWith<_MealPlan> get copyWith => __$MealPlanCopyWithImpl<_MealPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealPlanToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MealPlan'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('dayplans', dayplans))..add(DiagnosticsProperty('calorieCycling', calorieCycling))..add(DiagnosticsProperty('mealsPerDay', mealsPerDay))..add(DiagnosticsProperty('trainingDaysPerWeek', trainingDaysPerWeek));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MealPlan(name: $name, dayplans: $dayplans, calorieCycling: $calorieCycling, mealsPerDay: $mealsPerDay, trainingDaysPerWeek: $trainingDaysPerWeek)';
}


}

/// @nodoc
abstract mixin class _$MealPlanCopyWith<$Res> implements $MealPlanCopyWith<$Res> {
  factory _$MealPlanCopyWith(_MealPlan value, $Res Function(_MealPlan) _then) = __$MealPlanCopyWithImpl;
@override @useResult
$Res call({
 String name, List<DayPlan> dayplans, CalorieCyclingType calorieCycling, int mealsPerDay, int trainingDaysPerWeek
});




}
/// @nodoc
class __$MealPlanCopyWithImpl<$Res>
    implements _$MealPlanCopyWith<$Res> {
  __$MealPlanCopyWithImpl(this._self, this._then);

  final _MealPlan _self;
  final $Res Function(_MealPlan) _then;

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? dayplans = null,Object? calorieCycling = null,Object? mealsPerDay = null,Object? trainingDaysPerWeek = null,}) {
  return _then(_MealPlan(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dayplans: null == dayplans ? _self._dayplans : dayplans // ignore: cast_nullable_to_non_nullable
as List<DayPlan>,calorieCycling: null == calorieCycling ? _self.calorieCycling : calorieCycling // ignore: cast_nullable_to_non_nullable
as CalorieCyclingType,mealsPerDay: null == mealsPerDay ? _self.mealsPerDay : mealsPerDay // ignore: cast_nullable_to_non_nullable
as int,trainingDaysPerWeek: null == trainingDaysPerWeek ? _self.trainingDaysPerWeek : trainingDaysPerWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DayPlan implements DiagnosticableTreeMixin {

 String get desc; Targets get targets; List<Event> get events;// how many times this day is done within one plan (the plan duration is the sum of the num of all its days)
 int get num;
/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayPlanCopyWith<DayPlan> get copyWith => _$DayPlanCopyWithImpl<DayPlan>(this as DayPlan, _$identity);

  /// Serializes this DayPlan to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DayPlan'))
    ..add(DiagnosticsProperty('desc', desc))..add(DiagnosticsProperty('targets', targets))..add(DiagnosticsProperty('events', events))..add(DiagnosticsProperty('num', num));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DayPlan(desc: $desc, targets: $targets, events: $events, num: $num)';
}


}

/// @nodoc
abstract mixin class $DayPlanCopyWith<$Res>  {
  factory $DayPlanCopyWith(DayPlan value, $Res Function(DayPlan) _then) = _$DayPlanCopyWithImpl;
@useResult
$Res call({
 String desc, Targets targets, List<Event> events, int num
});


$TargetsCopyWith<$Res> get targets;

}
/// @nodoc
class _$DayPlanCopyWithImpl<$Res>
    implements $DayPlanCopyWith<$Res> {
  _$DayPlanCopyWithImpl(this._self, this._then);

  final DayPlan _self;
  final $Res Function(DayPlan) _then;

/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? desc = null,Object? targets = null,Object? events = null,Object? num = null,}) {
  return _then(_self.copyWith(
desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,targets: null == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as Targets,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,num: null == num ? _self.num : num // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TargetsCopyWith<$Res> get targets {
  
  return $TargetsCopyWith<$Res>(_self.targets, (value) {
    return _then(_self.copyWith(targets: value));
  });
}
}


/// Adds pattern-matching-related methods to [DayPlan].
extension DayPlanPatterns on DayPlan {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayPlan() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayPlan value)  $default,){
final _that = this;
switch (_that) {
case _DayPlan():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayPlan value)?  $default,){
final _that = this;
switch (_that) {
case _DayPlan() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String desc,  Targets targets,  List<Event> events,  int num)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayPlan() when $default != null:
return $default(_that.desc,_that.targets,_that.events,_that.num);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String desc,  Targets targets,  List<Event> events,  int num)  $default,) {final _that = this;
switch (_that) {
case _DayPlan():
return $default(_that.desc,_that.targets,_that.events,_that.num);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String desc,  Targets targets,  List<Event> events,  int num)?  $default,) {final _that = this;
switch (_that) {
case _DayPlan() when $default != null:
return $default(_that.desc,_that.targets,_that.events,_that.num);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayPlan with DiagnosticableTreeMixin implements DayPlan {
  const _DayPlan({required this.desc, required this.targets, required final  List<Event> events, this.num = 1}): _events = events;
  factory _DayPlan.fromJson(Map<String, dynamic> json) => _$DayPlanFromJson(json);

@override final  String desc;
@override final  Targets targets;
 final  List<Event> _events;
@override List<Event> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

// how many times this day is done within one plan (the plan duration is the sum of the num of all its days)
@override@JsonKey() final  int num;

/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayPlanCopyWith<_DayPlan> get copyWith => __$DayPlanCopyWithImpl<_DayPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayPlanToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DayPlan'))
    ..add(DiagnosticsProperty('desc', desc))..add(DiagnosticsProperty('targets', targets))..add(DiagnosticsProperty('events', events))..add(DiagnosticsProperty('num', num));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DayPlan(desc: $desc, targets: $targets, events: $events, num: $num)';
}


}

/// @nodoc
abstract mixin class _$DayPlanCopyWith<$Res> implements $DayPlanCopyWith<$Res> {
  factory _$DayPlanCopyWith(_DayPlan value, $Res Function(_DayPlan) _then) = __$DayPlanCopyWithImpl;
@override @useResult
$Res call({
 String desc, Targets targets, List<Event> events, int num
});


@override $TargetsCopyWith<$Res> get targets;

}
/// @nodoc
class __$DayPlanCopyWithImpl<$Res>
    implements _$DayPlanCopyWith<$Res> {
  __$DayPlanCopyWithImpl(this._self, this._then);

  final _DayPlan _self;
  final $Res Function(_DayPlan) _then;

/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? desc = null,Object? targets = null,Object? events = null,Object? num = null,}) {
  return _then(_DayPlan(
desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,targets: null == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as Targets,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,num: null == num ? _self.num : num // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TargetsCopyWith<$Res> get targets {
  
  return $TargetsCopyWith<$Res>(_self.targets, (value) {
    return _then(_self.copyWith(targets: value));
  });
}
}

Event _$EventFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'meal':
          return MealEvent.fromJson(
            json
          );
                case 'strengthWorkout':
          return StrengthWorkoutEvent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'Event',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$Event implements DiagnosticableTreeMixin {

 String get desc;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Event'))
    ..add(DiagnosticsProperty('desc', desc));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Event(desc: $desc)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String desc
});




}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? desc = null,}) {
  return _then(_self.copyWith(
desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MealEvent value)?  meal,TResult Function( StrengthWorkoutEvent value)?  strengthWorkout,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MealEvent() when meal != null:
return meal(_that);case StrengthWorkoutEvent() when strengthWorkout != null:
return strengthWorkout(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MealEvent value)  meal,required TResult Function( StrengthWorkoutEvent value)  strengthWorkout,}){
final _that = this;
switch (_that) {
case MealEvent():
return meal(_that);case StrengthWorkoutEvent():
return strengthWorkout(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MealEvent value)?  meal,TResult? Function( StrengthWorkoutEvent value)?  strengthWorkout,}){
final _that = this;
switch (_that) {
case MealEvent() when meal != null:
return meal(_that);case StrengthWorkoutEvent() when strengthWorkout != null:
return strengthWorkout(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String desc,  Targets targets)?  meal,TResult Function( String desc,  double estimatedKcal)?  strengthWorkout,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MealEvent() when meal != null:
return meal(_that.desc,_that.targets);case StrengthWorkoutEvent() when strengthWorkout != null:
return strengthWorkout(_that.desc,_that.estimatedKcal);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String desc,  Targets targets)  meal,required TResult Function( String desc,  double estimatedKcal)  strengthWorkout,}) {final _that = this;
switch (_that) {
case MealEvent():
return meal(_that.desc,_that.targets);case StrengthWorkoutEvent():
return strengthWorkout(_that.desc,_that.estimatedKcal);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String desc,  Targets targets)?  meal,TResult? Function( String desc,  double estimatedKcal)?  strengthWorkout,}) {final _that = this;
switch (_that) {
case MealEvent() when meal != null:
return meal(_that.desc,_that.targets);case StrengthWorkoutEvent() when strengthWorkout != null:
return strengthWorkout(_that.desc,_that.estimatedKcal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class MealEvent with DiagnosticableTreeMixin implements Event {
  const MealEvent({required this.desc, required this.targets, final  String? $type}): $type = $type ?? 'meal';
  factory MealEvent.fromJson(Map<String, dynamic> json) => _$MealEventFromJson(json);

@override final  String desc;
 final  Targets targets;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEventCopyWith<MealEvent> get copyWith => _$MealEventCopyWithImpl<MealEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealEventToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Event.meal'))
    ..add(DiagnosticsProperty('desc', desc))..add(DiagnosticsProperty('targets', targets));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Event.meal(desc: $desc, targets: $targets)';
}


}

/// @nodoc
abstract mixin class $MealEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $MealEventCopyWith(MealEvent value, $Res Function(MealEvent) _then) = _$MealEventCopyWithImpl;
@override @useResult
$Res call({
 String desc, Targets targets
});


$TargetsCopyWith<$Res> get targets;

}
/// @nodoc
class _$MealEventCopyWithImpl<$Res>
    implements $MealEventCopyWith<$Res> {
  _$MealEventCopyWithImpl(this._self, this._then);

  final MealEvent _self;
  final $Res Function(MealEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? desc = null,Object? targets = null,}) {
  return _then(MealEvent(
desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,targets: null == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as Targets,
  ));
}

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TargetsCopyWith<$Res> get targets {
  
  return $TargetsCopyWith<$Res>(_self.targets, (value) {
    return _then(_self.copyWith(targets: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class StrengthWorkoutEvent with DiagnosticableTreeMixin implements Event {
  const StrengthWorkoutEvent({required this.desc, required this.estimatedKcal, final  String? $type}): $type = $type ?? 'strengthWorkout';
  factory StrengthWorkoutEvent.fromJson(Map<String, dynamic> json) => _$StrengthWorkoutEventFromJson(json);

@override final  String desc;
 final  double estimatedKcal;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StrengthWorkoutEventCopyWith<StrengthWorkoutEvent> get copyWith => _$StrengthWorkoutEventCopyWithImpl<StrengthWorkoutEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StrengthWorkoutEventToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Event.strengthWorkout'))
    ..add(DiagnosticsProperty('desc', desc))..add(DiagnosticsProperty('estimatedKcal', estimatedKcal));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Event.strengthWorkout(desc: $desc, estimatedKcal: $estimatedKcal)';
}


}

/// @nodoc
abstract mixin class $StrengthWorkoutEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $StrengthWorkoutEventCopyWith(StrengthWorkoutEvent value, $Res Function(StrengthWorkoutEvent) _then) = _$StrengthWorkoutEventCopyWithImpl;
@override @useResult
$Res call({
 String desc, double estimatedKcal
});




}
/// @nodoc
class _$StrengthWorkoutEventCopyWithImpl<$Res>
    implements $StrengthWorkoutEventCopyWith<$Res> {
  _$StrengthWorkoutEventCopyWithImpl(this._self, this._then);

  final StrengthWorkoutEvent _self;
  final $Res Function(StrengthWorkoutEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? desc = null,Object? estimatedKcal = null,}) {
  return _then(StrengthWorkoutEvent(
desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,estimatedKcal: null == estimatedKcal ? _self.estimatedKcal : estimatedKcal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Targets implements DiagnosticableTreeMixin {

 double get minProtein; double get maxProtein; double get minCarbs; double get maxCarbs; double get minFats; double get maxFats; double get kCal;
/// Create a copy of Targets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TargetsCopyWith<Targets> get copyWith => _$TargetsCopyWithImpl<Targets>(this as Targets, _$identity);

  /// Serializes this Targets to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Targets'))
    ..add(DiagnosticsProperty('minProtein', minProtein))..add(DiagnosticsProperty('maxProtein', maxProtein))..add(DiagnosticsProperty('minCarbs', minCarbs))..add(DiagnosticsProperty('maxCarbs', maxCarbs))..add(DiagnosticsProperty('minFats', minFats))..add(DiagnosticsProperty('maxFats', maxFats))..add(DiagnosticsProperty('kCal', kCal));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Targets(minProtein: $minProtein, maxProtein: $maxProtein, minCarbs: $minCarbs, maxCarbs: $maxCarbs, minFats: $minFats, maxFats: $maxFats, kCal: $kCal)';
}


}

/// @nodoc
abstract mixin class $TargetsCopyWith<$Res>  {
  factory $TargetsCopyWith(Targets value, $Res Function(Targets) _then) = _$TargetsCopyWithImpl;
@useResult
$Res call({
 double minProtein, double maxProtein, double minCarbs, double maxCarbs, double minFats, double maxFats, double kCal
});




}
/// @nodoc
class _$TargetsCopyWithImpl<$Res>
    implements $TargetsCopyWith<$Res> {
  _$TargetsCopyWithImpl(this._self, this._then);

  final Targets _self;
  final $Res Function(Targets) _then;

/// Create a copy of Targets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minProtein = null,Object? maxProtein = null,Object? minCarbs = null,Object? maxCarbs = null,Object? minFats = null,Object? maxFats = null,Object? kCal = null,}) {
  return _then(_self.copyWith(
minProtein: null == minProtein ? _self.minProtein : minProtein // ignore: cast_nullable_to_non_nullable
as double,maxProtein: null == maxProtein ? _self.maxProtein : maxProtein // ignore: cast_nullable_to_non_nullable
as double,minCarbs: null == minCarbs ? _self.minCarbs : minCarbs // ignore: cast_nullable_to_non_nullable
as double,maxCarbs: null == maxCarbs ? _self.maxCarbs : maxCarbs // ignore: cast_nullable_to_non_nullable
as double,minFats: null == minFats ? _self.minFats : minFats // ignore: cast_nullable_to_non_nullable
as double,maxFats: null == maxFats ? _self.maxFats : maxFats // ignore: cast_nullable_to_non_nullable
as double,kCal: null == kCal ? _self.kCal : kCal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Targets].
extension TargetsPatterns on Targets {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Targets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Targets() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Targets value)  $default,){
final _that = this;
switch (_that) {
case _Targets():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Targets value)?  $default,){
final _that = this;
switch (_that) {
case _Targets() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double minProtein,  double maxProtein,  double minCarbs,  double maxCarbs,  double minFats,  double maxFats,  double kCal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Targets() when $default != null:
return $default(_that.minProtein,_that.maxProtein,_that.minCarbs,_that.maxCarbs,_that.minFats,_that.maxFats,_that.kCal);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double minProtein,  double maxProtein,  double minCarbs,  double maxCarbs,  double minFats,  double maxFats,  double kCal)  $default,) {final _that = this;
switch (_that) {
case _Targets():
return $default(_that.minProtein,_that.maxProtein,_that.minCarbs,_that.maxCarbs,_that.minFats,_that.maxFats,_that.kCal);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double minProtein,  double maxProtein,  double minCarbs,  double maxCarbs,  double minFats,  double maxFats,  double kCal)?  $default,) {final _that = this;
switch (_that) {
case _Targets() when $default != null:
return $default(_that.minProtein,_that.maxProtein,_that.minCarbs,_that.maxCarbs,_that.minFats,_that.maxFats,_that.kCal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Targets with DiagnosticableTreeMixin implements Targets {
  const _Targets({required this.minProtein, required this.maxProtein, required this.minCarbs, required this.maxCarbs, required this.minFats, required this.maxFats, required this.kCal});
  factory _Targets.fromJson(Map<String, dynamic> json) => _$TargetsFromJson(json);

@override final  double minProtein;
@override final  double maxProtein;
@override final  double minCarbs;
@override final  double maxCarbs;
@override final  double minFats;
@override final  double maxFats;
@override final  double kCal;

/// Create a copy of Targets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TargetsCopyWith<_Targets> get copyWith => __$TargetsCopyWithImpl<_Targets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TargetsToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Targets'))
    ..add(DiagnosticsProperty('minProtein', minProtein))..add(DiagnosticsProperty('maxProtein', maxProtein))..add(DiagnosticsProperty('minCarbs', minCarbs))..add(DiagnosticsProperty('maxCarbs', maxCarbs))..add(DiagnosticsProperty('minFats', minFats))..add(DiagnosticsProperty('maxFats', maxFats))..add(DiagnosticsProperty('kCal', kCal));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Targets(minProtein: $minProtein, maxProtein: $maxProtein, minCarbs: $minCarbs, maxCarbs: $maxCarbs, minFats: $minFats, maxFats: $maxFats, kCal: $kCal)';
}


}

/// @nodoc
abstract mixin class _$TargetsCopyWith<$Res> implements $TargetsCopyWith<$Res> {
  factory _$TargetsCopyWith(_Targets value, $Res Function(_Targets) _then) = __$TargetsCopyWithImpl;
@override @useResult
$Res call({
 double minProtein, double maxProtein, double minCarbs, double maxCarbs, double minFats, double maxFats, double kCal
});




}
/// @nodoc
class __$TargetsCopyWithImpl<$Res>
    implements _$TargetsCopyWith<$Res> {
  __$TargetsCopyWithImpl(this._self, this._then);

  final _Targets _self;
  final $Res Function(_Targets) _then;

/// Create a copy of Targets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minProtein = null,Object? maxProtein = null,Object? minCarbs = null,Object? maxCarbs = null,Object? minFats = null,Object? maxFats = null,Object? kCal = null,}) {
  return _then(_Targets(
minProtein: null == minProtein ? _self.minProtein : minProtein // ignore: cast_nullable_to_non_nullable
as double,maxProtein: null == maxProtein ? _self.maxProtein : maxProtein // ignore: cast_nullable_to_non_nullable
as double,minCarbs: null == minCarbs ? _self.minCarbs : minCarbs // ignore: cast_nullable_to_non_nullable
as double,maxCarbs: null == maxCarbs ? _self.maxCarbs : maxCarbs // ignore: cast_nullable_to_non_nullable
as double,minFats: null == minFats ? _self.minFats : minFats // ignore: cast_nullable_to_non_nullable
as double,maxFats: null == maxFats ? _self.maxFats : maxFats // ignore: cast_nullable_to_non_nullable
as double,kCal: null == kCal ? _self.kCal : kCal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
