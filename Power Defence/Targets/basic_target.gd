extends PathFollow2D

var speed = 0.05
var dmg = 7

var health = 4

var dead = false

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if (dead):
		if (!get_node("AnimationPlayer").is_playing()):
			queue_free()
		return
	
	set_unit_offset(get_unit_offset()+speed*delta)
	
	if get_unit_offset() >= 0.99:
		get_parent().get_parent().get_node("SamplePlayer").play("hit_base")
		Globals.get("currentCamera").shake(rand_range(5, 7), rand_range(1, 5))
		
		get_parent().get_parent().take_dmg(dmg)
		get_parent().get_parent().killed_target()
		queue_free()
	
func hit(dmg):
	health -= dmg
	if health <= 0:
		get_parent().get_parent().killed_target()
		get_node("AnimationPlayer").play("death")
		dead = true
