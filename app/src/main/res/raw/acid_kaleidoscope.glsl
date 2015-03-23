float time = iGlobalTime*.3 + 1.;

mat2 rotate(float angle)
{
    return mat2(
        vec2( cos(angle), sin(angle)),
        vec2(-sin(angle), cos(angle)));
}

// Project a point onto the circle of radius max(x,y).
vec2 mapRects(in vec2 p)
{
    vec2 ap = abs(sin(p*3.));
    float r = max(ap.x, ap.y);
    float angle = atan(p.y, p.x);

    return r*vec2(cos(angle), sin(angle));
}

vec2 getTransform(in vec2 p, int which)
{
    if (which == 0) {
        return p;
    } else if (which == 1) {
        return mapRects(rotate(time*.3)*p*.5);
    } else {
        return rotate(time*.3)*mapRects(mapRects(p));
    }
}

vec2 applyTransform(in vec2 p)
{
    float t = time*.5;
    float pct = smoothstep(0., 1., mod(t, 1.));
    int current = int(mod(t, 3.));
	int next = int(mod(t+1., 3.));
    return mix(getTransform(p, current), getTransform(p, next), pct);
}

vec4 gradient(float f)
{
    vec4 c = vec4(0);
	f = mod(f, 1.5);
    for (int i = 0; i < 3; ++i)
        c[i] = pow(.5 + .5 * sin(2.0 * (f +  .2*float(i))), 10.0);
    return c;
}

float offset(float th)
{
    return .2*sin(25.*th)*sin(time);
}

vec4 tunnel(float th, float radius)
{
	return gradient(offset(th) + 2.*log(radius) - time);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = -1.0 + 2.0 * fragCoord.xy / iResolution.xy;
    p.x *= iResolution.x/iResolution.y;

    p = applyTransform(p);

	fragColor = tunnel(atan(p.y, p.x), 2.0 * length(p));
}