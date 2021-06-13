extends KinematicBody2D

var playerStats = PlayerStats

const MAX_SPEED = 100
const ROLL_SPEED = 140

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var animator:AnimationPlayer = null
var roll_vector = Vector2.RIGHT
onready var animTree : AnimationTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox

var facingRight = null
# Called when the node enters the scene tree for the first time.
func _ready():
	playerStats.connect("no_health", self, "queue_free")
	animator = $AnimationPlayer
	animTree.active = true
	swordHitbox.knockback_vector = roll_vector
	
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animTree.set("parameters/Run/blend_position", input_vector.x)
		animTree.set("parameters/Idle/blend_position", input_vector.y)
		animTree.set("parameters/Attack/blend_position", input_vector.x)
		animTree.set("parameters/Roll/blend_position", input_vector.x)
		animState.travel("Run")
		velocity =  input_vector
	else:
		velocity = Vector2.ZERO
		animState.travel("Idle")
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	move_and_slide(velocity * MAX_SPEED)
	
func attack_state(delta):
	animState.travel("Attack")
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animState.travel("Roll")
	move_and_slide(velocity)
	
func roll_anim_finished():
	state = MOVE
	
func attack_anim_finished():
	state = MOVE


func _on_Hurtbox_area_entered(area):
	playerStats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect(area)
