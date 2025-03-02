class_name Incoming extends RefCounted


var _packed: StreamPeerBuffer


func add_packed(packed: PackedByteArray):
	_packed = StreamPeerBuffer.new()
	_packed.data_array = packed
	_packed.seek(0)


func get_id() -> int:
	return _packed.get_16()


func get_int8() -> int:
	return _packed.get_u8()


func get_int16() -> int:
	return _packed.get_u16()


func get_int32() -> int:
	return _packed.get_u32()


func get_string() -> String:
	return _packed.get_utf8_string()


func get_float() -> float:
	return _packed.get_float()


func get_bool() -> bool:
	return bool(_packed.get_u8())


func get_vector2() -> Vector2:
	var x := _packed.get_float()
	var y := _packed.get_float()
	return Vector2(x, y)
