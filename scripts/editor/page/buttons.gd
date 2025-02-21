extends VBoxContainer


@onready var Editor = $/root/Editor


func _ready() -> void:
	$Next.connect("pressed", Editor.next_page)
	$Back.connect("pressed", Editor.last_page)
	$Delete.connect("pressed", Editor.delete_page)


func _process(_delta: float) -> void:
	$Next.disabled = Editor.dialogue_editor.text == ''
	$Next.text = "add" if Editor.index == len(Editor.scene["pages"]) - 1 else "next"
	$Back.disabled = Editor.index == 0
	$Delete.disabled = $Next.disabled and $Back.disabled
	$Delete.text = "clear" if Editor.index == 0 else "delete"
