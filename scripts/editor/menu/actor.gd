extends PopupMenu

@onready var Editor = $/root/Editor


func import_actor(value: String) -> void:
	pass

func index_pressed(id: int) -> void:
	match id:
		0: $/root/Editor/ImportDialog.import_folder(import_actor)

func _ready() -> void:
	connect("index_pressed", index_pressed)
