extends LineEdit


@onready var Editor = $/root/Editor


func _ready() -> void:
	$EditTitle.connect("pressed", func(): Editor.__set_scene_title(text))


func _process(_delta: float) -> void:
	if Editor.scene["title"] == text:
		$EditTitle.visible = false
	else:
		$EditTitle.visible = true
