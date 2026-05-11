extends Node3D

@export var minigame_id := ""
@onready var win_screen: Control = $WinLayerInner/WinScreen

func _ready() -> void:
	win_screen.visible = false
	if not GameState.minigame_completed.is_connected(_on_minigame_completed):
		GameState.minigame_completed.connect(_on_minigame_completed)

func _on_minigame_completed(id: String) -> void:
	if id == minigame_id:
		win_screen.visible = true
