extends LineEdit


@onready var Editor = preload("res://scripts/editor/editor.gd")


func _ready() -> void:
	$EditTitle.connect("pressed", func(): Editor.__set_scene_title(text))


func _process(delta: float) -> void:
	if Editor.scene["title"] == text:
		$EditTitle.visible = false
	else:
		$EditTitle.visible = true
