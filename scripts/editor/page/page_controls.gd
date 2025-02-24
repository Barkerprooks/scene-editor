extends VBoxContainer


@onready var Editor = $/root/Editor


func load_actors(menu_button: MenuButton) -> void:
	var popup = menu_button.get_popup()
	popup.clear()
	popup.add_item("none")
	for actor in Editor.list_actors():
		popup.add_item(actor)


func _ready() -> void:
	$LActor.get_popup().connect("about_to_popup", func(): load_actors($LActor))
	$RActor.get_popup().connect("about_to_popup", func(): load_actors($RActor))


func _process(_delta: float) -> void:
	print($LActor.get_popup().get_focused_item())
	$LPose.disabled = $LActor.get_popup().get_focused_item() == 0
