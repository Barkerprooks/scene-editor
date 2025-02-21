extends FileDialog


func import_file(callback: Callable) -> void:
	file_mode = FILE_MODE_OPEN_FILE
	filters = ['*.png,*.jpg,*.jpeg,*.gif,*.svg']
	for connection in get_signal_connection_list("file_selected"):
		disconnect(connection["signal"].get_name(), connection["callable"])
	connect("file_selected", callback)
	popup_centered()


func import_folder(callback: Callable) -> void:
	file_mode = FILE_MODE_OPEN_DIR
	filters = []
	for connection in get_signal_connection_list("dir_selected"):
		disconnect(connection["signal"].get_name(), connection["callable"])
	connect("dir_selected", callback)
	popup_centered()
