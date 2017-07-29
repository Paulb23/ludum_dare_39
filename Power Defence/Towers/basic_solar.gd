extends Area2D

var name = "Solar Tower"
var energy_cost = 1
var build_cost = 1
var energy_generation = 5
var activated = false

var powered = true
var generating = false
var ready = false

func _ready():
	get_node("generator_timer").connect("timeout", self, "generated");
	pass
	
func _fixed_process(delta):
	if (!powered && generating):
		generating = false
	
	if (!activated || !powered):
		return
	
	if (!generating && !ready):
		generating = true
		get_node("generator_timer").set_wait_time(rand_range(5, 10))
		get_node("generator_timer").start()
		
func generated():
	if (!activated || !powered):
		return 
	generating = false
	ready = true
	get_node("Sprite").set_frame(6)
	
func collect():
	ready = false
	get_node("Sprite").set_frame(0)

func activate():
	activated = true
	set_fixed_process(true)
	pass