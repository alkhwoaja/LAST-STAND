extends CharacterBody2D

var enemy_death_effect = preload("res://enemies/enemy_death_effect.tscn")

@export var speed : int = 100
@export var health_amount : int = 3
@export var damage_amount : int = 1
@export var move_range : float = 200.0  # المسافة التي يتحرك بها ذهابًا وإيابًا

@onready var animated_sprite_2d = $AnimatedSprite2D
var start_position : Vector2
var moving_right := true

const GRAVITY = 1000

func _ready():
	start_position = position

func _physics_process(delta: float) -> void:
	enemy_gravity(delta)
	enemy_patrol(delta)
	move_and_slide()
	enemy_animations()


func enemy_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta


func enemy_patrol(delta: float) -> void:
	var distance_from_start = position.x - start_position.x

	# انعكاس الاتجاه إذا وصل لنهاية النطاق
	if moving_right and distance_from_start > move_range:
		moving_right = false
	elif not moving_right and distance_from_start < -move_range:
		moving_right = true

	# تحديث السرعة بالاتجاه المناسب
	velocity.x = speed * (1 if moving_right else -1)

	# قلب الرسوم لتناسب الاتجاه
	animated_sprite_2d.flip_h = moving_right


func enemy_animations() -> void:
	if abs(velocity.x) > 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		
		if health_amount <= 0:
			var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
			enemy_death_effect_instance.global_position = global_position
			get_parent().add_child(enemy_death_effect_instance)
			queue_free()
