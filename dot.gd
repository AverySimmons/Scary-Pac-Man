extends Node2D

@onready var lvl = get_parent().get_parent()

func _on_area_2d_area_entered(_area):
	lvl.dot_count -= 1
	lvl.updatePatrol(global_position)
	queue_free()
