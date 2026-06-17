extends Node
class_name CoinManager

signal coin_changed(new_amount: int)

var coins: int = 0

func setup(starting_coins: int):
	
	coins = starting_coins
	print("coins 1: ", coins)
	emit_signal("coin_changed",coins)

func add_coins(amount: int):
	coins += amount
	emit_signal("coin_changed", coins)

func spend_coins(amount: int) -> bool:
	if not can_afford(amount):
		return false
	coins -= amount
	emit_signal("coin_changed", coins)
	return true

func can_afford(amount: int) -> bool:
	return coins >= amount
