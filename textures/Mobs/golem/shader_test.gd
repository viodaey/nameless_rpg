extends TextureRect

@onready var amplitude = self.material.get_shader_parameter("amplitude")

func _ready():
	print(amplitude)
	#assert (amplitude != null)

#func _on_amplitude_controller_amplitude_changed(amplitude_x):
	#amplitude.x = amplitude_x
	#material.set_shader_parameter("amplitude", amplitude)
	#print(amplitude)


func _on_amplitude_changed(value: float) -> void:
	amplitude.x = value
	material.set_shader_parameter("amplitude", amplitude)
	print(value)
