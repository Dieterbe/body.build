// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Workout {

 String get id; DateTime get startTime; DateTime? get endTime;// NULL for active workouts
 String? get notes; DateTime get createdAt; DateTime get updatedAt; List<WorkoutSet> get sets;
/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutCopyWith<Workout> get copyWith => _$WorkoutCopyWithImpl<Workout>(this as Workout, _$identity);

  /// Serializes this Workout to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Workout(id: $id, startTime: $startTime, endTime: $endTime, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, sets: $sets)';
}


}

/// @nodoc
abstract mixin class $WorkoutCopyWith<$Res>  {
  factory $WorkoutCopyWith(Workout value, $Res Function(Workout) _then) = _$WorkoutCopyWithImpl;
@useResult
$Res call({
 String id, DateTime startTime, DateTime? endTime, String? notes, DateTime createdAt, DateTime updatedAt, List<WorkoutSet> sets
});




}
/// @nodoc
class _$WorkoutCopyWithImpl<$Res>
    implements $WorkoutCopyWith<$Res> {
  _$WorkoutCopyWithImpl(this._self, this._then);

  final Workout _self;
  final $Res Function(Workout) _then;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startTime = null,Object? endTime = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,Object? sets = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,
  ));
}

}


/// Adds pattern-matching-related methods to [Workout].
extension WorkoutPatterns on Workout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Workout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Workout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Workout value)  $default,){
final _that = this;
switch (_that) {
case _Workout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Workout value)?  $default,){
final _that = this;
switch (_that) {
case _Workout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime startTime,  DateTime? endTime,  String? notes,  DateTime createdAt,  DateTime updatedAt,  List<WorkoutSet> sets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Workout() when $default != null:
return $default(_that.id,_that.startTime,_that.endTime,_that.notes,_that.createdAt,_that.updatedAt,_that.sets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime startTime,  DateTime? endTime,  String? notes,  DateTime createdAt,  DateTime updatedAt,  List<WorkoutSet> sets)  $default,) {final _that = this;
switch (_that) {
case _Workout():
return $default(_that.id,_that.startTime,_that.endTime,_that.notes,_that.createdAt,_that.updatedAt,_that.sets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime startTime,  DateTime? endTime,  String? notes,  DateTime createdAt,  DateTime updatedAt,  List<WorkoutSet> sets)?  $default,) {final _that = this;
switch (_that) {
case _Workout() when $default != null:
return $default(_that.id,_that.startTime,_that.endTime,_that.notes,_that.createdAt,_that.updatedAt,_that.sets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Workout extends Workout {
  const _Workout({required this.id, required this.startTime, this.endTime, this.notes, required this.createdAt, required this.updatedAt, final  List<WorkoutSet> sets = const []}): _sets = sets,super._();
  factory _Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);

@override final  String id;
@override final  DateTime startTime;
@override final  DateTime? endTime;
// NULL for active workouts
@override final  String? notes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<WorkoutSet> _sets;
@override@JsonKey() List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}


/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutCopyWith<_Workout> get copyWith => __$WorkoutCopyWithImpl<_Workout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutToJson(this, );
}



@override
String toString() {
  return 'Workout(id: $id, startTime: $startTime, endTime: $endTime, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, sets: $sets)';
}


}

/// @nodoc
abstract mixin class _$WorkoutCopyWith<$Res> implements $WorkoutCopyWith<$Res> {
  factory _$WorkoutCopyWith(_Workout value, $Res Function(_Workout) _then) = __$WorkoutCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime startTime, DateTime? endTime, String? notes, DateTime createdAt, DateTime updatedAt, List<WorkoutSet> sets
});




}
/// @nodoc
class __$WorkoutCopyWithImpl<$Res>
    implements _$WorkoutCopyWith<$Res> {
  __$WorkoutCopyWithImpl(this._self, this._then);

  final _Workout _self;
  final $Res Function(_Workout) _then;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startTime = null,Object? endTime = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,Object? sets = null,}) {
  return _then(_Workout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,
  ));
}


}


