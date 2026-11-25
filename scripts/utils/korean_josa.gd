class_name KoreanJosa
extends RefCounted
## 한국어 조사 자동 선택 도우미.
## 이름의 마지막 글자에 받침이 있는지 보고 이/가, 을/를, 은/는, 와/과, (으)로 중 맞는 것을 고른다.
##
## 사용 예:
##   KoreanJosa.attach("서하람", "이/가")   → "서하람이"
##   KoreanJosa.attach("한지아", "이/가")   → "한지아가"
##   KoreanJosa.fill_template("{player_name}은/는 {family}와/과 만났다.",
##       {"player_name": "강도윤", "family": "엄마"})  → "강도윤은 엄마와 만났다."

const HANGUL_START: int = 0xAC00  # '가'
const HANGUL_END: int = 0xD7A3    # '힣'
const JONGSEONG_COUNT: int = 28   # 받침 종류 수 (받침 없음 포함)
const RIEUL: int = 8              # 받침 'ㄹ'의 번호

## 받침이 있을 때 쓰는 조사들
const BATCHIM_FORMS: Array[String] = ["이", "을", "은", "과", "으로"]

## {이름} 뒤에 붙일 수 있는 조사 표시
const TEMPLATE_PATTERN: String = "\\{(\\w+)\\}(이/가|가/이|을/를|를/을|은/는|는/은|와/과|과/와|으로/로|로/으로)?"


## 단어 뒤에 알맞은 조사를 붙여서 돌려준다.
static func attach(word: String, pair: String) -> String:
	return word + pick(word, pair)


## 단어에 맞는 조사만 돌려준다. pair는 "이/가"처럼 빗금으로 나눈 두 개.
static func pick(word: String, pair: String) -> String:
	var parts: PackedStringArray = pair.split("/")
	if parts.size() != 2:
		return pair
	var with_batchim: String = parts[0] if BATCHIM_FORMS.has(parts[0]) else parts[1]
	var without_batchim: String = parts[1] if with_batchim == parts[0] else parts[0]

	var jong: int = _last_jongseong(word)
	if jong < 0:
		# 영어 이름 등 받침을 알 수 없을 때: "이(가)", "(으)로"처럼 둘 다 보여 준다.
		if with_batchim == "으로":
			return "(으)로"
		return with_batchim + "(" + without_batchim + ")"
	if with_batchim == "으로" and jong == RIEUL:
		return without_batchim  # ㄹ 받침 뒤에는 "로" (예: 서울로)
	return with_batchim if jong > 0 else without_batchim


## 글 안의 {변수}를 값으로 바꾸고, 바로 뒤에 "이/가" 같은 표시가 있으면 알맞은 조사로 바꾼다.
## values에 없는 변수는 그대로 남긴다(빠진 것을 찾기 쉽게).
static func fill_template(text: String, values: Dictionary) -> String:
	var regex: RegEx = RegEx.create_from_string(TEMPLATE_PATTERN)
	var result: String = ""
	var last_end: int = 0
	for found: RegExMatch in regex.search_all(text):
		result += text.substr(last_end, found.get_start() - last_end)
		var key: String = found.get_string(1)
		if values.has(key):
			var word: String = str(values[key])
			var josa_pair: String = found.get_string(2)
			result += word if josa_pair.is_empty() else attach(word, josa_pair)
		else:
			result += found.get_string(0)
		last_end = found.get_end()
	result += text.substr(last_end)
	return result


## 마지막 글자의 받침 번호. 0 = 받침 없음, 1 이상 = 받침 있음, -1 = 알 수 없음(영어 등).
static func _last_jongseong(word: String) -> int:
	var trimmed: String = word.strip_edges()
	if trimmed.is_empty():
		return -1
	var code: int = trimmed.unicode_at(trimmed.length() - 1)
	if code >= HANGUL_START and code <= HANGUL_END:
		return (code - HANGUL_START) % JONGSEONG_COUNT
	# 숫자는 한국어로 읽는 소리 기준 (일, 칠, 팔 = ㄹ 받침 / 영, 삼, 육 = 받침 있음)
	var last_char: String = trimmed.right(1)
	if "178".contains(last_char):
		return RIEUL
	if "036".contains(last_char):
		return 1
	if "2459".contains(last_char):
		return 0
	return -1
