extends Node2D

const BASE_LENGTH = 40.0

var length = 40
var start : Vector2
var end : Vector2

func _ready():
	scale.x = length / BASE_LENGTH

func update():
	global_position = (start + end) / 2
	rotation = start.direction_to(end).angle()
