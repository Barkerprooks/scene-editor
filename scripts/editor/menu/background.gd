extends PopupMenu


@onready var Editor = preload("res://scripts/editor/editor.gd")


func __index_pressed(index: int) -> void:
	var string = get_item_text(index)
	
	if index == 0:
		Editor.import_background()
	else:
		Editor.debug("loading background %s" % string)
		Editor.load_background(string)


func set_background_list() -> void:
	var backgrounds = Editor.list_backgrounds()
	clear()
	add_item("import")
	if len(backgrounds) > 0:
		add_separator()
		for filename in backgrounds:
			add_item(filename)


func _ready() -> void:
	set_background_list()
	self.connect("index_pressed", __index_pressed)
