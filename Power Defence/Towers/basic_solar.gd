extends Area2D

var name = "Solar Tower"
var energy_cost = 1
var build_cost = 1
var energy_generation = 5
var activated = false
var dmg = 0

var powered = true
var generating = false
var ready = false


var animation

func _ready():
	get_node("generator_timer").connect("timeout", self, "generated");
	animation = get_node("AnimationPlayer")
	pass
	
func _fixed_process(delta):
	if (!powered && generating):
		generating = false
		animation.play("power off")
	
	if (!activated || !powered):
		return
	
	if (!generating && !ready):
		generating = true
		get_node("generator_timer").set_wait_time(rand_range(45, 90))
		get_node("generator_timer").start()
		animation.play("generating")
		
func generated():
	if (!activated || !powered):
		return 
	generating = false
	ready = true
	get_node("SamplePlayer").play("power_ready")
	animation.play("created")
	get_node("Sprite").set_frame(6)
	
func collect():
	ready = false
	get_node("Sprite").set_frame(0)
	get_node("SamplePlayer").play("power_0" + str(floor(rand_range(1,4))))
	animation.play("power off")

func activate():
	activated = true
	set_fixed_process(true)
	pass