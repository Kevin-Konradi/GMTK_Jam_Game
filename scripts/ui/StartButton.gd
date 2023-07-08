extends Button

# TODO: Add MusicMute button
# the music is good, but that's what everyone does first when opening up a game

func _ready():
	self.connect("pressed", _on_Button_pressed)

func _on_Button_pressed():
	$"/root/SceneManager".goto_level("Tutorial")
