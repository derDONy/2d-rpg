extends Node2D

const ENEMY_SCENE = preload("res://scenes/player/enemy.tscn")
const SPAWN_INTERVAL = 5.0

var timer: float = 0.0
var max_enemies: int = 2

func _process(delta: float) -> void:
	var current = get_tree().get_nodes_in_group("enemy").size()
	if current >= max_enemies:
		return

	timer += delta
	if timer >= SPAWN_INTERVAL:
		timer = 0.0
		_spawn_enemy()

func _spawn_enemy() -> void:
	var enemy = ENEMY_SCENE.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = _random_spawn_pos()

func _random_spawn_pos() -> Vector2:
	var viewport = get_viewport().get_visible_rect()
	var margin = 100.0
	var side = randi() % 4
	match side:
		0: return Vector2(randf_range(margin, viewport.size.x - margin), margin)
		1: return Vector2(randf_range(margin, viewport.size.x - margin), viewport.size.y - margin)
		2: return Vector2(margin, randf_range(margin, viewport.size.y - margin))
		3: return Vector2(viewport.size.x - margin, randf_range(margin, viewport.size.y - margin))
	return Vector2(400, 100)
