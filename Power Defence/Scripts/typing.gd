extends Panel

var new = true
var typing = 0

signal finished_typing
signal next_text

func _ready():
	get_node("Button").connect("pressed", self, "next")


func show_text(text):
	if (!get_parent().get_node("SamplePlayer").is_voice_active(typing)):
		typing = get_parent().get_node("SamplePlayer").play("typing")
	if new:
		get_node("RichTextLabel").set_visible_characters(0)
		get_node("Button").set_disabled(true)
		get_node("Timer").start()
		get_node("RichTextLabel").clear()
		get_node("RichTextLabel").add_text(text)
		typing = get_parent().get_node("SamplePlayer").play("typing")
		new = false
	yield(get_node("Timer"), "timeout")
	get_node("RichTextLabel").set_visible_characters(get_node("RichTextLabel").get_visible_characters()+1)
	if (get_node("RichTextLabel").get_visible_characters() == text.length()):
		get_node("Timer").stop()
		get_parent().get_node("SamplePlayer").stop(typing)
		new = true
		get_node("Button").set_disabled(false)
		emit_signal("finished_typing")
	else:
		show_text(text)
		
func next():
	emit_signal("next_text")