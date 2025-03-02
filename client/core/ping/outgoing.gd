class_name CPingOutgoing extends Outgoing


func _init() -> void:
	super.init(Packets.PING)

	CGlobals.ping_sender_time = Time.get_ticks_msec()
