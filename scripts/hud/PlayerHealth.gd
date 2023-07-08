extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	%"Player".connect("health_updated", _on_Player_health_updated)
	add_hearts(%"Player".initial_health)

func _on_Player_health_updated(new_health):	
	var diff = new_health - self.get_child_count()
	
	if diff > 0:
		add_hearts(diff)
	elif diff < 0:
		remove_children(abs(diff))

func add_hearts(amount):
	for i in range(amount):
		var heart = TextureRect.new()
		heart.texture = preload("res://assets/materials/heart_texture.tres")
		add_child(heart)

func remove_children(amount):
	var children = self.get_children()
	
	for i in range(amount):
		var child = children[i]
		self.remove_child(child)
		child.queue_free()
