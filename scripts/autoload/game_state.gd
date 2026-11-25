extends Node
## 게임 상태 (Autoload 이름: GameState)
## 장면이 바뀌어도 사라지면 안 되는 값을 모아 두는 곳.
## 0단계에서는 뼈대만 만든다. 가방, 시계, 배고픔 등은 해당 단계에서 추가한다.

signal energy_changed(energy: int, max_energy: int)
signal coins_changed(coins: int)

## 시작 값 (나중에 Resource로 옮겨 인스펙터에서 조절할 예정)
const START_MAX_ENERGY: int = 5

var max_energy: int = START_MAX_ENERGY
var energy: int = START_MAX_ENERGY
var has_wound: bool = false
var coins: int = 0
## 이벤트 진행 기록. 예: flags["rat_cutscene_seen"] = true
var flags: Dictionary = {}


## 새 게임을 시작할 때 모든 값을 처음으로 되돌린다.
func reset() -> void:
	max_energy = START_MAX_ENERGY
	energy = START_MAX_ENERGY
	has_wound = false
	coins = 0
	flags.clear()
	energy_changed.emit(energy, max_energy)
	coins_changed.emit(coins)


func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value


func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false) == true
