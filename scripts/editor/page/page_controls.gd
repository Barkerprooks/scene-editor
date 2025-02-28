extends VBoxContainer


@onready var Editor = $/root/Editor
@onready var LActor = $/root/Editor/UI/Body/Panels/PagePanels/Page/Background/Actors/LActor
@onready var RActor = $/root/Editor/UI/Body/Panels/PagePanels/Page/Background/Actors/RActor


func reload_poses(menu_button: MenuButton, actor: String = '') -> void:
	var popup = menu_button.get_popup()
	popup.clear()
	
	if actor:
		for pose in Editor.get_actor_poses(actor):
			popup.add_item(pose)


func reload_actors(menu_button: MenuButton) -> void:
	var popup = menu_button.get_popup()
	
	popup.clear()
	popup.add_item("< select actor >")
	for actor in Editor.list_actors():
		popup.add_item(actor)


func set_actor(index: int, actor_menu: MenuButton, pose_menu: MenuButton) -> void:
	var actor = actor_menu.get_popup().get_item_text(index)
	match index:
		0: 
			actor_menu.text = "< select actor >"
			reload_poses(pose_menu)
		_: 
			actor_menu.text = actor
			reload_poses(pose_menu, actor)


func set_l_actor_pose(index: int) -> void:
	var pose = $LPose.get_popup().get_item_text(index)
	$LPose.text = pose
	Editor.set_l_actor_pose($LActor.text, pose)


func set_r_actor_pose(index: int) -> void:
	var pose = $RPose.get_popup().get_item_text(index)
	$RPose.text = pose
	Editor.set_r_actor_pose($RActor.text, pose)


func _ready() -> void:
	$LActor.get_popup().connect("about_to_popup", func(): reload_actors($LActor))
	$LActor.get_popup().connect("index_pressed", func(index: int): set_actor(index, $LActor, $LPose))
	
	$LPose.get_popup().connect("index_pressed", set_l_actor_pose)
	
	$RActor.get_popup().connect("about_to_popup", func(): reload_actors($RActor))
	$RActor.get_popup().connect("index_pressed", func(index: int): set_actor(index, $RActor, $RPose))
	
	$RPose.get_popup().connect("index_pressed", set_r_actor_pose)
	
	$LFlipH.connect("toggled", func(toggled: bool): LActor.flip_h = toggled)
	$RFlipH.connect("toggled", func(toggled: bool): RActor.flip_h = toggled)
	
