extends Control


const SCENE_SAVE_PATH: String = "SceneEditor/Scenes"
const ASSET_SAVE_PATH: String = "SceneEditor/Assets"

static var scene: Dictionary = { "title": "untitled", "pages": [] }

static var open_file_dialog: FileDialog
static var save_file_dialog: FileDialog

static var title: Label


static func __get_scene_save_path() -> String:
	var scene_save_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).path_join(SCENE_SAVE_PATH)
	if not DirAccess.dir_exists_absolute(scene_save_path):
		print_debug("created scenes folder at %s" % scene_save_path)
		DirAccess.make_dir_recursive_absolute(scene_save_path)
	return scene_save_path


static func __load_scene(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	scene = JSON.parse_string(file.get_as_text())
	title.text = scene["title"]


static func __dump_scene(path: String) -> void:
	if not path.ends_with(".json"):
		path = ".".join([path, ".json"])
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(scene))


static func new_scene() -> void:
	scene = { "title": "untitled", "pages": [] }


static func save_scene() -> void:
	var scene_save_path: String = __get_scene_save_path()
	__dump_scene(scene_save_path.path_join(".".join([scene["title"], "json"])))


static func save_scene_as() -> void:
	save_file_dialog.current_dir = __get_scene_save_path()
	save_file_dialog.connect("file_selected", __dump_scene)
	save_file_dialog.popup()


static func open_scene() -> void:
	open_file_dialog.current_dir = __get_scene_save_path()
	open_file_dialog.connect("file_selected", __load_scene)
	open_file_dialog.popup()


static func __load_asset(path: String) -> void:
	pass


static func import_background() -> void:
	open_file_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	open_file_dialog.connect("file_selected", __load_asset)
	open_file_dialog.popup()


static func import_actor() -> void:
	pass


func _ready() -> void:
	open_file_dialog = $OpenFileDialog
	save_file_dialog = $SaveFileDialog
	title = $HSplitContainer/MarginContainer/Title
	title.text = scene["title"]
