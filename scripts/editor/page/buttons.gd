extends VBoxContainer


@onready var Editor = $/root/Editor
@onready var DialogueEditor = $/root/Editor/UI/Body/Panels/PagePanels/PageInputs/DialogueMargins/DialogueEditor


func _ready() -> void:
	$Next.connect("pressed", Editor.next_page)
	$Back.connect("pressed", Editor.last_page)
	$Delete.connect("pressed", Editor.delete_page)


func _process(_delta: float) -> void:
	var is_first_page: bool = Editor.is_first_page()
	
	$Next.disabled = DialogueEditor.text == ''
	$Next.text = "add" if Editor.is_last_page() else "next"
	$Back.disabled = is_first_page
	$Delete.disabled = $Next.disabled and $Back.disabled
	$Delete.text = "clear" if is_first_page else "delete"
