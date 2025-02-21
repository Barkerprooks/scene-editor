extends PopupMenu

@onready var Editor = $/root/Editor

func id_pressed(id: int) -> void:
	match id:
		0: $/root/Editor/ImportDialog.import_folder(Editor.import_actor)

func _ready() -> void:
	connect("id_pressed", id_pressed)
