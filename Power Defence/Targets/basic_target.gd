extends PathFollow2D

var speed = 0.05
var dmg = 7

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	set_unit_offset(get_unit_offset()+speed*delta)
	
	if get_unit_offset() >= 0.99:
		get_parent().get_parent().take_dmg(dmg)
		get_parent().get_parent().killed_target()
		queue_free()
	
func hit():
	get_parent().get_parent().killed_target()
	queue_free()
