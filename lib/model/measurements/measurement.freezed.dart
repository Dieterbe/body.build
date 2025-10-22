// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Measurement {

 String get id; DateTime get timestamp; String get timezoneOffset; MeasurementType get measurementType; double get value; Unit get unit; String? get comment;
/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementCopyWith<Measurement> get copyWith => _$MeasurementCopyWithImpl<Measurement>(this as Measurement, _$identity);

  /// Serializes this Measurement to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Measurement(id: $id, timestamp: $timestamp, timezoneOffset: $timezoneOffset, measurementType: $measurementType, value: $value, unit: $unit, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $MeasurementCopyWith<$Res>  {
  factory $MeasurementCopyWith(Measurement value, $Res Function(Measurement) _then) = _$MeasurementCopyWithImpl;
@useResult
$Res call({
 String id, DateTime timestamp, String timezoneOffset, MeasurementType measurementType, double value, Unit unit, String? comment
});




}
/// @nodoc
class _$MeasurementCopyWithImpl<$Res>
    implements $MeasurementCopyWith<$Res> {
  _$MeasurementCopyWithImpl(this._self, this._then);

  final Measurement _self;
  final $Res Function(Measurement) _then;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? timestamp = null,Object? timezoneOffset = null,Object? measurementType = null,Object? value = null,Object? unit = null,Object? comment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,timezoneOffset: null == timezoneOffset ? _self.timezoneOffset : timezoneOffset // ignore: cast_nullable_to_non_nullable
as String,measurementType: null == measurementType ? _self.measurementType : measurementType // ignore: cast_nullable_to_non_nullable
as MeasurementType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Measurement].
extension MeasurementPatterns on Measurement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Measurement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Measurement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Measurement value)  $default,){
final _that = this;
switch (_that) {
case _Measurement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Measurement value)?  $default,){
final _that = this;
switch (_that) {
case _Measurement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime timestamp,  String timezoneOffset,  MeasurementType measurementType,  double value,  Unit unit,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Measurement() when $default != null:
return $default(_that.id,_that.timestamp,_that.timezoneOffset,_that.measurementType,_that.value,_that.unit,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime timestamp,  String timezoneOffset,  MeasurementType measurementType,  double value,  Unit unit,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _Measurement():
return $default(_that.id,_that.timestamp,_that.timezoneOffset,_that.measurementType,_that.value,_that.unit,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime timestamp,  String timezoneOffset,  MeasurementType measurementType,  double value,  Unit unit,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _Measurement() when $default != null:
return $default(_that.id,_that.timestamp,_that.timezoneOffset,_that.measurementType,_that.value,_that.unit,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Measurement implements Measurement {
  const _Measurement({required this.id, required this.timestamp, required this.timezoneOffset, required this.measurementType, required this.value, required this.unit, this.comment});
  factory _Measurement.fromJson(Map<String, dynamic> json) => _$MeasurementFromJson(json);

@override final  String id;
@override final  DateTime timestamp;
@override final  String timezoneOffset;
@override final  MeasurementType measurementType;
@override final  double value;
@override final  Unit unit;
@override final  String? comment;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementCopyWith<_Measurement> get copyWith => __$MeasurementCopyWithImpl<_Measurement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeasurementToJson(this, );
}



@override
String toString() {
  return 'Measurement(id: $id, timestamp: $timestamp, timezoneOffset: $timezoneOffset, measurementType: $measurementType, value: $value, unit: $unit, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$MeasurementCopyWith<$Res> implements $MeasurementCopyWith<$Res> {
  factory _$MeasurementCopyWith(_Measurement value, $Res Function(_Measurement) _then) = __$MeasurementCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime timestamp, String timezoneOffset, MeasurementType measurementType, double value, Unit unit, String? comment
});




}
/// @nodoc
class __$MeasurementCopyWithImpl<$Res>
    implements _$MeasurementCopyWith<$Res> {
  __$MeasurementCopyWithImpl(this._self, this._then);

  final _Measurement _self;
  final $Res Function(_Measurement) _then;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? timestamp = null,Object? timezoneOffset = null,Object? measurementType = null,Object? value = null,Object? unit = null,Object? comment = freezed,}) {
  return _then(_Measurement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,timezoneOffset: null == timezoneOffset ? _self.timezoneOffset : timezoneOffset // ignore: cast_nullable_to_non_nullable
as String,measurementType: null == measurementType ? _self.measurementType : measurementType // ignore: cast_nullable_to_non_nullable
as MeasurementType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$MovingAveragePoint {

 DateTime get timestamp; double get value;
/// Create a copy of MovingAveragePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovingAveragePointCopyWith<MovingAveragePoint> get copyWith => _$MovingAveragePointCopyWithImpl<MovingAveragePoint>(this as MovingAveragePoint, _$identity);





@override
String toString() {
  return 'MovingAveragePoint(timestamp: $timestamp, value: $value)';
}


}

/// @nodoc
abstract mixin class $MovingAveragePointCopyWith<$Res>  {
  factory $MovingAveragePointCopyWith(MovingAveragePoint value, $Res Function(MovingAveragePoint) _then) = _$MovingAveragePointCopyWithImpl;
@useResult
$Res call({
 DateTime timestamp, double value
});




}
/// @nodoc
class _$MovingAveragePointCopyWithImpl<$Res>
    implements $MovingAveragePointCopyWith<$Res> {
  _$MovingAveragePointCopyWithImpl(this._self, this._then);

  final MovingAveragePoint _self;
  final $Res Function(MovingAveragePoint) _then;

/// Create a copy of MovingAveragePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? value = null,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MovingAveragePoint].
extension MovingAveragePointPatterns on MovingAveragePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovingAveragePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovingAveragePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovingAveragePoint value)  $default,){
final _that = this;
switch (_that) {
case _MovingAveragePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovingAveragePoint value)?  $default,){
final _that = this;
switch (_that) {
case _MovingAveragePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime timestamp,  double value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovingAveragePoint() when $default != null:
return $default(_that.timestamp,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime timestamp,  double value)  $default,) {final _that = this;
switch (_that) {
case _MovingAveragePoint():
return $default(_that.timestamp,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime timestamp,  double value)?  $default,) {final _that = this;
switch (_that) {
case _MovingAveragePoint() when $default != null:
return $default(_that.timestamp,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _MovingAveragePoint implements MovingAveragePoint {
  const _MovingAveragePoint({required this.timestamp, required this.value});
  

@override final  DateTime timestamp;
@override final  double value;

/// Create a copy of MovingAveragePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovingAveragePointCopyWith<_MovingAveragePoint> get copyWith => __$MovingAveragePointCopyWithImpl<_MovingAveragePoint>(this, _$identity);





@override
String toString() {
  return 'MovingAveragePoint(timestamp: $timestamp, value: $value)';
}


}

/// @nodoc
abstract mixin class _$MovingAveragePointCopyWith<$Res> implements $MovingAveragePointCopyWith<$Res> {
  factory _$MovingAveragePointCopyWith(_MovingAveragePoint value, $Res Function(_MovingAveragePoint) _then) = __$MovingAveragePointCopyWithImpl;
@override @useResult
$Res call({
 DateTime timestamp, double value
});




}
/// @nodoc
class __$MovingAveragePointCopyWithImpl<$Res>
    implements _$MovingAveragePointCopyWith<$Res> {
  __$MovingAveragePointCopyWithImpl(this._self, this._then);

  final _MovingAveragePoint _self;
  final $Res Function(_MovingAveragePoint) _then;

/// Create a copy of MovingAveragePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? value = null,}) {
  return _then(_MovingAveragePoint(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$MeasurementData {

 List<Measurement> get measurements; List<MovingAveragePoint> get movingAverage7Day;
/// Create a copy of MeasurementData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementDataCopyWith<MeasurementData> get copyWith => _$MeasurementDataCopyWithImpl<MeasurementData>(this as MeasurementData, _$identity);





@override
String toString() {
  return 'MeasurementData(measurements: $measurements, movingAverage7Day: $movingAverage7Day)';
}


}

/// @nodoc
abstract mixin class $MeasurementDataCopyWith<$Res>  {
  factory $MeasurementDataCopyWith(MeasurementData value, $Res Function(MeasurementData) _then) = _$MeasurementDataCopyWithImpl;
@useResult
$Res call({
 List<Measurement> measurements, List<MovingAveragePoint> movingAverage7Day
});




}
/// @nodoc
class _$MeasurementDataCopyWithImpl<$Res>
    implements $MeasurementDataCopyWith<$Res> {
  _$MeasurementDataCopyWithImpl(this._self, this._then);

  final MeasurementData _self;
  final $Res Function(MeasurementData) _then;

/// Create a copy of MeasurementData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? measurements = null,Object? movingAverage7Day = null,}) {
  return _then(_self.copyWith(
measurements: null == measurements ? _self.measurements : measurements // ignore: cast_nullable_to_non_nullable
as List<Measurement>,movingAverage7Day: null == movingAverage7Day ? _self.movingAverage7Day : movingAverage7Day // ignore: cast_nullable_to_non_nullable
as List<MovingAveragePoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasurementData].
extension MeasurementDataPatterns on MeasurementData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurementData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurementData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurementData value)  $default,){
final _that = this;
switch (_that) {
case _MeasurementData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurementData value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurementData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Measurement> measurements,  List<MovingAveragePoint> movingAverage7Day)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurementData() when $default != null:
return $default(_that.measurements,_that.movingAverage7Day);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Measurement> measurements,  List<MovingAveragePoint> movingAverage7Day)  $default,) {final _that = this;
switch (_that) {
case _MeasurementData():
return $default(_that.measurements,_that.movingAverage7Day);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Measurement> measurements,  List<MovingAveragePoint> movingAverage7Day)?  $default,) {final _that = this;
switch (_that) {
case _MeasurementData() when $default != null:
return $default(_that.measurements,_that.movingAverage7Day);case _:
  return null;

}
}

}

/// @nodoc


class _MeasurementData implements MeasurementData {
  const _MeasurementData({required final  List<Measurement> measurements, required final  List<MovingAveragePoint> movingAverage7Day}): _measurements = measurements,_movingAverage7Day = movingAverage7Day;
  

 final  List<Measurement> _measurements;
@override List<Measurement> get measurements {
  if (_measurements is EqualUnmodifiableListView) return _measurements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_measurements);
}

 final  List<MovingAveragePoint> _movingAverage7Day;
@override List<MovingAveragePoint> get movingAverage7Day {
  if (_movingAverage7Day is EqualUnmodifiableListView) return _movingAverage7Day;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movingAverage7Day);
}


/// Create a copy of MeasurementData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementDataCopyWith<_MeasurementData> get copyWith => __$MeasurementDataCopyWithImpl<_MeasurementData>(this, _$identity);





@override
String toString() {
  return 'MeasurementData(measurements: $measurements, movingAverage7Day: $movingAverage7Day)';
}


}

/// @nodoc
abstract mixin class _$MeasurementDataCopyWith<$Res> implements $MeasurementDataCopyWith<$Res> {
  factory _$MeasurementDataCopyWith(_MeasurementData value, $Res Function(_MeasurementData) _then) = __$MeasurementDataCopyWithImpl;
@override @useResult
$Res call({
 List<Measurement> measurements, List<MovingAveragePoint> movingAverage7Day
});




}
/// @nodoc
class __$MeasurementDataCopyWithImpl<$Res>
    implements _$MeasurementDataCopyWith<$Res> {
  __$MeasurementDataCopyWithImpl(this._self, this._then);

  final _MeasurementData _self;
  final $Res Function(_MeasurementData) _then;

/// Create a copy of MeasurementData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? measurements = null,Object? movingAverage7Day = null,}) {
  return _then(_MeasurementData(
measurements: null == measurements ? _self._measurements : measurements // ignore: cast_nullable_to_non_nullable
as List<Measurement>,movingAverage7Day: null == movingAverage7Day ? _self._movingAverage7Day : movingAverage7Day // ignore: cast_nullable_to_non_nullable
as List<MovingAveragePoint>,
  ));
}


}

// dart format on
