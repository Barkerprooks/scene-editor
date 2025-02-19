extends Label

var messages: PackedStringArray = []

func __display_text(string: String) -> void:
	messages.append(string)
	text = "\n".join(messages)
	await get_tree().create_timer(3.0).timeout
	messages.remove_at(0)
	text = "\n".join(messages)

func alert(string: String) -> void:
	__display_text(string)

func error(string: String) -> void:
	__display_text("error: %s" % string)
