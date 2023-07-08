extends Label

var start_time

func _ready():
	$Timer.connect("timeout", _on_Timer_timeout)
	start_time = Time.get_unix_time_from_system()

func _on_Timer_timeout():
	# in sec
	var time_diff = Time.get_unix_time_from_system() - start_time
	
	var mins = roundi(time_diff) / 60
	var secs = roundi(time_diff) % 60
	
	# Pad by two
	self.text = "%0*d:%0*d" % [2, mins, 2, secs]
