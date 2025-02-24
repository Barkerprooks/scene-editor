extends PopupMenu


@onready var Editor = $/root/Editor


func import_from_path(path: String) -> void:
	# this fixes the issue of the window closing immediately
	connect('popup_hide', popup, CONNECT_DEFERRED | CONNECT_ONE_SHOT)
	
	$Title.text = path.get_file()
	
	
	for pose in ["normal", "happy", "sad", "mad"]:
		var menu_list = MenuButton.new()
		var filenames = DirAccess.get_files_at(path)
		for filename in filenames:
			menu_list.get_popup().add_item(filename)
		add_child(menu_list.duplicate(true))
	
	popup_centered()
