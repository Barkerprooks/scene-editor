extends PopupMenu


@onready var Editor = $/root/Editor


func configure_actor(path: String) -> void:
	
	#var actor = path.get_file()
	#var files = DirAccess.get_files_at(path)
	
	#for file in files:
		#var menu = MenuButton.new()
		#for selection in files:
			#menu.text = selection
			#menu.get_popup().add_item(selection)
		#add_child(menu)
	
	#add_child(MenuButton.new())
	popup()
