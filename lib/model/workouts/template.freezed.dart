// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutTemplate {

 String get id; String get name; String? get description; bool get isBuiltin; DateTime get createdAt; DateTime get updatedAt; List<TemplateSet> get sets;
/// Create a copy of WorkoutTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutTemplateCopyWith<WorkoutTemplate> get copyWith => _$WorkoutTemplateCopyWithImpl<WorkoutTemplate>(this as WorkoutTemplate, _$identity);

  /// Serializes this WorkoutTemplate to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'WorkoutTemplate(id: $id, name: $name, description: $description, isBuiltin: $isBuiltin, createdAt: $createdAt, updatedAt: $updatedAt, sets: $sets)';
}


}

/// @nodoc
abstract mixin class $WorkoutTemplateCopyWith<$Res>  {
  factory $WorkoutTemplateCopyWith(WorkoutTemplate value, $Res Function(WorkoutTemplate) _then) = _$WorkoutTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, bool isBuiltin, DateTime createdAt, DateTime updatedAt, List<TemplateSet> sets
});




}
/// @nodoc
class _$WorkoutTemplateCopyWithImpl<$Res>
    implements $WorkoutTemplateCopyWith<$Res> {
  _$WorkoutTemplateCopyWithImpl(this._self, this._then);

  final WorkoutTemplate _self;
  final $Res Function(WorkoutTemplate) _then;

/// Create a copy of WorkoutTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? isBuiltin = null,Object? createdAt = null,Object? updatedAt = null,Object? sets = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBuiltin: null == isBuiltin ? _self.isBuiltin : isBuiltin // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<TemplateSet>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutTemplate].
extension WorkoutTemplatePatterns on WorkoutTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutTemplate value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  bool isBuiltin,  DateTime createdAt,  DateTime updatedAt,  List<TemplateSet> sets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.isBuiltin,_that.createdAt,_that.updatedAt,_that.sets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  bool isBuiltin,  DateTime createdAt,  DateTime updatedAt,  List<TemplateSet> sets)  $default,) {final _that = this;
switch (_that) {
case _WorkoutTemplate():
return $default(_that.id,_that.name,_that.description,_that.isBuiltin,_that.createdAt,_that.updatedAt,_that.sets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  bool isBuiltin,  DateTime createdAt,  DateTime updatedAt,  List<TemplateSet> sets)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.isBuiltin,_that.createdAt,_that.updatedAt,_that.sets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutTemplate extends WorkoutTemplate {
  const _WorkoutTemplate({required this.id, required this.name, this.description, this.isBuiltin = false, required this.createdAt, required this.updatedAt, final  List<TemplateSet> sets = const []}): _sets = sets,super._();
  factory _WorkoutTemplate.fromJson(Map<String, dynamic> json) => _$WorkoutTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey() final  bool isBuiltin;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<TemplateSet> _sets;
@override@JsonKey() List<TemplateSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}


/// Create a copy of WorkoutTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutTemplateCopyWith<_WorkoutTemplate> get copyWith => __$WorkoutTemplateCopyWithImpl<_WorkoutTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutTemplateToJson(this, );
}



@override
String toString() {
  return 'WorkoutTemplate(id: $id, name: $name, description: $description, isBuiltin: $isBuiltin, createdAt: $createdAt, updatedAt: $updatedAt, sets: $sets)';
}


}

/// @nodoc
abstract mixin class _$WorkoutTemplateCopyWith<$Res> implements $WorkoutTemplateCopyWith<$Res> {
  factory _$WorkoutTemplateCopyWith(_WorkoutTemplate value, $Res Function(_WorkoutTemplate) _then) = __$WorkoutTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, bool isBuiltin, DateTime createdAt, DateTime updatedAt, List<TemplateSet> sets
});




}
/// @nodoc
class __$WorkoutTemplateCopyWithImpl<$Res>
    implements _$WorkoutTemplateCopyWith<$Res> {
  __$WorkoutTemplateCopyWithImpl(this._self, this._then);

  final _WorkoutTemplate _self;
  final $Res Function(_WorkoutTemplate) _then;

/// Create a copy of WorkoutTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? isBuiltin = null,Object? createdAt = null,Object? updatedAt = null,Object? sets = null,}) {
  return _then(_WorkoutTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBuiltin: null == isBuiltin ? _self.isBuiltin : isBuiltin // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<TemplateSet>,
  ));
}


}


