extends Control
## 임시 타이틀 화면.
## 글자는 씬에 번역 키(GAME_TITLE 등)로만 적혀 있고, Godot가 자동으로 번역해서 보여 준다.

const SETTINGS_SCENE_PATH: String = "res://scenes/ui/settings_screen.tscn"

@onready var settings_button: Button = $VBox/SettingsButton


func _ready() -> void:
	settings_button.pressed.connect(_on_settings_button_pressed)


func _on_settings_button_pressed() -> void:
	SceneRouter.go_to(SETTINGS_SCENE_PATH)
