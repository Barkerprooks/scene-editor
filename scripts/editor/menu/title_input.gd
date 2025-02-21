extends LineEdit


@onready var Editor = $/root/Editor


func pressed() -> void:
	text_submitted(text)


func text_submitted(value: String) -> void:
	release_focus()
	Editor.set_scene_title(value)
	Editor.sync_metadata()


func _ready() -> void:
	$EditTitle.connect("pressed", pressed)
	connect("text_submitted", text_submitted)


func _process(_delta: float) -> void:
	if Editor.get_scene_title() == text:
		$EditTitle.visible = false
	else:
		$EditTitle.visible = true
