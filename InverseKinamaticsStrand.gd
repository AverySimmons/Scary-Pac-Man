extends Node2D

@export var seg_arr : Array[int] = []
@export var color_ind : int = 0
const COLOR_ARR = [Color("FF0000"), Color("FFB8FF"), Color("00FFFF"), Color("FFB852")]
var end : Vector2
var length : int = 0

@onready var segment_scene = preload("res://segment.tscn")

func _ready():
	modulate = COLOR_ARR[color_ind]
	for l in seg_arr:
		var new_seg = segment_scene.instantiate()
		new_seg.length = l
		add_child(new_seg)
		length += l

func _process(_delta):
	update()

func update():
	var point = end
	var segs = get_children()
	
	for i in range(segs.size()-1, -1, -1):
		var seg = segs[i]
		seg.end = point
		if seg.start == point: seg.start.x -= 0.0001
		seg.start = point + point.direction_to(seg.start) * seg.length
		point = seg.start
	
	point = global_position
	
	for seg in segs:
		seg.start = point
		if seg.end == point: seg.end.x -= 0.0001
		seg.end = point + point.direction_to(seg.end) * seg.length
		point = seg.end
		seg.update()

func updateEnd(point : Vector2) -> void:
	var t = create_tween()
	t.tween_property(self, "end", point, 0.15)
