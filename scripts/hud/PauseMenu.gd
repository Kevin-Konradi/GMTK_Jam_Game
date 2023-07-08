extends MarginContainer

func _ready():
	self.hide()

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = true
		%Darkener.show()
		self.show()
		
