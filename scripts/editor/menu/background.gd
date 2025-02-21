extends PopupMenu


@onready var Editor = $/root/Editor


func about_to_popup() -> void:
	var backgrounds = Editor.list_backgrounds()
	clear()
	add_item("import background image")
	add_separator()
	if len(backgrounds) > 0:
		for filename in backgrounds:
			add_item(filename)
	else:
		add_item("no backgrounds found. try importing one")
		set_item_disabled(2, true)


func index_pressed(index: int) -> void:
	if index == 0:
		$/root/Editor/ImportDialog.import_file(Editor.import_background)
		return
	
	Editor.set_scene_background(get_item_text(index))
	Editor.sync_background()


func _ready() -> void:
	connect("about_to_popup", about_to_popup)
	connect("index_pressed", index_pressed)
