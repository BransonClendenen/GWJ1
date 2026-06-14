extends Node

func burst(
	parent: Node,
	pos: Vector2,
	color: Color = Color.WHITE,
	amount: int = 12,
	lifetime: float = 0.4
) -> void:
	var particles := CPUParticles2D.new()
	parent.add_child(particles)
	
	particles.position = pos
	particles.emitting = true
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.amount = amount
	particles.lifetime = lifetime
	particles.speed_scale = 1.0
	
	particles.direction = Vector2(0, -1)
	particles.spread = 180.0
	particles.initial_velocity_min = 20.0
	particles.initial_velocity_max = 60.0
	
	particles.scale_amount_min = 0.5
	particles.scale_amount_max = 1.5
	particles.color = color
	
	particles.gravity = Vector2(0, 98)
	
	var timer := get_tree().create_timer(lifetime + 0.2)
	timer.timeout.connect(particles.queue_free)

func squash(node: Node2D, intensity: float = 0.3, duration: float = 0.15) -> void:
	var original_scale := node.scale
	var tween := node.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(node, "scale", Vector2(
		original_scale.x * (1.0 + intensity),
		original_scale.y * (1.0 - intensity)
	), duration)
	tween.tween_property(node, "scale", original_scale, duration)

func stretch(node: Node2D, intensity: float = 0.3, duration: float = 0.15) -> void:
	var original_scale := node.scale
	var tween := node.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(node, "scale", Vector2(
		original_scale.x * (1.0 - intensity),
		original_scale.y * (1.0 + intensity)
	), duration)
	tween.tween_property(node, "scale", original_scale, duration)

func flash(node: Node2D, color: Color = Color.WHITE, duration: float = 0.1) -> void:
	var original_modulate := node.modulate
	var tween := node.create_tween()
	tween.tween_property(node, "modulate", color, duration * 0.3)
	tween.tween_property(node, "modulate", original_modulate, duration * 0.7)

func screen_shake(camera: Camera2D, intensity: float = 2.0, duration: float = 0.3) -> void:
	var original_offset := camera.offset
	var tween := camera.create_tween()
	var elapsed := 0.0
	var steps := 8
	
	for i in range(steps):
		var shake_offset := Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		tween.tween_property(camera, "offset", shake_offset, duration / steps)
	
	tween.tween_property(camera, "offset", original_offset, duration / steps)
