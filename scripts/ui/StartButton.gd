extends Button

func _ready():
	self.connect("pressed", _on_Button_pressed)

func _on_Button_pressed():
	$"/root/SceneManager".goto_level("DemoMap")
