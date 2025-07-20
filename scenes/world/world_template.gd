class_name WorldTemplate extends Resource

## Default tileset (1: Bricks, 2: Dirt, 3: Library)
@export_range(1, 3) var tileset = 1

## Minimum length in rooms.
@export var length_min = 5
## Maximum length in rooms.
@export var length_max = 7

## Minimum number of modifiers
@export var modifier_min = 3
## Maximum number of modifiers
@export var modifier_max = 4

## Scene to use as starting room
@export var start_room: PackedScene

## Pool of enemies that can spawn
@export var enemy_pool: ResourcePool
## Pool of modifiers that can be applied.
@export var modifier_pool: ResourcePool
