extends SubViewportContainer

@export var scene: PackedScene
var mini_game_instance = null
@onready var sub_viewport: SubViewport = $SubViewport

func _ready() -> void:
	mettre_en_plein_ecran()
	get_viewport().size_changed.connect(mettre_en_plein_ecran)

func open_minigame():
	mettre_en_plein_ecran()
	if mini_game_instance == null:
		mini_game_instance = scene.instantiate()
		sub_viewport.add_child(mini_game_instance)

	_activate_only_this()
	
	

func mettre_en_plein_ecran() -> void:
	var taille_fenetre := get_viewport_rect().size
	set_anchors_preset(Control.PRESET_FULL_RECT)
	custom_minimum_size = Vector2.ZERO
	offset_left = 0.0
	offset_top = 0.0
	offset_right = 0.0
	offset_bottom = 0.0
	size = taille_fenetre
	stretch = true
	sub_viewport.size = Vector2i(taille_fenetre)


func _activate_only_this():

	for child in mini_game_instance.get_children():
		if child.has_method("set_active"):
			child.set_active(true)
			print("test")
	
	# Active la caméra
	var cam = _find_first_camera(mini_game_instance)
	if cam:
		cam.current = true

func _find_first_camera(node: Node) -> Camera3D:
	if node is Camera3D:
		return node

	for child in node.get_children():
		var cam = _find_first_camera(child)
		if cam:
			return cam

	return null
