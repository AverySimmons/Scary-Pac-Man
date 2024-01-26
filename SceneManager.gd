extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var level_scene = preload("res://level.tscn")

var level : Node2D

func _ready():
	await anim_player.animation_finished
	$"Pac-manScreenshot".visible = false
	level = level_scene.instantiate()
	add_child(level)

func gameOver() -> void:
	level.player.get_node("PointLight2D").visible = false
	get_tree().paused = true
	anim_player.play("GameOver")
	$BiteSound.play()
	$GlitchSound.play()
	await anim_player.animation_finished
	await get_tree().create_timer(6).timeout
	anim_player.play("RESET")
	get_tree().paused = false
	restartLevel()

func win() -> void:
	get_tree().paused = true
	anim_player.play("Win")
	$WinSound.play()
	await anim_player.animation_finished
	await get_tree().create_timer(2).timeout
	get_tree().quit()

func restartLevel() -> void:
	remove_child(level)
	level = level_scene.instantiate()
	add_child(level)
