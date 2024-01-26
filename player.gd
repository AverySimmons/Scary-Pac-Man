extends Node2D

var in_dir = Vector2.UP
var facing_dir = in_dir
var moving = false
var just_started = true
@onready var lvl : Node2D = get_parent()
@onready var tilemap : TileMap = lvl.get_node("TileMap")
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Flicker")

func _physics_process(_delta):
	if lvl.paused: return
	checkInputs()
	if not moving:
		checkMove()

func checkInputs() -> void:
	if Input.is_action_just_pressed("up"):
		in_dir = Vector2.UP
	elif Input.is_action_just_pressed("down"):
		in_dir = Vector2.DOWN
	elif Input.is_action_just_pressed("right"):
		in_dir = Vector2.RIGHT
	elif Input.is_action_just_pressed("left"):
		in_dir = Vector2.LEFT

func checkMove() -> void:
	var cur_pos : Vector2 = tilemap.local_to_map(lvl.to_local(global_position))
	var in_check_pos = cur_pos + in_dir
	if tilemap.get_cell_source_id(0, in_check_pos) == 0: 
		just_started = false
		facing_dir = in_dir
		animation_player.play("Moving")
		updateRotation()
	var face_check_pos = cur_pos + facing_dir
	if tilemap.get_cell_source_id(0, face_check_pos) == 0:
		moving = true
		var t = create_tween()
		t.tween_property(self, "global_position", lvl.to_global(tilemap.map_to_local(face_check_pos)), 0.1)
		await t.finished
		moving = false
	else: stopped()

func updateRotation():
	rotation = Vector2.RIGHT.angle_to(facing_dir)

func stopped() -> void:
	animation_player.pause()
	if sprite.frame == 0 and not just_started:
		sprite.frame = 1

func _on_area_2d_body_entered(_body):
	lvl.get_parent().gameOver()
