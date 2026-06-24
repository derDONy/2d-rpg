extends CharacterBody2D

var hp: int = 50
var max_hp: int = 50
var xp_value: int = 20

func take_damage(amount: int) -> void:
	hp -= amount
	print("Gegner HP: ", hp, "/", max_hp)
	if hp <= 0:
		die()

func die() -> void:
	print("Gegner gestorben! +", xp_value, " XP")
	queue_free()
