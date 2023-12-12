extends CharacterBody2D

var can_laser: bool = true
var can_grenade: bool = true

signal laser(pos,direction)
signal grenade(pos, direction)

@export var max_speed: int = 500
var speed: int = max_speed


func _process(_delta):
	
	#Movement
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction *speed
	move_and_slide()
	
	#Rotate
	look_at(get_global_mouse_position())
	
	
	
	
	var projectile_direction = (get_global_mouse_position() - position).normalized()
	#Primary action
	if Input.is_action_pressed("primary action") and can_laser:
		$GPUParticles2D.emitting = true
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		laser.emit(selected_laser.global_position, projectile_direction)
		can_laser = false
		$Timer.start()
		

	if Input.is_action_pressed("secondary action") and can_grenade:
		var grenade_pos = $GrenadeStartPosition.get_child(0).global_position
		
		grenade.emit(grenade_pos, projectile_direction)
		can_grenade = false
		$Timer2.start()


func _on_timer_timeout():
	can_laser = true
	

func _on_timer_2_timeout():
	can_grenade = true
