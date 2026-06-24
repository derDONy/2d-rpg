extends CanvasLayer

@onready var player_label: Label = $PlayerLabel
@onready var enemy_label: Label = $EnemyLabel
@onready var level_label: Label = $LevelLabel

var player: Node2D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	if player and is_instance_valid(player):
		player_label.text = "HP: %d / %d" % [player.hp, player.max_hp]
		level_label.text = "Level %d  |  XP: %d / %d  |  Schaden: %d" % [
			player.level, player.xp, 100 * player.level, player.damage
		]
	else:
		player_label.text = "HP: --"
		level_label.text = ""

	var enemy = get_tree().get_first_node_in_group("enemy")
	if enemy and is_instance_valid(enemy):
		enemy_label.text = "Gegner HP: %d / %d" % [enemy.hp, enemy.max_hp]
	else:
		enemy_label.text = "Gegner: tot"
