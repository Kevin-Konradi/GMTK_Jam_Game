extends Button

func _ready():
	self.connect("pressed", _on_Button_pressed)

func _on_Button_pressed():
	get_tree().paused = false
	self.get_parent().hide()
	%Darkener.hide()
	
