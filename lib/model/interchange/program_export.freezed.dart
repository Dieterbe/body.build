// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_export.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramExport {

 int get formatVersion; int get exerciseDatasetVersion; ProgramState get program; DateTime? get exportedAt; String? get exportedFrom;
/// Create a copy of ProgramExport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramExportCopyWith<ProgramExport> get copyWith => _$ProgramExportCopyWithImpl<ProgramExport>(this as ProgramExport, _$identity);

  /// Serializes this ProgramExport to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'ProgramExport(formatVersion: $formatVersion, exerciseDatasetVersion: $exerciseDatasetVersion, program: $program, exportedAt: $exportedAt, exportedFrom: $exportedFrom)';
}


}

/// @nodoc
abstract mixin class $ProgramExportCopyWith<$Res>  {
  factory $ProgramExportCopyWith(ProgramExport value, $Res Function(ProgramExport) _then) = _$ProgramExportCopyWithImpl;
@useResult
$Res call({
 int formatVersion, int exerciseDatasetVersion, ProgramState program, DateTime? exportedAt, String? exportedFrom
});


$ProgramStateCopyWith<$Res> get program;

}
/// @nodoc
class _$ProgramExportCopyWithImpl<$Res>
    implements $ProgramExportCopyWith<$Res> {
  _$ProgramExportCopyWithImpl(this._self, this._then);

  final ProgramExport _self;
  final $Res Function(ProgramExport) _then;

/// Create a copy of ProgramExport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formatVersion = null,Object? exerciseDatasetVersion = null,Object? program = null,Object? exportedAt = freezed,Object? exportedFrom = freezed,}) {
  return _then(_self.copyWith(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,exerciseDatasetVersion: null == exerciseDatasetVersion ? _self.exerciseDatasetVersion : exerciseDatasetVersion // ignore: cast_nullable_to_non_nullable
as int,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as ProgramState,exportedAt: freezed == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,exportedFrom: freezed == exportedFrom ? _self.exportedFrom : exportedFrom // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProgramExport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgramStateCopyWith<$Res> get program {
  
  return $ProgramStateCopyWith<$Res>(_self.program, (value) {
    return _then(_self.copyWith(program: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgramExport].
extension ProgramExportPatterns on ProgramExport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramExport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramExport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramExport value)  $default,){
final _that = this;
switch (_that) {
case _ProgramExport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramExport value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramExport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int formatVersion,  int exerciseDatasetVersion,  ProgramState program,  DateTime? exportedAt,  String? exportedFrom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramExport() when $default != null:
return $default(_that.formatVersion,_that.exerciseDatasetVersion,_that.program,_that.exportedAt,_that.exportedFrom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int formatVersion,  int exerciseDatasetVersion,  ProgramState program,  DateTime? exportedAt,  String? exportedFrom)  $default,) {final _that = this;
switch (_that) {
case _ProgramExport():
return $default(_that.formatVersion,_that.exerciseDatasetVersion,_that.program,_that.exportedAt,_that.exportedFrom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int formatVersion,  int exerciseDatasetVersion,  ProgramState program,  DateTime? exportedAt,  String? exportedFrom)?  $default,) {final _that = this;
switch (_that) {
case _ProgramExport() when $default != null:
return $default(_that.formatVersion,_that.exerciseDatasetVersion,_that.program,_that.exportedAt,_that.exportedFrom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramExport extends ProgramExport {
  const _ProgramExport({required this.formatVersion, required this.exerciseDatasetVersion, required this.program, this.exportedAt, this.exportedFrom}): super._();
  factory _ProgramExport.fromJson(Map<String, dynamic> json) => _$ProgramExportFromJson(json);

@override final  int formatVersion;
@override final  int exerciseDatasetVersion;
@override final  ProgramState program;
@override final  DateTime? exportedAt;
@override final  String? exportedFrom;

/// Create a copy of ProgramExport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramExportCopyWith<_ProgramExport> get copyWith => __$ProgramExportCopyWithImpl<_ProgramExport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramExportToJson(this, );
}



@override
String toString() {
  return 'ProgramExport(formatVersion: $formatVersion, exerciseDatasetVersion: $exerciseDatasetVersion, program: $program, exportedAt: $exportedAt, exportedFrom: $exportedFrom)';
}


}

/// @nodoc
abstract mixin class _$ProgramExportCopyWith<$Res> implements $ProgramExportCopyWith<$Res> {
  factory _$ProgramExportCopyWith(_ProgramExport value, $Res Function(_ProgramExport) _then) = __$ProgramExportCopyWithImpl;
@override @useResult
$Res call({
 int formatVersion, int exerciseDatasetVersion, ProgramState program, DateTime? exportedAt, String? exportedFrom
});


@override $ProgramStateCopyWith<$Res> get program;

}
/// @nodoc
class __$ProgramExportCopyWithImpl<$Res>
    implements _$ProgramExportCopyWith<$Res> {
  __$ProgramExportCopyWithImpl(this._self, this._then);

  final _ProgramExport _self;
  final $Res Function(_ProgramExport) _then;

/// Create a copy of ProgramExport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formatVersion = null,Object? exerciseDatasetVersion = null,Object? program = null,Object? exportedAt = freezed,Object? exportedFrom = freezed,}) {
  return _then(_ProgramExport(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,exerciseDatasetVersion: null == exerciseDatasetVersion ? _self.exerciseDatasetVersion : exerciseDatasetVersion // ignore: cast_nullable_to_non_nullable
as int,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as ProgramState,exportedAt: freezed == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,exportedFrom: freezed == exportedFrom ? _self.exportedFrom : exportedFrom // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProgramExport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgramStateCopyWith<$Res> get program {
  
  return $ProgramStateCopyWith<$Res>(_self.program, (value) {
    return _then(_self.copyWith(program: value));
  });
}
}

// dart format on
