# 화면 글자(UI) 추가하는 방법

화면에 보이는 글자는 코드나 씬에 직접 쓰지 않고 **번역 키**로 쓴다.

## 1. 키 이름 짓는 규칙

- 모두 **영어 대문자 + 밑줄**: `UI_BAG_TITLE`
- 앞부분으로 종류를 나눈다.

| 앞부분 | 쓰는 곳 | 예 |
|---|---|---|
| `UI_` | 버튼, 메뉴, 안내 | `UI_BACK`, `UI_BAG_TITLE` |
| `ITEM_` | 아이템 이름/설명 | `ITEM_CAN_NAME`, `ITEM_CAN_DESC` |
| `WEAPON_` | 무기 이름, 기합 | `WEAPON_BAT_NAME`, `WEAPON_BAT_SHOUT` |
| `FX_` | 3D 화면 글자(의성어) | `FX_GASP` (푸하! / GASP!) |
| `LANG_` | 언어 이름 (두 칸 모두 그 언어로) | `LANG_KO` |

## 2. ui.csv에 한 줄 추가

`data/translations/ui.csv` 맨 아래에 `키,한국어,영어` 순서로 한 줄을 넣는다.

```
UI_BAG_TITLE,가방,Bag
```

- 글자 안에 쉼표(,)가 있으면 큰따옴표로 감싼다: `UI_HINT,"조용히, 천천히","Quietly, slowly"`
- 저장하면 Godot가 자동으로 다시 가져온다(Import).

## 3. 씬이나 코드에서 쓰기

- **Label, Button**: 인스펙터의 `Text`에 키를 그대로 쓴다 → `UI_BAG_TITLE`
- **코드**: `tr("UI_BAG_TITLE")` → 지금 언어의 글자를 돌려준다.

## 대사(이야기 글자)는 따로

대사, 카톡, 메모는 `data/dialogue.json`에 넣는다. 이름이 들어가면 `{player_name}이/가`처럼 쓰면
`KoreanJosa.fill_template()`이 받침에 맞게 조사를 골라 준다.
