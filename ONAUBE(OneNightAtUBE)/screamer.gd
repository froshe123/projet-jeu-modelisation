extends Node2D

@onready var sprite = $CanvasLayer/sprite
@onready var timer = $Timer

signal jumpscare_finished

var shake_active := false
var shake_base_pos := Vector2.ZERO

func _ready():
	sprite.visible = false
	timer.wait_time = 1.5
	timer.one_shot = true
	timer.timeout.connect(_on_finished)
	trigger()

func trigger():
	sprite.visible = true
	sprite.scale = Vector2(0.3, 0.3)
	shake_base_pos = get_viewport_rect().size / 2
	sprite.position = shake_base_pos
	AudioManager.play_screamer()
	
	# Zoom
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(3.0, 3.0), 0.15)
	
	# Active le shake
	shake_active = true
	timer.start()

func _process(_delta):
	if shake_active:
		sprite.position = shake_base_pos + Vector2(
			randf_range(-25, 25),
			randf_range(-25, 25)
		)
		sprite.rotation = randf_range(-0.05, 0.05)  # ~3 degrés max

func _on_finished():
	shake_active = false
	emit_signal("jumpscare_finished")
	get_tree().change_scene_to_file("res://ecran_mort.tscn")
