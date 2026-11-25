extends Control
## 설정 화면 (지금은 언어만).
## 언어를 고르면 Settings가 바로 적용하고 저장한다. 화면 글자는 Godot 자동 번역으로 바로 바뀐다.

const TITLE_SCENE_PATH: String = "res://scenes/ui/title_screen.tscn"

@onready var language_option: OptionButton = $VBox/LanguageRow/LanguageOption
@onready var back_button: Button = $VBox/BackButton


func _ready() -> void:
	# 언어 목록 채우기. 글자는 번역 키(LANG_KO, LANG_EN)로 넣는다.
	for locale_code: String in Settings.SUPPORTED_LOCALES:
		language_option.add_item("LANG_" + locale_code.to_upper())
	language_option.select(Settings.SUPPORTED_LOCALES.find(Settings.locale))

	language_option.item_selected.connect(_on_language_selected)
	back_button.pressed.connect(_on_back_pressed)

	_print_josa_examples()


func _on_language_selected(index: int) -> void:
	Settings.set_language(Settings.SUPPORTED_LOCALES[index])


func _on_back_pressed() -> void:
	SceneRouter.go_to(TITLE_SCENE_PATH)


## 임시 테스트: 조사 자동 선택 결과를 Output 창에 찍는다. 대화 단계에서 지울 예정.
func _print_josa_examples() -> void:
	print("--- 조사 테스트 ---")
	for name_text: String in ["서하람", "강도윤", "한지아"]:
		print(KoreanJosa.fill_template(
			"{player_name}이/가 {family}을/를 찾으러 간다.",
			{"player_name": name_text, "family": "엄마"}))
