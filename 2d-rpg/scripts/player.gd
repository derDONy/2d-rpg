extends CharacterBody2D

const SPEED = 200.0
const ATTACK_RANGE = 150.0
const ATTACK_COOLDOWN = 0.5

var hp: int = 100
var max_hp: int = 100
var damage: int = 10
var defense: int = 0
var level: int = 1
var xp: int = 0

var target: Node2D = null
var cooldown_timer: float = 0.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if cooldown_timer > 0.0:
		cooldown_timer -= _delta

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_try_select_target(event.position)
	if event.is_action_pressed("attack"):
		_try_attack()

func _try_select_target(mouse_pos: Vector2) -> void:
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_viewport().get_canvas_transform().affine_inverse() * mouse_pos
	query.collision_mask = 1
	var results = space.intersect_point(query)
	for r in results:
		var obj = r["collider"].get_parent() if r["collider"].get_parent().has_method("take_damage") else r["collider"]
		if obj.has_method("take_damage"):
			target = obj
			return

func take_damage(amount: int) -> void:
	var actual = max(0, amount - defense)
	hp -= actual
	if hp <= 0:
		hp = 0
		print("Spieler gestorben!")

func gain_xp(amount: int) -> void:
	xp += amount
	var xp_needed = 100 * level
	if xp >= xp_needed:
		xp -= xp_needed
		_level_up()

func _level_up() -> void:
	level += 1
	max_hp = int(max_hp * 1.2)
	hp = max_hp
	damage += 2
	print("LEVEL UP! Level ", level, " | HP: ", max_hp, " | Schaden: ", damage)

func _try_attack() -> void:
	if target == null or not is_instance_valid(target):
		return
	if cooldown_timer > 0.0:
		return
	var dist = global_position.distance_to(target.global_position)
	if dist > ATTACK_RANGE:
		return
	target.take_damage(damage)
	cooldown_timer = ATTACK_COOLDOWN
