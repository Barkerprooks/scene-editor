extends VBoxContainer


@onready var Editor = preload("res://scripts/editor/editor.gd")


@onready var next = $Next
@onready var back = $Back
@onready var delete = $Delete


func _ready() -> void:
	next.connect("pressed", func(): Editor.next_page())
	back.connect("pressed", func(): Editor.last_page())
	delete.connect("pressed", func(): Editor.delete_page())


func _process(delta: float) -> void:
	next.disabled = Editor.dialogue_edit.text == ''
	next.text = "ADD PAGE" if Editor.page_index == len(Editor.scene["pages"]) - 1 else "NEXT"
	back.disabled = Editor.page_index == 0
	delete.disabled = next.disabled and back.disabled
	delete.text = "CLEAR" if Editor.page_index == 0 else "DELETE"
