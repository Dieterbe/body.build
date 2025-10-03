// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Sets {

 int get intensity;@JsonKey(toJson: _exToJson, fromJson: _exFromJson) Ex? get ex; int get n;@JsonKey(includeToJson: false) bool get changeEx; Map<String, String> get tweakOptions;// Map of tweak name to selected option
 Map<String, bool> get cueOptions;
/// Create a copy of Sets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetsCopyWith<Sets> get copyWith => _$SetsCopyWithImpl<Sets>(this as Sets, _$identity);

  /// Serializes this Sets to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Sets(intensity: $intensity, ex: $ex, n: $n, changeEx: $changeEx, tweakOptions: $tweakOptions, cueOptions: $cueOptions)';
}


}

/// @nodoc
abstract mixin class $SetsCopyWith<$Res>  {
  factory $SetsCopyWith(Sets value, $Res Function(Sets) _then) = _$SetsCopyWithImpl;
@useResult
$Res call({
 int intensity,@JsonKey(toJson: _exToJson, fromJson: _exFromJson) Ex? ex, int n,@JsonKey(includeToJson: false) bool changeEx, Map<String, String> tweakOptions, Map<String, bool> cueOptions
});




}
/// @nodoc
class _$SetsCopyWithImpl<$Res>
    implements $SetsCopyWith<$Res> {
  _$SetsCopyWithImpl(this._self, this._then);

  final Sets _self;
  final $Res Function(Sets) _then;

/// Create a copy of Sets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? intensity = null,Object? ex = freezed,Object? n = null,Object? changeEx = null,Object? tweakOptions = null,Object? cueOptions = null,}) {
  return _then(_self.copyWith(
intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as int,ex: freezed == ex ? _self.ex : ex // ignore: cast_nullable_to_non_nullable
as Ex?,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,changeEx: null == changeEx ? _self.changeEx : changeEx // ignore: cast_nullable_to_non_nullable
as bool,tweakOptions: null == tweakOptions ? _self.tweakOptions : tweakOptions // ignore: cast_nullable_to_non_nullable
as Map<String, String>,cueOptions: null == cueOptions ? _self.cueOptions : cueOptions // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [Sets].
extension SetsPatterns on Sets {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sets() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sets value)  $default,){
final _that = this;
switch (_that) {
case _Sets():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sets value)?  $default,){
final _that = this;
switch (_that) {
case _Sets() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int intensity, @JsonKey(toJson: _exToJson, fromJson: _exFromJson)  Ex? ex,  int n, @JsonKey(includeToJson: false)  bool changeEx,  Map<String, String> tweakOptions,  Map<String, bool> cueOptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sets() when $default != null:
return $default(_that.intensity,_that.ex,_that.n,_that.changeEx,_that.tweakOptions,_that.cueOptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int intensity, @JsonKey(toJson: _exToJson, fromJson: _exFromJson)  Ex? ex,  int n, @JsonKey(includeToJson: false)  bool changeEx,  Map<String, String> tweakOptions,  Map<String, bool> cueOptions)  $default,) {final _that = this;
switch (_that) {
case _Sets():
return $default(_that.intensity,_that.ex,_that.n,_that.changeEx,_that.tweakOptions,_that.cueOptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int intensity, @JsonKey(toJson: _exToJson, fromJson: _exFromJson)  Ex? ex,  int n, @JsonKey(includeToJson: false)  bool changeEx,  Map<String, String> tweakOptions,  Map<String, bool> cueOptions)?  $default,) {final _that = this;
switch (_that) {
case _Sets() when $default != null:
return $default(_that.intensity,_that.ex,_that.n,_that.changeEx,_that.tweakOptions,_that.cueOptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Sets extends Sets {
  const _Sets(this.intensity, {@JsonKey(toJson: _exToJson, fromJson: _exFromJson) this.ex, this.n = 1, @JsonKey(includeToJson: false) this.changeEx = false, final  Map<String, String> tweakOptions = const {}, final  Map<String, bool> cueOptions = const {}}): _tweakOptions = tweakOptions,_cueOptions = cueOptions,super._();
  factory _Sets.fromJson(Map<String, dynamic> json) => _$SetsFromJson(json);

@override final  int intensity;
@override@JsonKey(toJson: _exToJson, fromJson: _exFromJson) final  Ex? ex;
@override@JsonKey() final  int n;
@override@JsonKey(includeToJson: false) final  bool changeEx;
 final  Map<String, String> _tweakOptions;
@override@JsonKey() Map<String, String> get tweakOptions {
  if (_tweakOptions is EqualUnmodifiableMapView) return _tweakOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tweakOptions);
}

// Map of tweak name to selected option
 final  Map<String, bool> _cueOptions;
// Map of tweak name to selected option
@override@JsonKey() Map<String, bool> get cueOptions {
  if (_cueOptions is EqualUnmodifiableMapView) return _cueOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cueOptions);
}


/// Create a copy of Sets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetsCopyWith<_Sets> get copyWith => __$SetsCopyWithImpl<_Sets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetsToJson(this, );
}



@override
String toString() {
  return 'Sets(intensity: $intensity, ex: $ex, n: $n, changeEx: $changeEx, tweakOptions: $tweakOptions, cueOptions: $cueOptions)';
}


}

/// @nodoc
abstract mixin class _$SetsCopyWith<$Res> implements $SetsCopyWith<$Res> {
  factory _$SetsCopyWith(_Sets value, $Res Function(_Sets) _then) = __$SetsCopyWithImpl;
@override @useResult
$Res call({
 int intensity,@JsonKey(toJson: _exToJson, fromJson: _exFromJson) Ex? ex, int n,@JsonKey(includeToJson: false) bool changeEx, Map<String, String> tweakOptions, Map<String, bool> cueOptions
});




}
/// @nodoc
class __$SetsCopyWithImpl<$Res>
    implements _$SetsCopyWith<$Res> {
  __$SetsCopyWithImpl(this._self, this._then);

  final _Sets _self;
  final $Res Function(_Sets) _then;

/// Create a copy of Sets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? intensity = null,Object? ex = freezed,Object? n = null,Object? changeEx = null,Object? tweakOptions = null,Object? cueOptions = null,}) {
  return _then(_Sets(
null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as int,ex: freezed == ex ? _self.ex : ex // ignore: cast_nullable_to_non_nullable
as Ex?,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,changeEx: null == changeEx ? _self.changeEx : changeEx // ignore: cast_nullable_to_non_nullable
as bool,tweakOptions: null == tweakOptions ? _self._tweakOptions : tweakOptions // ignore: cast_nullable_to_non_nullable
as Map<String, String>,cueOptions: null == cueOptions ? _self._cueOptions : cueOptions // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}


/// @nodoc
mixin _$SetGroup {

 List<Sets> get sets;
/// Create a copy of SetGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetGroupCopyWith<SetGroup> get copyWith => _$SetGroupCopyWithImpl<SetGroup>(this as SetGroup, _$identity);

  /// Serializes this SetGroup to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'SetGroup(sets: $sets)';
}


}

/// @nodoc
abstract mixin class $SetGroupCopyWith<$Res>  {
  factory $SetGroupCopyWith(SetGroup value, $Res Function(SetGroup) _then) = _$SetGroupCopyWithImpl;
@useResult
$Res call({
 List<Sets> sets
});




}
/// @nodoc
class _$SetGroupCopyWithImpl<$Res>
    implements $SetGroupCopyWith<$Res> {
  _$SetGroupCopyWithImpl(this._self, this._then);

  final SetGroup _self;
  final $Res Function(SetGroup) _then;

/// Create a copy of SetGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sets = null,}) {
  return _then(_self.copyWith(
sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<Sets>,
  ));
}

}


/// Adds pattern-matching-related methods to [SetGroup].
extension SetGroupPatterns on SetGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetGroup value)  $default,){
final _that = this;
switch (_that) {
case _SetGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetGroup value)?  $default,){
final _that = this;
switch (_that) {
case _SetGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Sets> sets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetGroup() when $default != null:
return $default(_that.sets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Sets> sets)  $default,) {final _that = this;
switch (_that) {
case _SetGroup():
return $default(_that.sets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Sets> sets)?  $default,) {final _that = this;
switch (_that) {
case _SetGroup() when $default != null:
return $default(_that.sets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetGroup implements SetGroup {
  const _SetGroup(final  List<Sets> sets): _sets = sets;
  factory _SetGroup.fromJson(Map<String, dynamic> json) => _$SetGroupFromJson(json);

 final  List<Sets> _sets;
@override List<Sets> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}


/// Create a copy of SetGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetGroupCopyWith<_SetGroup> get copyWith => __$SetGroupCopyWithImpl<_SetGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetGroupToJson(this, );
}



@override
String toString() {
  return 'SetGroup(sets: $sets)';
}


}

/// @nodoc
abstract mixin class _$SetGroupCopyWith<$Res> implements $SetGroupCopyWith<$Res> {
  factory _$SetGroupCopyWith(_SetGroup value, $Res Function(_SetGroup) _then) = __$SetGroupCopyWithImpl;
@override @useResult
$Res call({
 List<Sets> sets
});




}
/// @nodoc
class __$SetGroupCopyWithImpl<$Res>
    implements _$SetGroupCopyWith<$Res> {
  __$SetGroupCopyWithImpl(this._self, this._then);

  final _SetGroup _self;
  final $Res Function(_SetGroup) _then;

/// Create a copy of SetGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sets = null,}) {
  return _then(_SetGroup(
null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<Sets>,
  ));
}


}

// dart format on
