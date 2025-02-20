extends PopupMenu


@onready var Editor = preload("res://scripts/editor/editor.gd")


func __index_pressed(index: int) -> void:
	var string = get_item_text(index)
	
	if string == "import background" and index == 0:
		Editor.debug("importing background")
		Editor.import_background()
	else:
		Editor.debug("loading background %s" % string)
		Editor.load_background(string)


func set_background_list() -> void:
	clear()
	add_item("import background")
	add_separator()
	for filename in Editor.list_backgrounds():
		add_item(filename)


func _ready() -> void:
	set_background_list()
	self.connect("index_pressed", __index_pressed)