/// @nodoc
mixin _$TemplateSet {

 String get id; String get templateId; String get exerciseId; Map<String, String> get tweaks; int get setOrder; DateTime get createdAt;
/// Create a copy of TemplateSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateSetCopyWith<TemplateSet> get copyWith => _$TemplateSetCopyWithImpl<TemplateSet>(this as TemplateSet, _$identity);

  /// Serializes this TemplateSet to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'TemplateSet(id: $id, templateId: $templateId, exerciseId: $exerciseId, tweaks: $tweaks, setOrder: $setOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TemplateSetCopyWith<$Res>  {
  factory $TemplateSetCopyWith(TemplateSet value, $Res Function(TemplateSet) _then) = _$TemplateSetCopyWithImpl;
@useResult
$Res call({
 String id, String templateId, String exerciseId, Map<String, String> tweaks, int setOrder, DateTime createdAt
});




}
/// @nodoc
class _$TemplateSetCopyWithImpl<$Res>
    implements $TemplateSetCopyWith<$Res> {
  _$TemplateSetCopyWithImpl(this._self, this._then);

  final TemplateSet _self;
  final $Res Function(TemplateSet) _then;

/// Create a copy of TemplateSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? templateId = null,Object? exerciseId = null,Object? tweaks = null,Object? setOrder = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,tweaks: null == tweaks ? _self.tweaks : tweaks // ignore: cast_nullable_to_non_nullable
as Map<String, String>,setOrder: null == setOrder ? _self.setOrder : setOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateSet].
extension TemplateSetPatterns on TemplateSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateSet value)  $default,){
final _that = this;
switch (_that) {
case _TemplateSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateSet value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String templateId,  String exerciseId,  Map<String, String> tweaks,  int setOrder,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateSet() when $default != null:
return $default(_that.id,_that.templateId,_that.exerciseId,_that.tweaks,_that.setOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String templateId,  String exerciseId,  Map<String, String> tweaks,  int setOrder,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TemplateSet():
return $default(_that.id,_that.templateId,_that.exerciseId,_that.tweaks,_that.setOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String templateId,  String exerciseId,  Map<String, String> tweaks,  int setOrder,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TemplateSet() when $default != null:
return $default(_that.id,_that.templateId,_that.exerciseId,_that.tweaks,_that.setOrder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateSet extends TemplateSet {
  const _TemplateSet({required this.id, required this.templateId, required this.exerciseId, final  Map<String, String> tweaks = const {}, required this.setOrder, required this.createdAt}): _tweaks = tweaks,super._();
  factory _TemplateSet.fromJson(Map<String, dynamic> json) => _$TemplateSetFromJson(json);

@override final  String id;
@override final  String templateId;
@override final  String exerciseId;
 final  Map<String, String> _tweaks;
@override@JsonKey() Map<String, String> get tweaks {
  if (_tweaks is EqualUnmodifiableMapView) return _tweaks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tweaks);
}

@override final  int setOrder;
@override final  DateTime createdAt;

/// Create a copy of TemplateSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateSetCopyWith<_TemplateSet> get copyWith => __$TemplateSetCopyWithImpl<_TemplateSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateSetToJson(this, );
}



@override
String toString() {
  return 'TemplateSet(id: $id, templateId: $templateId, exerciseId: $exerciseId, tweaks: $tweaks, setOrder: $setOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TemplateSetCopyWith<$Res> implements $TemplateSetCopyWith<$Res> {
  factory _$TemplateSetCopyWith(_TemplateSet value, $Res Function(_TemplateSet) _then) = __$TemplateSetCopyWithImpl;
@override @useResult
$Res call({
 String id, String templateId, String exerciseId, Map<String, String> tweaks, int setOrder, DateTime createdAt
});




}
/// @nodoc
class __$TemplateSetCopyWithImpl<$Res>
    implements _$TemplateSetCopyWith<$Res> {
  __$TemplateSetCopyWithImpl(this._self, this._then);

  final _TemplateSet _self;
  final $Res Function(_TemplateSet) _then;

/// Create a copy of TemplateSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? templateId = null,Object? exerciseId = null,Object? tweaks = null,Object? setOrder = null,Object? createdAt = null,}) {
  return _then(_TemplateSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,tweaks: null == tweaks ? _self._tweaks : tweaks // ignore: cast_nullable_to_non_nullable
as Map<String, String>,setOrder: null == setOrder ? _self.setOrder : setOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
