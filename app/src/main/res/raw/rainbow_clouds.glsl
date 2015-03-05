float time = iGlobalTime * 0.1;

// http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 noise3(in vec2 uv)
{
    return abs(2. * (texture2D(iChannel0, uv*.01).xyz - 0.5));
}

// https://code.google.com/p/fractalt}erraingeneration/wiki/Fractional_Brownian_Motion
vec3 fbm(in vec2 p)
{
    const float gain = 0.5;
    const float lacunarity = 2.;

    vec3 total;
	float amplitude = gain;

	for (int i = 1; i < 7; i++) {
		total += noise3(p) * amplitude;
		amplitude *= gain;
		p *= lacunarity;
	}
	return total;
}

mat3 rotation(float angle, vec3 axis)
{
    vec3 a = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat3(oc * a.x * a.x + c,        oc * a.x * a.y - a.z * s,  oc * a.z * a.x + a.y * s,
                oc * a.x * a.y + a.z * s,  oc * a.y * a.y + c,        oc * a.y * a.z - a.x * s,
                oc * a.z * a.x - a.y * s,  oc * a.y * a.z + a.x * s,  oc * a.z * a.z + c);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 p = -1.0 + 2.0 * fragCoord.xy / iResolution.xy;
    p.x *= iResolution.x/iResolution.y;

    p.x = p.x*(1. + .2*sin(time*2.));
    p.y = p.y*(1. + .2*sin(time*2.));
    p += vec2(1.2, 1.2);
    if (iMouse.x > .001) p += (-1. + 2.*iMouse.xy/iResolution.xy);
    p *= 1.7;

    vec3 color = fbm(p);

#if 0
    color = mod(time + color*1.5, 1.);
    color = hsv2rgb(vec3(color.x, .8, .8));
#else
    color = time*vec3(0.9, 0.7, 0.25) + color;

    float c1 = color.x*3.;
    float c2 = color.y*9.;
    vec3 col1 = 0.5 + 0.5*sin(c1 + vec3(0.0,0.5,1.0));
	vec3 col2 = 0.5 + 0.5*sin(c2 + vec3(0.5,1.0,0.0));
	color = 2.0*pow(col1*col2,vec3(0.8));

    vec3 axis = fbm(p*.9);
    color = rotation(.9*length(axis)*sin(8.*time), axis)*color;
#endif

    fragColor.xyz = color;
}
