extends PopupMenu


@onready var Editor = $/root/Editor


func index_pressed(index: int) -> void:
	match index:
		0: Editor.new_scene()
		1: Editor.open_scene()
		2: Editor.save_scene()
		_: get_tree().quit()


func _ready() -> void:
	connect("index_pressed", index_pressed)


func _process(_delta: float) -> void:
	set_item_disabled(2, Editor.unedited())
