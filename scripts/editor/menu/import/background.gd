extends FileDialog


func import_file(callback: Callable) -> void:
	current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	file_mode = FILE_MODE_OPEN_FILE
	filters = ['*.png,*.jpg,*.jpeg,*.gif,*.svg']
	connect("file_selected", callback, CONNECT_ONE_SHOT)
	popup_centered()


func import_folder(callback: Callable) -> void:
	current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	file_mode = FILE_MODE_OPEN_DIR
	filters = []
	connect("dir_selected", callback, CONNECT_ONE_SHOT)
	popup_centered()
