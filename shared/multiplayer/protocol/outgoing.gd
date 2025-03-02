class_name Outgoing extends RefCounted


var _buffer: StreamPeerBuffer


func init(id: int):
	_buffer = StreamPeerBuffer.new()
	_buffer.data_array = PackedByteArray()
	_buffer.resize(2)
	_buffer.put_u16(id)


func put_bytes(value: PackedByteArray) -> void:
	_buffer.put_data(value)


func put_int8(value: int) -> void:
	_buffer.put_u8(value)


func put_int16(value: int) -> void:
	_buffer.put_u16(value)


func put_int32(value: int) -> void:
	_buffer.put_u32(value)


func put_string(value: String) -> void:
	_buffer.put_utf8_string(value)


func put_float(value: float) -> void:
	_buffer.put_float(value)


func put_bool(value: bool) -> void:
	_buffer.put_u8(int(value))


func put_vector2(value: Vector2) -> void:
	_buffer.put_float(value.x)
	_buffer.put_float(value.y)


func get_buffer() -> PackedByteArray:
	return _buffer.data_array
