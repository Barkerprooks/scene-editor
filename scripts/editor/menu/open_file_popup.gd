extends PopupMenu


@onready var Editor = $/root/Editor


func show_scenes() -> void:
	clear()
	Editor.list_scenes().map(func(scene: String): add_item(scene))
	popup()


func index_pressed(index: int):
	Editor.load_scene(get_item_text(index))


func _ready() -> void:
	connect("index_pressed", index_pressed)
