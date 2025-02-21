extends PopupMenu


@onready var ImportBackgroundDialog = $/root/Editor/ImportBackgroundDialog
@onready var Editor = $/root/Editor


func index_pressed(index: int) -> void:
	if index == 0:
		ImportBackgroundDialog.popup()
		return
	
	var string = get_item_text(index)
	Editor.debug("loading background %s" % string)
	Editor.load_background(string)


func about_to_popup() -> void:
	var backgrounds = Editor.list_backgrounds()
	clear()
	add_item("import background image")
	if len(backgrounds) > 0:
		add_separator()
		for filename in backgrounds:
			add_item(filename)


func _ready() -> void:
	connect("about_to_popup", about_to_popup)
	connect("index_pressed", index_pressed)
