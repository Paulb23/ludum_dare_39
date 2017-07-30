extends Area2D

var projectile = load("res://Projectiles/basic_projectile.tscn")

var name = "Fast Attack"
var activated = false
var has_target = false
var target_list = []
var target = null
var selected = false

var dmg = 2
var powered = true
var energy_cost = 12
var build_cost = 7
var energy_generation = 0

var area = CircleShape2D.new()

var fire_timer
var shoot_timer

func _ready():
	area.set_radius(32*3)
	get_node("CollisionShape2D").set_shape(area);

func _fixed_process(delta):
	if (!powered):
		get_node("AnimationPlayer").stop()
		get_node("Sprite").set_frame(4)
	
	if (!activated || !powered):
		return
	
	if (!has_target && target_list.size() > 0):
		target = target_list.back()
		if (target):
			has_target = true
		if (fire_timer.get_time_left() == 0):
			fire_timer.start()
			if (shoot_timer.get_time_left() == 0):
				shoot_timer.start()
				fire()
	if (!has_target and target_list.size() <= 0):
		fire_timer.stop()
	
	if (!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("powered")

func target_entered(body):
	if (body.get_name().find("target") == -1):
		return 
	target_list.push_back(body)
	
func target_exited(body):
	if (body.get_name().find("target") == -1):
		return 
	
	if (target == body):
		target = null
		has_target = false
	target_list.erase(body)
	
func _draw():
	if (!activated || selected):
		draw_circle(get_node("Sprite").get_pos(), area.get_radius(), Color("11272726"))
		
func fire():
	if (target != null && powered):
		var new_projectile = projectile.instance()
		new_projectile.set_target(target);
		new_projectile.set_pos(get_pos())
		new_projectile.dmg = dmg
		new_projectile.speed = 250
		get_parent().add_child(new_projectile)
		get_node("AnimationPlayer").play("fire")
		get_node("SamplePlayer").play("shoot_0" + str(floor(rand_range(1,4))))
	
func activate():
	connect("area_enter", self, "target_entered")
	connect("area_exit", self, "target_exited")
	fire_timer = get_node("fire_timer")
	fire_timer.connect("timeout", self, "fire")
	shoot_timer = get_node("shoot_timer")
	activated = true
	set_fixed_process(true)
	
func poweron():
	powered = true
	get_node("SamplePlayer").play("power_on")
	
func poweroff():
	powered = false
	get_node("SamplePlayer").play("power_off")
