extends Node3D

@onready var win_screen : Control = $WinLayerInner/WinScreen

func _ready():
	win_screen.visible = false
	if not JetpackManager.all_collected.is_connected(_on_all_collected):
		JetpackManager.all_collected.connect(_on_all_collected)



func _on_all_collected() -> void:
	win_screen.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif not JetpackManager.game_over:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