/// @nodoc
mixin _$WorkoutSet {

 String get id; String get workoutId; String get exerciseId; Map<String, String> get modifiers; Map<String, bool> get cues; double? get weight; int? get reps; int? get rir;// Reps in Reserve
 String? get comments; DateTime get timestamp; int get setOrder;
/// Create a copy of WorkoutSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSetCopyWith<WorkoutSet> get copyWith => _$WorkoutSetCopyWithImpl<WorkoutSet>(this as WorkoutSet, _$identity);

  /// Serializes this WorkoutSet to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'WorkoutSet(id: $id, workoutId: $workoutId, exerciseId: $exerciseId, modifiers: $modifiers, cues: $cues, weight: $weight, reps: $reps, rir: $rir, comments: $comments, timestamp: $timestamp, setOrder: $setOrder)';
}


}

/// @nodoc
abstract mixin class $WorkoutSetCopyWith<$Res>  {
  factory $WorkoutSetCopyWith(WorkoutSet value, $Res Function(WorkoutSet) _then) = _$WorkoutSetCopyWithImpl;
@useResult
$Res call({
 String id, String workoutId, String exerciseId, Map<String, String> modifiers, Map<String, bool> cues, double? weight, int? reps, int? rir, String? comments, DateTime timestamp, int setOrder
});




}
/// @nodoc
class _$WorkoutSetCopyWithImpl<$Res>
    implements $WorkoutSetCopyWith<$Res> {
  _$WorkoutSetCopyWithImpl(this._self, this._then);

  final WorkoutSet _self;
  final $Res Function(WorkoutSet) _then;

/// Create a copy of WorkoutSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workoutId = null,Object? exerciseId = null,Object? modifiers = null,Object? cues = null,Object? weight = freezed,Object? reps = freezed,Object? rir = freezed,Object? comments = freezed,Object? timestamp = null,Object? setOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workoutId: null == workoutId ? _self.workoutId : workoutId // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,cues: null == cues ? _self.cues : cues // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,rir: freezed == rir ? _self.rir : rir // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,setOrder: null == setOrder ? _self.setOrder : setOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutSet].
extension WorkoutSetPatterns on WorkoutSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutSet value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutSet value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workoutId,  String exerciseId,  Map<String, String> modifiers,  Map<String, bool> cues,  double? weight,  int? reps,  int? rir,  String? comments,  DateTime timestamp,  int setOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutSet() when $default != null:
return $default(_that.id,_that.workoutId,_that.exerciseId,_that.modifiers,_that.cues,_that.weight,_that.reps,_that.rir,_that.comments,_that.timestamp,_that.setOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workoutId,  String exerciseId,  Map<String, String> modifiers,  Map<String, bool> cues,  double? weight,  int? reps,  int? rir,  String? comments,  DateTime timestamp,  int setOrder)  $default,) {final _that = this;
switch (_that) {
case _WorkoutSet():
return $default(_that.id,_that.workoutId,_that.exerciseId,_that.modifiers,_that.cues,_that.weight,_that.reps,_that.rir,_that.comments,_that.timestamp,_that.setOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workoutId,  String exerciseId,  Map<String, String> modifiers,  Map<String, bool> cues,  double? weight,  int? reps,  int? rir,  String? comments,  DateTime timestamp,  int setOrder)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutSet() when $default != null:
return $default(_that.id,_that.workoutId,_that.exerciseId,_that.modifiers,_that.cues,_that.weight,_that.reps,_that.rir,_that.comments,_that.timestamp,_that.setOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutSet extends WorkoutSet {
  const _WorkoutSet({required this.id, required this.workoutId, required this.exerciseId, final  Map<String, String> modifiers = const {}, final  Map<String, bool> cues = const {}, this.weight, this.reps, this.rir, this.comments, required this.timestamp, required this.setOrder}): _modifiers = modifiers,_cues = cues,super._();
  factory _WorkoutSet.fromJson(Map<String, dynamic> json) => _$WorkoutSetFromJson(json);

@override final  String id;
@override final  String workoutId;
@override final  String exerciseId;
 final  Map<String, String> _modifiers;
@override@JsonKey() Map<String, String> get modifiers {
  if (_modifiers is EqualUnmodifiableMapView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_modifiers);
}

 final  Map<String, bool> _cues;
@override@JsonKey() Map<String, bool> get cues {
  if (_cues is EqualUnmodifiableMapView) return _cues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cues);
}

@override final  double? weight;
@override final  int? reps;
@override final  int? rir;
// Reps in Reserve
@override final  String? comments;
@override final  DateTime timestamp;
@override final  int setOrder;

/// Create a copy of WorkoutSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutSetCopyWith<_WorkoutSet> get copyWith => __$WorkoutSetCopyWithImpl<_WorkoutSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutSetToJson(this, );
}



@override
String toString() {
  return 'WorkoutSet(id: $id, workoutId: $workoutId, exerciseId: $exerciseId, modifiers: $modifiers, cues: $cues, weight: $weight, reps: $reps, rir: $rir, comments: $comments, timestamp: $timestamp, setOrder: $setOrder)';
}


}

/// @nodoc
abstract mixin class _$WorkoutSetCopyWith<$Res> implements $WorkoutSetCopyWith<$Res> {
  factory _$WorkoutSetCopyWith(_WorkoutSet value, $Res Function(_WorkoutSet) _then) = __$WorkoutSetCopyWithImpl;
@override @useResult
$Res call({
 String id, String workoutId, String exerciseId, Map<String, String> modifiers, Map<String, bool> cues, double? weight, int? reps, int? rir, String? comments, DateTime timestamp, int setOrder
});




}
/// @nodoc
class __$WorkoutSetCopyWithImpl<$Res>
    implements _$WorkoutSetCopyWith<$Res> {
  __$WorkoutSetCopyWithImpl(this._self, this._then);

  final _WorkoutSet _self;
  final $Res Function(_WorkoutSet) _then;

/// Create a copy of WorkoutSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workoutId = null,Object? exerciseId = null,Object? modifiers = null,Object? cues = null,Object? weight = freezed,Object? reps = freezed,Object? rir = freezed,Object? comments = freezed,Object? timestamp = null,Object? setOrder = null,}) {
  return _then(_WorkoutSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workoutId: null == workoutId ? _self.workoutId : workoutId // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,cues: null == cues ? _self._cues : cues // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,rir: freezed == rir ? _self.rir : rir // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,setOrder: null == setOrder ? _self.setOrder : setOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WorkoutState {

 List<Workout> get allWorkouts; Workout? get activeWorkout; List<Workout> get completedWorkouts;
/// Create a copy of WorkoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutStateCopyWith<WorkoutState> get copyWith => _$WorkoutStateCopyWithImpl<WorkoutState>(this as WorkoutState, _$identity);

  /// Serializes this WorkoutState to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'WorkoutState(allWorkouts: $allWorkouts, activeWorkout: $activeWorkout, completedWorkouts: $completedWorkouts)';
}


}

/// @nodoc
abstract mixin class $WorkoutStateCopyWith<$Res>  {
  factory $WorkoutStateCopyWith(WorkoutState value, $Res Function(WorkoutState) _then) = _$WorkoutStateCopyWithImpl;
@useResult
$Res call({
 List<Workout> allWorkouts, Workout? activeWorkout, List<Workout> completedWorkouts
});


$WorkoutCopyWith<$Res>? get activeWorkout;

}
/// @nodoc
class _$WorkoutStateCopyWithImpl<$Res>
    implements $WorkoutStateCopyWith<$Res> {
  _$WorkoutStateCopyWithImpl(this._self, this._then);

  final WorkoutState _self;
  final $Res Function(WorkoutState) _then;

/// Create a copy of WorkoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allWorkouts = null,Object? activeWorkout = freezed,Object? completedWorkouts = null,}) {
  return _then(_self.copyWith(
allWorkouts: null == allWorkouts ? _self.allWorkouts : allWorkouts // ignore: cast_nullable_to_non_nullable
as List<Workout>,activeWorkout: freezed == activeWorkout ? _self.activeWorkout : activeWorkout // ignore: cast_nullable_to_non_nullable
as Workout?,completedWorkouts: null == completedWorkouts ? _self.completedWorkouts : completedWorkouts // ignore: cast_nullable_to_non_nullable
as List<Workout>,
  ));
}
/// Create a copy of WorkoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res>? get activeWorkout {
    if (_self.activeWorkout == null) {
    return null;
  }

  return $WorkoutCopyWith<$Res>(_self.activeWorkout!, (value) {
    return _then(_self.copyWith(activeWorkout: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkoutState].
extension WorkoutStatePatterns on WorkoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Workout> allWorkouts,  Workout? activeWorkout,  List<Workout> completedWorkouts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutState() when $default != null:
return $default(_that.allWorkouts,_that.activeWorkout,_that.completedWorkouts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Workout> allWorkouts,  Workout? activeWorkout,  List<Workout> completedWorkouts)  $default,) {final _that = this;
switch (_that) {
case _WorkoutState():
return $default(_that.allWorkouts,_that.activeWorkout,_that.completedWorkouts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Workout> allWorkouts,  Workout? activeWorkout,  List<Workout> completedWorkouts)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutState() when $default != null:
return $default(_that.allWorkouts,_that.activeWorkout,_that.completedWorkouts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutState extends WorkoutState {
  const _WorkoutState({required final  List<Workout> allWorkouts, this.activeWorkout, required final  List<Workout> completedWorkouts}): _allWorkouts = allWorkouts,_completedWorkouts = completedWorkouts,super._();
  factory _WorkoutState.fromJson(Map<String, dynamic> json) => _$WorkoutStateFromJson(json);

 final  List<Workout> _allWorkouts;
@override List<Workout> get allWorkouts {
  if (_allWorkouts is EqualUnmodifiableListView) return _allWorkouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allWorkouts);
}

@override final  Workout? activeWorkout;
 final  List<Workout> _completedWorkouts;
@override List<Workout> get completedWorkouts {
  if (_completedWorkouts is EqualUnmodifiableListView) return _completedWorkouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedWorkouts);
}


/// Create a copy of WorkoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutStateCopyWith<_WorkoutState> get copyWith => __$WorkoutStateCopyWithImpl<_WorkoutState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutStateToJson(this, );
}



@override
String toString() {
  return 'WorkoutState(allWorkouts: $allWorkouts, activeWorkout: $activeWorkout, completedWorkouts: $completedWorkouts)';
}


}

/// @nodoc
abstract mixin class _$WorkoutStateCopyWith<$Res> implements $WorkoutStateCopyWith<$Res> {
  factory _$WorkoutStateCopyWith(_WorkoutState value, $Res Function(_WorkoutState) _then) = __$WorkoutStateCopyWithImpl;
@override @useResult
$Res call({
 List<Workout> allWorkouts, Workout? activeWorkout, List<Workout> completedWorkouts
});


@override $WorkoutCopyWith<$Res>? get activeWorkout;

}
/// @nodoc
class __$WorkoutStateCopyWithImpl<$Res>
    implements _$WorkoutStateCopyWith<$Res> {
  __$WorkoutStateCopyWithImpl(this._self, this._then);

  final _WorkoutState _self;
  final $Res Function(_WorkoutState) _then;

/// Create a copy of WorkoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allWorkouts = null,Object? activeWorkout = freezed,Object? completedWorkouts = null,}) {
  return _then(_WorkoutState(
allWorkouts: null == allWorkouts ? _self._allWorkouts : allWorkouts // ignore: cast_nullable_to_non_nullable
as List<Workout>,activeWorkout: freezed == activeWorkout ? _self.activeWorkout : activeWorkout // ignore: cast_nullable_to_non_nullable
as Workout?,completedWorkouts: null == completedWorkouts ? _self._completedWorkouts : completedWorkouts // ignore: cast_nullable_to_non_nullable
as List<Workout>,
  ));
}

/// Create a copy of WorkoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res>? get activeWorkout {
    if (_self.activeWorkout == null) {
    return null;
  }

  return $WorkoutCopyWith<$Res>(_self.activeWorkout!, (value) {
    return _then(_self.copyWith(activeWorkout: value));
  });
}
}

// dart format on
