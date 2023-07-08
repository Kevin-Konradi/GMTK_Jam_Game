extends VideoStreamPlayer

func _ready():
	self.connect("finished", do_it_again)
	
func do_it_again():
	play()
