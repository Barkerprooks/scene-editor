extends Control


const BACKGROUND_PATH: String = "SceneEditor/Assets/Backgrounds"
const ACTOR_PATH: String = "SceneEditor/Assets/Actors"
const SCENE_PATH: String = "SceneEditor/Scenes"


static func create_new_page() -> Dictionary: return { 
	"dialogue": "", "actors": [] 
}

static func create_new_scene() -> Dictionary: return { 
	"background": "",
	"title": "untitled", 
	"pages": [ create_new_page() ],
}


# current scene in memory and the current page
var __scene: Dictionary = create_new_scene() # start with empty scene
var __page: int = 0


func get_page_count() -> int:
	return len(__scene["pages"])


func get_scene_title() -> String:
	return __scene["title"]
	

func set_scene_title(value: String) -> void:
	for symbol in ['<', '>', ':', '"', "/", "\\", "|", "?", "*"]:
		if value.contains(symbol):
			error("Error: Invalid symbol in title: '%s' - Try using a different one?" % symbol)
			return
	__scene["title"] = value


func get_scene_background() -> String:
	return __scene["background"]


func set_scene_background(value: String) -> void:
	__scene["background"] = value


func get_page_data() -> Dictionary:
	return __scene["pages"][__page]


func remove_page(page: int) -> void:
	__scene["pages"].remove_at(page)


func get_page_actors() -> String:
	return __scene["pages"][__page]["actors"]


func get_page_dialogue() -> String:
	return __scene["pages"][__page]["dialogue"]


func set_page_dialogue(value: String) -> void:
	__scene["pages"][__page]["dialogue"] = value


func is_last_page() -> bool:
	return __page == len(__scene["pages"]) - 1
	

func is_first_page() -> bool:
	return __page == 0


func alert(text: String) -> void:
	$Alert.alert(text)
	print(text)


func error(text: String) -> void:
	$Alert.error(text)
	print_debug(text)


func __get_data_path(path: String) -> String:
	var data_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).path_join(path)
	if not DirAccess.dir_exists_absolute(data_path):
		alert("creating data folder %" % data_path)
		DirAccess.make_dir_recursive_absolute(data_path)
	return data_path


func reset_focus() -> void:
	$UI/Body/Panels/PagePanels/PageInputs/DialogueMargins/DialogueEditor.release_focus()
	$UI/HeaderMargins/Header/Inputs/TitleInput.release_focus()


func sync_scene() -> void:
	reset_focus() # reset focus on all UI elements that support it
	
	# check to make sure we have the correct format
	for key in create_new_scene().keys():
		if key not in __scene:
			error("invalid scene format, no %s key, talk to Parker" % key)
			return
	
	if len(__scene["pages"]) == 0: # if this is somehow wrong, we should fix it
		__scene["pages"].append(create_new_page())
	
	# check to see if all the pages are valid
	for key in create_new_page().keys():
		for page in __scene["pages"]:
			if key not in page:
				error("invalid page format, no %s key, talk to Parker" % key)
				return
	
	# load all the text based content of the current page into the UI
	sync_metadata()
	
	# load background image into the UI
	sync_background()


func sync_metadata() -> void:
	$UI/HeaderMargins/Header/Inputs/TitleInput.text = get_scene_title()
	$UI/HeaderMargins/Header/Inputs/Page.text = "%s / %s" % [(__page + 1), get_page_count()]
	$UI/Body/Panels/PagePanels/Page/Overlay/TextMargin/DialogueBox.text = get_page_dialogue()
	$UI/Body/Panels/PagePanels/PageInputs/DialogueMargins/DialogueEditor.text = get_page_dialogue()


func sync_background() -> void:
	var image: Image = Image.new()
	var path: String = __get_data_path(BACKGROUND_PATH).path_join(get_scene_background())
	
	if FileAccess.file_exists(path):
		image.load(path)
	else:
		image = Image.create_empty(800, 600, false, Image.FORMAT_RGBF)
		image.fill(Color.BLACK)

	$UI/Body/Panels/PagePanels/Page/Background.texture.set_image(image)


func unedited() -> bool:
	var title: String = get_scene_title()
	var filename: String = ".".join([title, "json"])
	var filehash: String = FileAccess.get_md5(__get_data_path(SCENE_PATH).path_join(filename))
	if not filehash and title == "untitled":
		return true # new scene
	return filehash == JSON.stringify(__scene).md5_text()
	

func new_scene() -> void:
	alert("opening a new scene")
	__scene = create_new_scene()
	__page = 0
	sync_scene()


func open_scene() -> void:
	alert("opening a scene")
	$OpenScene.show_scenes()


func save_scene() -> void:
	alert("saving scene")
	var title: String = get_scene_title()
	
	if title == "untitled":
		alert("Set the scene title before you save")
		return
	
	var path: String = __get_data_path(SCENE_PATH)
	var filename: String = ".".join([title, "json"])
	
	var file = FileAccess.open(path.path_join(filename), FileAccess.WRITE)
	file.store_string(JSON.stringify(__scene))
	file.close()


func list_scenes() -> Array:
	var files = Array(DirAccess.get_files_at(__get_data_path(SCENE_PATH)))
	return files.map(func(file: String): return file.trim_suffix(".json"))


func load_scene(title: String) -> void:
	alert("loading scene: %s" % title)
	var path: String = __get_data_path(SCENE_PATH).path_join(title) + ".json"
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	
	if not file:
		alert("file not found, talk to Parker")
		return
	
	__scene = JSON.parse_string(file.get_as_text())
	__page = 0 # reset the page to the first page
	sync_scene()


func import_background(path: String) -> void:
	alert("importing background image: %s" % path)
	
	# copy background asset into the asset folder
	if not FileAccess.file_exists(path):
		error("Error: file does not exist")
		return
	
	var filename = path.get_file()
	var destination = __get_data_path(BACKGROUND_PATH).path_join(filename)
	DirAccess.copy_absolute(path, destination)
	
	set_scene_background(filename) # go ahead and set the background while
	sync_background() # updating the UI


func list_backgrounds() -> Array:
	return Array(DirAccess.get_files_at(__get_data_path(BACKGROUND_PATH)))


func list_actors() -> Array:
	return Array(DirAccess.get_directories_at(__get_data_path(ACTOR_PATH)))


func import_actor(path: String) -> void:
	alert("importing a new actor: %s" % path.get_file())
	if not DirAccess.dir_exists_absolute(path):
		error("actor folder not found")
		return

	$ImportActor.popup()


func copy_actor_files(actor: Dictionary) -> void:
	var path: String = __get_data_path(ACTOR_PATH).path_join(actor["name"])
	if not DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_recursive_absolute(path)
	
	var file: FileAccess = FileAccess.open(path.path_join("actor.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify(actor))
	file.close()
	
	alert("saved %s" % path.path_join("actor.json"))


func next_page() -> void:
	__page += 1
	if __page == get_page_count():
		__scene["pages"].append(create_new_page())
	sync_scene()


func last_page() -> void:
	__page -= 1
	sync_scene()


func delete_page() -> void:
	if __page > 0:
		remove_page(__page)
		__page -= 1
	else: # if it's the first page we just clear it
		__scene["pages"][0] = create_new_page()
	sync_scene()


func _ready() -> void:
	sync_scene()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Save"):
		reset_focus()
		save_scene()
