extends PopupMenu


@onready var Editor = get_node("/root/Editor")


func __index_pressed(index: int):
	Editor.__load_scene(get_item_text(index))


func _ready() -> void:
	Editor.list_scenes().map(func(scene: String): add_item(scene))
	connect("index_pressed", __index_pressed)
