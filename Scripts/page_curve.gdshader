shader_type canvas_item;

void vertex() {
	if(VERTEX.y > 0.0)
		VERTEX.y += (abs(sin((VERTEX.x * PI) / 600.0)) - (abs(VERTEX.x) / 1500.0)) * 100.0;
		//VERTEX.y = 10.0;
	else
		VERTEX.y += abs(sin((VERTEX.x * PI) / 600.0)) * 100.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
