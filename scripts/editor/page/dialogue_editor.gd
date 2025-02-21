extends TextEdit


@onready var Editor = $/root/Editor


func _ready() -> void:
	text = Editor.get_page_dialogue()


func _input(_event: InputEvent) -> void:
	$/root/Editor/UI/Body/Panels/PagePanels/Page/Overlay/TextMargin/DialogueBox.text = text
	Editor.set_page_dialogue(text)
