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

static var page_index: int = 0
static var page: Dictionary
static var scene: Dictionary

# file system UI objects
static var open_file_dialog: FileDialog
static var save_file_dialog: FileDialog

# scene UI objects
static var alert: Label
static var page_count: Label
static var title: LineEdit

# scene UI
static var background: ImageTexture
static var l_actor: ImageTexture
static var r_actor: ImageTexture
static var dialogue: Label

# buttons to change scene looks
static var background_select: PopupMenu

# textbox for scene
static var dialogue_edit: TextEdit


static func debug(text: String) -> void:
	if alert: # if the UI element doesn't exist yet we can't really use it
		alert.alert(text)
		print_debug(text)


static func __get_data_path(path: String) -> String:
	var data_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).path_join(path)
	if not DirAccess.dir_exists_absolute(data_path):
		debug("created data folder at %s" % data_path)
		DirAccess.make_dir_recursive_absolute(data_path)
	return data_path


static func __sync_scene() -> void:
	title.release_focus()
	dialogue_edit.release_focus()
	# syncs the scene UI with whatever is in the 'scene' dictionary
	# check to make sure we have the correct format
	for key in create_new_scene().keys():
		if key not in scene:
			alert.error("invalid scene format, no %s key, talk to Parker" % key)
			return
	
	if len(scene["pages"]) == 0:
		alert.error("invalid format, pages exist but the list is empty")
		return
	
	page = scene["pages"][int(page_index)]
	
	for key in create_new_page().keys():
		if key not in page:
			alert.error("invalid page format, no %s key, talk to Parker" % key)
			return
	
	title.text = scene["title"]
	page_count.text = "%s / %s" % [(page_index + 1), len(scene["pages"])]
	dialogue.text = page["dialogue"]
	dialogue_edit.text = page["dialogue"]
	
	# load background image
	load_background(scene["background"])
	
	#var l_actor_image = Image.create_empty(400, 400, false, Image.FORMAT_RGBH)
	#var r_actor_image = Image.create_empty(400, 400, false, Image.FORMAT_RGBH)
	#
	#l_actor.set_image(l_actor_image)
	#r_actor.set_image(r_actor_image)


static func __load_scene(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	scene = JSON.parse_string(file.get_as_text())

	__sync_scene()
	debug("Opened: %s" % path)


static func __save_scene(path: String) -> void:
	if not path.ends_with(".json"):
		path = ".".join([path, "json"])

	var filename = path.get_file().split('.')[0]
	if filename != scene["title"]:
		scene["title"] = filename
		__sync_scene()

	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(scene))
	
	debug("Saved: %s" % path)


static func __set_scene_title(scene_name: String) -> void:
	for symbol in ['<', '>', ':', '"', "/", "\\", "|", "?", "*"]:
		if scene_name.contains(symbol):
			alert.error("Error: Invalid symbol in title: '%s' - Try using a different one?" % symbol)
			return
	
	debug("Set scene title: %s" % scene_name)
	scene["title"] = scene_name


static func __set_dialogue_text() -> void:
	scene["pages"][page_index]["dialogue"] = dialogue_edit.text
	dialogue.text = dialogue_edit.text


static func new_scene() -> void:
	page_index = 0 # reset view to first page
	scene = create_new_scene()
	__sync_scene()


static func open_scene() -> void:
	page_index = 0 # reset view to first page
	
	open_file_dialog.filters = ["*.json"]
	open_file_dialog.current_dir = __get_data_path(SCENE_PATH)
	
	var connections = []
	for connection in open_file_dialog.get_signal_connection_list("file_selected"):
		connections.append(connection["callable"])
		if connection["callable"] == __import_background:
			open_file_dialog.disconnect("file_selected", __import_background)
	
	if __load_scene not in connections:
		open_file_dialog.connect("file_selected", __load_scene)
	
	open_file_dialog.popup()


static func save_scene() -> void:
	var path: String = __get_data_path(SCENE_PATH)
	var file: String = ".".join([scene["title"], "json"])
	__save_scene(path.path_join(file))



static func save_scene_as() -> void:
	open_file_dialog.filters = ["*.json"]
	save_file_dialog.current_dir = __get_data_path(SCENE_PATH)
	save_file_dialog.connect("file_selected", __save_scene)
	save_file_dialog.popup()


static func __import_background(path: String) -> void:
	# copy background asset into the asset folder
	if not FileAccess.file_exists(path):
		alert.error("Error: file does not exist")
	
	var filename = path.get_file()
	var destination = __get_data_path(BACKGROUND_PATH).path_join(filename)
	DirAccess.copy_absolute(path, destination)
	
	background_select.set_background_list()
	
	debug("imported background image: %s" % filename)
	load_background(filename)


static func import_background() -> void:
	open_file_dialog.filters = ["*.png,*.jpg,*.jpeg,*.gif,*.svg"]
	open_file_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	
	var connections = []
	for connection in open_file_dialog.get_signal_connection_list("file_selected"):
		connections.append(connection["callable"])
		if connection["callable"] == __load_scene:
			open_file_dialog.disconnect("file_selected", __load_scene)
	
	if __import_background not in connections:
		open_file_dialog.connect("file_selected", __import_background)
	
	open_file_dialog.popup()


static func list_backgrounds() -> PackedStringArray:
	return DirAccess.get_files_at(__get_data_path(BACKGROUND_PATH))


static func load_background(filename: String) -> void:
	var image: Image = Image.new()
	var path: String = __get_data_path(BACKGROUND_PATH).path_join(filename)
	
	if FileAccess.file_exists(path):
		scene["background"] = filename
		image.load(path)
	else:
		image = Image.create_empty(800, 600, false, Image.FORMAT_RGBF)
		image.fill(Color.BLACK)
		
	background.set_image(image)
	

static func next_page() -> void:
	page_index += 1
	if page_index == len(scene["pages"]):
		scene["pages"].append(create_new_page())
		page = create_new_page()
	__sync_scene()


static func last_page() -> void:
	page_index -= 1
	__sync_scene()


static func delete_page() -> void:
	if page_index > 0:
		scene["pages"].remove_at(page_index)
		page_index -= 1
	else:
		scene["pages"][0] = create_new_page()
	__sync_scene()


func _ready() -> void:
	open_file_dialog = $OpenFileDialog
	save_file_dialog = $SaveFileDialog

	alert = $Alert
	
	page_count = $UI/HeaderMargins/Header/Inputs/Page

	title = $UI/HeaderMargins/Header/Inputs/TitleInput
	title.connect('text_submitted', __set_scene_title)

	background = $UI/Body/Panels/PagePanels/Page/Background.texture
	l_actor = $UI/Body/Panels/PagePanels/Page/Background/Actors/LActor.texture
	r_actor = $UI/Body/Panels/PagePanels/Page/Background/Actors/RActor.texture
	
	dialogue = $UI/Body/Panels/PagePanels/Page/Overlay/TextMargin/DialogueBox
	
	dialogue_edit = $UI/Body/Panels/PagePanels/PageInputs/DialogueEditor
	dialogue_edit.connect("text_changed", __set_dialogue_text)

	background_select = $UI/HeaderMargins/Header/Inputs/MenuBar/Background

	new_scene()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Save"):
		
		title.release_focus()
		dialogue_edit.release_focus()
		
		if scene["title"] == "untitled":
			save_scene_as()
		else:
			save_scene()
