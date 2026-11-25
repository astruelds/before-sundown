extends Node
## 소리 방송국 (Autoload 이름: NoiseBus)
## 캔을 밟거나 배트를 휘두르는 등 "소리"가 나면 여기로 알리고,
## 좀비들은 이 신호를 듣고 소리 난 곳으로 간다.

## position: 소리가 난 3D 위치 / radius: 들리는 범위(미터) / global: true면 맵 전체 좀비가 반응
signal noise_made(position: Vector3, radius: float, global: bool)


## 어디서든 NoiseBus.make_noise(위치, 범위)로 소리를 알린다.
func make_noise(noise_position: Vector3, radius: float, is_global: bool = false) -> void:
	noise_made.emit(noise_position, radius, is_global)
