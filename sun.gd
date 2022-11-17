extends Spatial

onready var camera = $SunObj
var triggerCount = 0

func rotateAround(obj, point, axis, angle):
	var rot = angle + obj.rotation.y 
	var tStart = point
	obj.global_translate (-tStart)
	obj.transform = obj.transform.rotated(axis, -rot)
	obj.global_translate (tStart)

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 0.01
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.start()
	
func _on_timer_timeout():
	triggerCount += 1
	rotateAround(camera, Vector3(0,0,0), Vector3(1,0,0), deg2rad(0.03))
