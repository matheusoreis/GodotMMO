class_name UI extends CanvasLayer


var interfaces: Array[Control]


func add_interface(interface: Control) -> void:
	if interface:
		interfaces.append(interface)


func show_interface(interface_name: String) -> void:
	for interface in interfaces:
		if interface and interface.name == interface_name:
			interface.show()
			interface.set_process(true)
			break


func hide_interface(interface_name: String) -> void:
	for interface in interfaces:
		if interface and interface.name == interface_name:
			interface.hide()
			interface.set_process(false)
			break


func get_interface(interface_name: String) -> Control:
	for interface in interfaces:
		if interface and interface.name == interface_name:
			return interface
	return null
