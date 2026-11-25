extends Node
## 설정 관리 (Autoload 이름: Settings)
## 언어, 음량, 화면 설정을 user://settings.cfg 파일에 저장하고 불러온다.
## 0단계에서는 "언어"만 다룬다. 음량과 화면 설정은 나중에 추가한다.

## 언어가 바뀌었을 때 알리는 신호. 직접 글자를 그리는 노드가 이 신호를 듣고 다시 그린다.
signal language_changed(locale: String)

const SETTINGS_PATH: String = "user://settings.cfg"
const SUPPORTED_LOCALES: Array[String] = ["ko", "en"]

## 지금 쓰는 언어 코드 ("ko" 또는 "en")
var locale: String = "en"


func _ready() -> void:
	_load()
	TranslationServer.set_locale(locale)


## 언어를 바꾸고 바로 적용한 뒤 파일에 저장한다.
func set_language(new_locale: String) -> void:
	if not SUPPORTED_LOCALES.has(new_locale):
		push_warning("지원하지 않는 언어: " + new_locale)
		return
	locale = new_locale
	TranslationServer.set_locale(locale)
	_save()
	language_changed.emit(locale)


## 한국어 <-> 영어를 번갈아 바꾼다.
func toggle_language() -> void:
	set_language("en" if locale == "ko" else "ko")


func _load() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		locale = str(config.get_value("general", "language", _detect_os_language()))
	else:
		# 처음 실행: 저장된 파일이 없으면 컴퓨터 언어를 따라간다.
		locale = _detect_os_language()
	if not SUPPORTED_LOCALES.has(locale):
		locale = "en"


func _save() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(SETTINGS_PATH)  # 다른 설정이 이미 있으면 지우지 않도록 먼저 읽는다.
	config.set_value("general", "language", locale)
	config.save(SETTINGS_PATH)


## 컴퓨터 언어가 한국어면 "ko", 그 밖에는 "en"
func _detect_os_language() -> String:
	return "ko" if OS.get_locale_language() == "ko" else "en"
