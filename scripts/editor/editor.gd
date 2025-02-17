extends Control


const SCENE_PATH: String = "SceneEditor/Scenes"
const ACTOR_PATH: String = "SceneEditor/Assets/Actors"
const BACKGROUND_PATH: String = "SceneEditor/Assets/Backgrounds"

static var scene: Dictionary = { "title": "untitled", "pages": [] }

static var open_file_dialog: FileDialog
static var save_file_dialog: FileDialog

static var background: ImageTexture
static var title: LineEdit


static func __get_data_path(path: String) -> String:
	var data_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).path_join(path)
	if not DirAccess.dir_exists_absolute(data_path):
		print_debug("created scenes folder at %s" % data_path)
		DirAccess.make_dir_recursive_absolute(data_path)
	return data_path


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
	title.text = "untitled"
	# background.create_placeholder()


static func save_scene() -> void:
	var path: String = __get_data_path(SCENE_PATH)
	var file: String = ".".join([scene["title"], "json"])
	__dump_scene(path.path_join(file))


static func save_scene_as() -> void:
	open_file_dialog.filters = ["*.json"]
	save_file_dialog.current_dir = __get_data_path(SCENE_PATH)
	save_file_dialog.connect("file_selected", __dump_scene)
	save_file_dialog.popup()


static func open_scene() -> void:
	open_file_dialog.filters = ["*.json"]
	open_file_dialog.current_dir = __get_data_path(SCENE_PATH)
	open_file_dialog.connect("file_selected", __load_scene)
	open_file_dialog.popup()


static func __load_background_asset(path: String) -> void:
	var image: Image = Image.new()
	image.load(path)
	background.set_image(image)


static func import_background() -> void:
	open_file_dialog.filters = ["*.png,*.jpg,*.jpeg,*.gif,*.svg"]
	open_file_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	open_file_dialog.connect("file_selected", __load_background_asset)
	open_file_dialog.popup()


func _ready() -> void:
	open_file_dialog = $OpenFileDialog
	save_file_dialog = $SaveFileDialog

	title = $HSplit/Header/HSplit/TitleInput
	title.text = scene["title"]

	background = $HSplit/Body/HSplit/VSplit/Background.texture
