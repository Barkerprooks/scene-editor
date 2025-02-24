extends PopupMenu


@onready var Editor = $/root/Editor


func index_pressed(id: int) -> void:
	match id:
		0: $/root/Editor/ImportDialog.import_folder($/root/Editor/ImportActor.import_from_path)


func _ready() -> void:
	connect("index_pressed", index_pressed)
