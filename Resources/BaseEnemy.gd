extends Resource

@export var name: String = "Enemy"
@export var ingredient: String = "Item"
@export var texture: Texture = null
@export var health: int = 30
@export var attack: int = 10
@export var defense: int = 10
@export var speed: int = 10
@export var moves: Array[String]
@export var weakness: String = "Attack"
@export var sight_range = 100
@export var walk_speed = 30
@export var run_speed = 35
