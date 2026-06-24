extends CharacterBody2D

const SPEED = 50.0
const ATTACK_RANGE = 60.0
const ATTACK_COOLDOWN = 2.0
const AGGRO_RADIUS = 200.0

var hp: int = 30
var max_hp: int = 30
var xp_value: int = 20
var damage: int = 3

var player: Node2D = null
var cooldown_timer: float = 0.0

func _ready() -> void:
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		return

	var dist = global_position.distance_to(player.global_position)

	if dist <= AGGRO_RADIUS:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()

		if cooldown_timer > 0.0:
			cooldown_timer -= delta

		if dist <= ATTACK_RANGE and cooldown_timer <= 0.0:
			_attack_player()
	else:
		velocity = Vector2.ZERO

func _attack_player() -> void:
	player.take_damage(damage)
	cooldown_timer = ATTACK_COOLDOWN

func take_damage(amount: int) -> void:
	hp -= amount
	print("Gegner HP: ", hp, "/", max_hp)
	if hp <= 0:
		die()

func die() -> void:
	var p = get_tree().get_first_node_in_group("player")
	if p:
		p.gain_xp(xp_value)
	queue_free()
