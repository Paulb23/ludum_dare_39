extends Area2D

var projectile = load("res://Projectiles/point_projectile.tscn")

var name = "Splitter"
var activated = false
var target_list = []

var dmg = 6
var powered = true
var energy_cost = 15
var build_cost = 10
var energy_generation = 0

var area = CircleShape2D.new()
var selected = false
var first_target = true

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
	
	if (target_list.size() > 0):
		if (fire_timer.get_time_left() == 0):
			fire_timer.start()
			if (shoot_timer.get_time_left() == 0 && first_target):
				first_target = false
				shoot_timer.start()
				fire()
	if (target_list.size() <= 0):
		fire_timer.stop()
		first_target = true
	
	if (!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("powered")

func target_entered(body):
	if (body.get_name().find("target") == -1):
		return 
	target_list.push_back(body)
	
func target_exited(body):
	if (body.get_name().find("target") == -1):
		return 
	target_list.erase(body)
	
func _draw():
	if (!activated || selected):
		draw_circle(get_node("Sprite").get_pos(), area.get_radius(), Color("11272726"))
		
func fire():
	if (powered):
		var dist = area.get_radius()
		for i in range(0, 360, 10):
			var X = get_pos().x + (dist * cos(i))  
			var Y = get_pos().y + (dist * sin(i))
			var new_projectile = projectile.instance()
			new_projectile.target = Vector2(X, Y);
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
