extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func use_random_seed():
	rng.randomize()

func set_seed(seed: int, state: int):
	rng.seed = seed
	rng.state = state
