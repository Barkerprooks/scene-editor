extends Popup


@onready var Editor = $/root/Editor
@onready var Confirm = $VSplit/Confirm


var actor: Dictionary = {
	"name": "",
	"poses": {}
}


func clear_menu_buttons() -> void:
	for item in $VSplit/Items.get_children():
		$VSplit/Items.remove_child(item)


func set_actor_name(value: String) -> void:
	$VSplit/ActorName.text = value
	actor["name"] = value


func select_pose(index: int, value: String, menu_button: MenuButton) -> void:
	var image = menu_button.get_popup().get_item_text(index)
	actor["poses"][value] = image
	menu_button.text = image


func add_pose_menu_button(files: PackedStringArray) -> void:
	var value: String = $VSplit/HSplit/NewPoseName.text.to_lower()
	var menu_button: MenuButton = MenuButton.new()
	var menu_label: Label = Label.new()
	var remove_button: Button = Button.new()
	var input: HSplitContainer = HSplitContainer.new()
	
	menu_label.text = "%s pose" % value
	menu_button.text = "< select %s pose >" % value
	remove_button.text = " x "
	
	add_options_to_menu_button(menu_button, files)
	
	input.dragger_visibility = SplitContainer.DRAGGER_HIDDEN_COLLAPSED
	input.add_child(menu_label)
	input.add_child(remove_button)
	
	menu_button.get_popup().connect('index_pressed', func(index: int): select_pose(index, value, menu_button))
	remove_button.connect('pressed', func(): input.remove_child(menu_label);  input.remove_child(remove_button); $VSplit/Items.remove_child(input); $VSplit/Items.remove_child(menu_button))
	
	menu_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_label.size_flags_stretch_ratio = 3
	
	$VSplit/Items.add_child(input)
	$VSplit/Items.add_child(menu_button)
	$VSplit/HSplit/NewPoseName.text = ''
	

func add_options_to_menu_button(menu_button: MenuButton, files: PackedStringArray) -> void:
	menu_button.get_popup().clear()
	for file in files:
		menu_button.get_popup().add_item(file)


func copy_actor_files() -> void:
	Editor.copy_actor_files(actor, title)
	hide()


func import_from_path(path: String) -> void:
	# this fixes the issue of the window closing immediately
	connect('popup_hide', popup, CONNECT_DEFERRED | CONNECT_ONE_SHOT)
	
	set_actor_name(path.get_file())
	title = path
	
	var files = DirAccess.get_files_at(path)
	
	clear_menu_buttons()
	$VSplit/HSplit/NewPose.connect("pressed", func(): add_pose_menu_button(files))
	
	Confirm.connect("pressed", copy_actor_files)
	
	popup_centered()
