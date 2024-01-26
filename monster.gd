extends CharacterBody2D

const PATROL_SPEED = 60
const HUNT_SPEED = 180
const VISION_RANGE = 400
const HUNT_TRIGGER_TIME : float = 0.5
const PATROL_TRIGGER_TIME : float = 1

@onready var strands = $Strands
@onready var nav = $NavigationAgent2D
@onready var lvl = get_parent()
@onready var player = lvl.get_node("Player")

var possible_patrol_tiles

var trigger_timer : float = HUNT_TRIGGER_TIME

var facing_dir : Vector2 = Vector2.RIGHT
var hunting = false
var pathfind_point : Vector2

func _ready():
	for strand in strands.get_children():
		var rng = RandomNumberGenerator.new()
		var rand_dir = Vector2(rng.randf(), rng.randf()).normalized()
		strand.end = rand_dir * strand.length

func _physics_process(delta):
	var speed = HUNT_SPEED if hunting else PATROL_SPEED
	if hunting:
		# pathfind to player location with hunt_speed
		# if player is out of vision for 2 seconds go back to patrol
		pathfind_point = player.global_position
		if playerLOS():
			trigger_timer = min(PATROL_TRIGGER_TIME, trigger_timer + delta)
		else:
			trigger_timer -= delta
			if trigger_timer <= 0:
				trigger_timer = HUNT_TRIGGER_TIME / 2
				hunting = false
	else:
		# pick a random spot and pathfind to it
		# if player moves into vision for 1 second enter hunt
		if global_position.distance_to(pathfind_point) <= PATROL_SPEED * delta:
			pathfind_point = findPatrolPoint()
		if playerLOS():
			trigger_timer -= delta
			if trigger_timer <= 0:
				trigger_timer = PATROL_TRIGGER_TIME
				hunting = true
				$Screech.play()
		else:
			trigger_timer = min(HUNT_TRIGGER_TIME, trigger_timer + delta)
	if nav.target_position != pathfind_point: nav.target_position = pathfind_point
	velocity = global_position.direction_to(nav.get_next_path_position()) * speed
	facing_dir = velocity.normalized()
	$Sprite2D.rotation = Vector2.RIGHT.angle_to(facing_dir)
	move_and_slide()

func _process(_delta):
	updateStrands()

func updateStrands() -> void:
	for strand in strands.get_children():
		if global_position.distance_to(strand.end) > strand.length/2:
			var new_point = findNewPoint(strand, facing_dir.rotated(randf() - 0.5))
			if not new_point: return
			strand.updateEnd(new_point.position)

func findNewPoint(strand : Node, dir : Vector2) -> Dictionary:
	const ANGLE_INC = PI / 32
	var cur_ang = 0
	var space_state = get_world_2d().direct_space_state
	var col_data = null
	var back_ang = 0
	var flip = dir.rotated(PI/2).dot(strand.global_position.direction_to(strand.end))
	flip = flip / abs(flip)
	for i in range(2):
		for j in range(2):
			while cur_ang <= PI/2:
				var query = PhysicsRayQueryParameters2D.create(global_position, global_position + dir.rotated((cur_ang + back_ang) * flip) * strand.length)
				col_data = space_state.intersect_ray(query)
				if col_data: return col_data
				cur_ang += ANGLE_INC
			flip *= -1
			cur_ang = 0
		back_ang = PI/2
	return col_data

func playerLOS() -> bool:
	const ANGLE_INC = PI / 32
	var cur_ang = 0
	var space_state = get_world_2d().direct_space_state
	while cur_ang < TAU:
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2.RIGHT.rotated(cur_ang) * VISION_RANGE)
		query.collide_with_areas = true
		var col_data = space_state.intersect_ray(query)
		if col_data:
			if col_data.collider.is_in_group("Player"):
				return true
		cur_ang += ANGLE_INC
	return false

func findPatrolPoint() -> Vector2:
	if possible_patrol_tiles.size() == 0: return global_position
	return possible_patrol_tiles.pick_random()
