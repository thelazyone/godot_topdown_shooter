# Global utility functions for geometry.

extends Node

# Temp function, i'm sure there's a prebuild one.
func diff_angles(angle1, angle2):
	return fmod(fmod(angle1, 2 * PI) - fmod(angle2, 2 * PI) + 3 * PI, 2 * PI) - PI
	
func wrap_angle(angle):
	return fmod(angle + 3*PI, 2*PI) - PI
	
func plane_to_space(pos_2d):
	return Vector3(pos_2d.x, 0, pos_2d.y)

func space_to_plane(pos_3d):
	return Vector2(pos_3d.x, pos_3d.z)

func space_to_space_flat(pos_2d):
	return Vector3(pos_2d.x, 0, pos_2d.z)
