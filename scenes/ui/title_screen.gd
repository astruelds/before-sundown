extends Control
## 임시 타이틀 화면.
## 0단계에서는 "번역이 되는지, 언어 바꾸기가 바로 적용되는지" 확인하는 용도다.
## 글자는 씬에 번역 키(GAME_TITLE 등)로만 적혀 있고, Godot가 자동으로 번역해서 보여 준다.

@onready var language_button: Button = $VBox/LanguageButton


func _ready() -> void:
	language_button.pressed.connect(_on_language_button_pressed)


func _on_language_button_pressed() -> void:
	Settings.toggle_language()
