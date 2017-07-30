extends Area2D

var target
var speed = 150
var dmg = 10
var dead = false

func _ready():
	set_fixed_process(true)
	connect("area_enter", self, "attack")
	pass
	
func _fixed_process(delta):
	if (dead):
		if (!get_node("AnimationPlayer").is_playing()):
			queue_free()
		return

	var vector = (target - get_pos()).normalized()
	set_pos(get_pos() + vector * speed * delta)
	if (get_pos().distance_to(target) < 5):
		get_node("AnimationPlayer").play("death")
		get_node("SamplePlayer").play("explode_0" + str(floor(rand_range(1,4))))
		dead = true

func attack(body):
	if (body.get_name().find("target") == -1 || dead):
		return 
	body.get_parent().hit(dmg)
	dead = true
	Globals.get("currentCamera").shake(rand_range(5, 7), rand_range(1, 5))
	get_node("AnimationPlayer").play("death")
	get_node("SamplePlayer").play("explode_0" + str(floor(rand_range(1,4))))
	
func set_target(p_target):
	target = p_target