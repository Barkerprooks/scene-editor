extends FileDialog

@onready var Editor = $/root/Editor

func _ready() -> void:
	connect("file_selected", Editor.import_background)
