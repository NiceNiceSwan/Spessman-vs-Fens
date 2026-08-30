shader_type canvas_item;

const float conveyor_start = 320.0;

void fragment() {
	//vec2 coord;
	//coord.x = (UV.x - REGION_RECT.r) / REGION_RECT.b;
	//coord.y = (UV.y - REGION_RECT.g) / REGION_RECT.a;
	//float var_x = 1.0 / SCREEN_PIXEL_SIZE.x;
	//float x_percentage = FRAGCOORD.x / var_x;
	////if (coord.x > coverage)
	////if (x_percentage > coverage)
	if (FRAGCOORD.x > conveyor_start)
	{
		COLOR.a = 0.0;
	}
}
