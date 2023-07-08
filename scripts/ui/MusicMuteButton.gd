extends CheckButton

func _ready():
	self.connect("pressed", _on_Button_pressed)

func _on_Button_pressed():
	%"TitleThemePlayer".stream_paused = self.button_pressed
