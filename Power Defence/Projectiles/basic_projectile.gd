extends Area2D

var target
var target_pos
var speed = 150
var dmg = 10

func _ready():
	set_fixed_process(true)
	connect("area_enter", self, "attack")
	pass
	
func _fixed_process(delta):
	if (target.get_ref()):
		target_pos = target.get_ref().get_parent().get_pos();
		var vector = (target_pos - get_pos()).normalized()
		set_pos(get_pos() + vector * speed * delta)
	else:
		var vector = (target_pos - get_pos()).normalized()
		set_pos(get_pos() + vector * speed * delta)
		if (get_pos().distance_to(target_pos) < 5):
			queue_free()

func attack(body):
	if (body.get_name().find("target") == -1):
		return 
	body.get_parent().hit()
	queue_free()
	
func set_target(p_target):
	target = weakref(p_target)