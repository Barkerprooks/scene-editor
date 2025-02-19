extends PopupMenu


@onready var Editor = preload("res://scripts/editor/editor.gd")


func __import_button_pressed(id: int) -> void:
	match id:
		0: Editor.import_background()


func _ready() -> void:
	self.connect("id_pressed", __import_button_pressed)
