extends Label

func alert(text: String) -> void:
	self.text = text
	await get_tree().create_timer(5.0).timeout
	self.text = ''

func error(text: String) -> void:
	self.add_theme_color_override("font_color", Color.CRIMSON)
	await alert(text)
	self.remove_theme_color_override("font_color")
