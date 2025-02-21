extends Control


const SCENE_PATH: String = "SceneEditor/Scenes"
const ACTOR_PATH: String = "SceneEditor/Assets/Actors"
const BACKGROUND_PATH: String = "SceneEditor/Assets/Backgrounds"

static func create_new_page() -> Dictionary: return { "dialogue": "", "actors": [] }
static func create_new_scene() -> Dictionary: return { 
	"background": "",
	"title": "untitled", 
	"pages": [ create_new_page() ],
}

# current scene in memory
var index: int = 0
var scene: Dictionary
var page: Dictionary

# scene UI objects
@onready var count: Label = $UI/HeaderMargins/Header/Inputs/Page
@onready var title: LineEdit = $UI/HeaderMargins/Header/Inputs/TitleInput
@onready var dialogue: Label = $UI/Body/Panels/PagePanels/Page/Overlay/TextMargin/DialogueBox
@onready var dialogue_editor: TextEdit = $UI/Body/Panels/PagePanels/PageInputs/DialogueMargins/DialogueEditor


func debug(text: String) -> void:
	$Alert.alert(text)
	print(text)


func error(text: String) -> void:
	$Alert.error(text)
	print_debug(text)


func __get_data_path(path: String) -> String:
	var data_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).path_join(path)
	if not DirAccess.dir_exists_absolute(data_path):
		debug("created data folder %" % data_path)
		DirAccess.make_dir_recursive_absolute(data_path)
	return data_path


func __sync_scene() -> void:
	dialogue_editor.release_focus()
	title.release_focus()
	# syncs the scene UI with whatever is in the 'scene' dictionary
	# check to make sure we have the correct format
	for key in create_new_scene().keys():
		if key not in scene:
			error("invalid scene format, no %s key, talk to Parker" % key)
			return
	
	if len(scene["pages"]) == 0:
		error("invalid format, pages exist but the list is empty")
		return
	
	page = scene["pages"][index]
	
	for key in create_new_page().keys():
		if key not in page:
			error("invalid page format, no %s key, talk to Parker" % key)
			return
	
	title.text = scene["title"]
	count.text = "%s / %s" % [(index + 1), len(scene["pages"])]
	
	dialogue.text = page["dialogue"]
	dialogue_editor.text = page["dialogue"]
	
	# load background image
	load_background(scene["background"])


func __save_scene(path: String) -> void:
	if not path.ends_with(".json"):
		path = ".".join([path, "json"])

	# sync filename and scene title
	var filename = path.get_file().split('.')[0]
	if filename != scene["title"]:
		scene["title"] = filename
		__sync_scene()

	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(scene))
	
	debug("Saved: %s" % path)


func __set_scene_title(scene_name: String) -> void:
	for symbol in ['<', '>', ':', '"', "/", "\\", "|", "?", "*"]:
		if scene_name.contains(symbol):
			error("Error: Invalid symbol in title: '%s' - Try using a different one?" % symbol)
			return
	
	debug("Set scene title: %s" % scene_name)
	scene["title"] = scene_name


func __set_dialogue_text() -> void:
	scene["pages"][index]["dialogue"] = dialogue_editor.text
	dialogue.text = dialogue_editor.text


func new_scene() -> void:
	index = 0 # reset view to first page
	scene = create_new_scene()
	__sync_scene()


func open_scene() -> void:
	$LoadScene.show_scenes()
	index = 0 # reset view to first page


func save_scene() -> void:
	if scene["title"] == "untitled":
		debug("Set the scene title before you save")
		return
	
	var path: String = __get_data_path(SCENE_PATH)
	var file: String = ".".join([scene["title"], "json"])
	__save_scene(path.path_join(file))


func list_scenes() -> Array:
	var files = Array(DirAccess.get_files_at(__get_data_path(SCENE_PATH)))
	return files.map(func(file: String): return file.trim_suffix(".json"))


func load_scene(scene_name: String) -> void:
	var path: String = __get_data_path(SCENE_PATH).path_join(scene_name) + ".json"
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	
	if not file:
		debug("file not found, talk to Parker")
		return
	
	self.scene = JSON.parse_string(file.get_as_text())
	__sync_scene()


func import_background(path: String) -> void:
	# copy background asset into the asset folder
	if not FileAccess.file_exists(path):
		error("Error: file does not exist")
	
	var filename = path.get_file()
	var destination = __get_data_path(BACKGROUND_PATH).path_join(filename)
	DirAccess.copy_absolute(path, destination)
	
	debug("imported background image: %s" % filename)
	load_background(filename)


func list_backgrounds() -> Array:
	return Array(DirAccess.get_files_at(__get_data_path(BACKGROUND_PATH)))


func load_background(background: String) -> void:
	var image: Image = Image.new()
	var path: String = __get_data_path(BACKGROUND_PATH).path_join(background)
	
	if FileAccess.file_exists(path):
		scene["background"] = background
		image.load(path)
	else:
		image = Image.create_empty(800, 600, false, Image.FORMAT_RGBF)
		image.fill(Color.BLACK)
		
	$UI/Body/Panels/PagePanels/Page/Background.texture.set_image(image)


func next_page() -> void:
	index += 1
	if index == len(scene["pages"]):
		scene["pages"].append(create_new_page())
		page = create_new_page()
	__sync_scene()


func last_page() -> void:
	index -= 1
	__sync_scene()


func delete_page() -> void:
	if index > 0:
		scene["pages"].remove_at(index)
		index -= 1
	else:
		scene["pages"][0] = create_new_page()
	__sync_scene()


func _ready() -> void:
	dialogue_editor.connect("text_changed", __set_dialogue_text)
	title.connect('text_submitted', __set_scene_title)
	new_scene()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Save"):
		dialogue_editor.release_focus()
		title.release_focus()
		save_scene()
