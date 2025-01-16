extends CharacterBody2D

@export var animals = {
	"elephant": preload("res://scenes/elephant.tscn"),
	"monkey": preload("res://scenes/monkey.tscn"),
	"armadillo": preload("res://scenes/armadillo.tscn")
}

var current_animal: CharacterBody2D = null  # Current active animal
var current_animal_type: String = ""  # Current animal type

# Movement variables (for base player or shared settings)
@export var speed = 200
@export var gravity = 800

func _ready():
	morph_to("elephant", Vector2.ZERO)  # Start as the elephant

func morph_to(animal_type: String, spawn_pos: Vector2):
	if animal_type in animals:
		# Remove the current animal if it exists		
		if current_animal:
			current_animal.queue_free()
		
		# Instantiate the new animal scene
		current_animal = animals[animal_type].instantiate() as CharacterBody2D
		#add_child(current_animal)

		# Set the new animal's position relative to the parent (this should be the player or character)
		current_animal.position = spawn_pos
		current_animal.velocity = velocity  
		add_child(current_animal)
		
		# Update the current animal type
		current_animal_type = animal_type

		print("Morphed into:", animal_type)
	else:
		print("Animal type not found:", animal_type)

func _physics_process(delta):
	handle_movement(delta)
	handle_morphing_input()

func handle_movement(delta):
	if current_animal:
		# Example: Basic horizontal movement
		var direction = Vector2.ZERO
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1

		current_animal.velocity.x = direction.x * speed
		current_animal.velocity.y += gravity * delta  # Apply gravity

		current_animal.move_and_slide()
	else:
		print("No active animal for movement")

func handle_morphing_input():
	if Input.is_action_just_pressed("morph_elephant"):
		#print(current_animal.global_position)
		morph_to("elephant",current_animal.global_position)
	elif Input.is_action_just_pressed("morph_armadillo"):
		#print(current_animal.global_position)
		morph_to("armadillo", current_animal.global_position)
	elif Input.is_action_just_pressed("morph_monkey"):
		#print(current_animal.global_position)
		morph_to("monkey",current_animal.global_position)
