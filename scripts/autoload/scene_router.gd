extends Node
## 장면 이동 담당 (Autoload 이름: SceneRouter)
## 다른 층이나 맵으로 갈 때 사용한다. 어느 문으로 들어왔는지 기억해서
## 새 맵에서 그 문 앞에 플레이어를 세울 수 있게 한다. (실제 배치는 층 이동 단계에서)

## 새 맵에서 플레이어가 나타날 위치 이름 (예: "stairs_from_3f")
var spawn_point_name: String = ""
## 직전 맵 경로 (돌아갈 때 사용)
var previous_scene_path: String = ""


func go_to(scene_path: String, new_spawn_point_name: String = "") -> void:
	var current: Node = get_tree().current_scene
	if current != null:
		previous_scene_path = current.scene_file_path
	spawn_point_name = new_spawn_point_name
	var error: Error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("장면을 열 수 없음: " + scene_path)
