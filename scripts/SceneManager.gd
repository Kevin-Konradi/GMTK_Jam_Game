extends Node

var root_2d_scene = preload("res://root_2d.tscn")
var current_scene = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_level(map_name):
	# See https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
	call_deferred("_deferred_goto_level", map_name)

func _deferred_goto_level(map_name):
	current_scene.free()
	current_scene = root_2d_scene.instantiate()
	
	var map_path = "res://levels/%s.tscn" % map_name
	var map = ResourceLoader.load(map_path).instantiate()
	current_scene.add_child(map)
	
	current_scene.map = map

	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
