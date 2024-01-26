extends Node2D

const DOT_TIME = 0.11

@onready var dot_scene = preload("res://dot.tscn")
@onready var player_scene = preload("res://player.tscn")
@onready var monster_scene = preload("res://monster.tscn")
@onready var tilemap = $TileMap
@onready var monster_spawn = $MonsterSpawn
@onready var player_spawn = $PlayerSpawn

var player
var monster

var paused = true
var dot_timer = 0

const WIDTH = 28
const HEIGHT = 36

var possible_patrol_tiles = []

var dot_count = 0 :
	set(value):
		if value < dot_count:
			if not $WakaWaka.playing:
				$WakaWaka.play()
			dot_timer = DOT_TIME
			if value == 0:
				get_parent().win()
			
		dot_count = value

func _ready():
	for row in range(HEIGHT):
		for col in range(WIDTH):
			var pos_vec = Vector2(col, row)
			if not tilemap.get_cell_tile_data(0, pos_vec).transpose and \
			tilemap.get_cell_source_id(0, pos_vec) == 0:
				possible_patrol_tiles.append(to_global(tilemap.map_to_local(pos_vec)))
				var new_dot = dot_scene.instantiate()
				$Dots.add_child(new_dot)
				dot_count += 1
				new_dot.position = tilemap.map_to_local(pos_vec)
	
	$MonsterScream.play()
	await $MonsterScream.finished
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = player_spawn.global_position
	$LightFlicker.play()
	await player.animation_player.animation_finished
	monster = monster_scene.instantiate()
	add_child(monster)
	monster.global_position = monster_spawn.global_position
	paused = false
	
	monster.possible_patrol_tiles = possible_patrol_tiles
	# I have no idea why this works this way
	await get_tree().physics_frame
	await get_tree().physics_frame
	monster.pathfind_point = monster.findPatrolPoint()

func _physics_process(delta):
	if dot_timer <= 0:
		$WakaWaka.stop()
	dot_timer -= delta

func updatePatrol(pos : Vector2):
	var arr = monster.possible_patrol_tiles
	arr.remove_at(arr.find(pos))
