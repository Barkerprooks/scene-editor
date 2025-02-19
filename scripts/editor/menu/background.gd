extends PopupMenu


@onready var Editor = preload("res://scripts/editor/editor.gd")


func __index_pressed(index: int) -> void:
	var item_text = get_item_text(index)
	Editor.debug("loading background %s" % item_text)
	Editor.load_background(item_text)


func set_background_list() -> void:
	clear()
	for filename in Editor.list_backgrounds():
		add_item(filename)


func _ready() -> void:
	set_background_list()
	self.connect("index_pressed", __index_pressed)
