float time = iGlobalTime;

vec4 gradient(float f)
{
	f = mod(f, 1.5);
	float r = pow(.5 + .5 * sin(2.0 * (f + 0.00)), 10.0);
	float g = pow(.5 + .5 * sin(2.0 * (f + 0.20)), 10.0);
	float b = pow(.5 + .5 * sin(2.0 * (f + 0.40)), 10.0);
	return vec4(r, g, b, 1.0);
}

float offset(float th)
{
    return .5*sin(25.*th)*sin(time);
}

vec4 tunnel(float th, float radius)
{
	return gradient(offset(th + .25*time) + 3.*log(3.*radius) - time);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = -1.0 + 2.0 * fragCoord.xy / iResolution.xy;
    p.x *= iResolution.x/iResolution.y;
	fragColor = tunnel(atan(p.y, p.x), 2.0 * length(p));
}
