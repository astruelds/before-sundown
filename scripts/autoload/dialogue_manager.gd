extends Node
## 이야기 글자 관리 (Autoload 이름: DialogueManager)
## data/dialogue.json에서 대사를 읽고, 지금 언어(ko/en)에 맞는 글을 돌려준다.
## 대화창 표시와 한국어 조사 자동 선택은 대화 단계에서 추가한다.

const DIALOGUE_PATH: String = "res://data/dialogue.json"

var _lines: Dictionary = {}


func _ready() -> void:
	_load_dialogue()


## 대사 ID로 지금 언어의 글을 가져온다. 없으면 ID를 그대로 돌려준다(빠진 대사를 찾기 쉽게).
func get_text(line_id: String) -> String:
	if not _lines.has(line_id):
		push_warning("대사 ID 없음: " + line_id)
		return line_id
	var entry: Dictionary = _lines[line_id]
	var lang: String = Settings.locale
	if entry.has(lang):
		return str(entry[lang])
	return str(entry.get("en", line_id))


func _load_dialogue() -> void:
	var file: FileAccess = FileAccess.open(DIALOGUE_PATH, FileAccess.READ)
	if file == null:
		push_error("dialogue.json을 열 수 없음")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_lines = parsed
	else:
		push_error("dialogue.json 형식이 잘못됨")
