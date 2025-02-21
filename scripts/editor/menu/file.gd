extends PopupMenu


@onready var Editor = $/root/Editor
@onready var LoadScene = $/root/Editor/LoadScene

func __file_button_pressed(id: int) -> void:
	match id:
		0: Editor.new_scene()
		1: Editor.open_scene()
		2: Editor.save_scene()
		_: get_tree().quit()


func _ready() -> void:
	connect("id_pressed", __file_button_pressed)


func _process(_delta: float) -> void:
	set_item_disabled(2, Editor.scene["title"] == "untitled")
