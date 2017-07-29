extends PathFollow2D

var speed = 0.03

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	set_unit_offset(get_unit_offset()+speed*delta)
	
func hit():
	queue_free()
