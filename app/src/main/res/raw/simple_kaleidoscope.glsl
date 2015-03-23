float time = iGlobalTime;
float PI = 3.14159269359;

// Fuzzy unit circle.
float circle(in vec2 p)
{
    float r = length(p);
    float angle = atan(p.y, p.x);
    r += .1*sin(angle*8.)*sin(time*.5);
    //return step(abs(r - .5), .1);
    return step(r, 1.) * pow(1.-r, .5);
}

// Project a point onto the circle of radius max(x,y).
vec2 square2circle(in vec2 p)
{
    vec2 ap = abs(p);
    float r = max(ap.x, ap.y);
    float angle = atan(p.y, p.x);

    return r*vec2(cos(angle), sin(angle));
}

// Project a point onto the circle of radius max(x,y).
vec2 mapRects(in vec2 p)
{
//    vec2 ap = sin(abs(p*6.));
    vec2 ap = abs(sin(p*6.));
    float r = max(ap.x, ap.y);
    float angle = atan(p.y, p.x);

    return r*vec2(cos(angle), sin(angle));
}

mat2 rotate(float angle)
{
    return mat2(
        vec2( cos(angle), sin(angle)),
        vec2(-sin(angle), cos(angle)));
}

#if 0
vec2 getTransform(in vec2 p, int which)
{
        return mapRects(mapRects(mapRects(.5*p)));
    if (which == 0) {
        p = square2circle(p);
        return mapRects(2.*mapRects(p));
    } else if (which == 1) {
        return mapRects(rotate(time*.1)*3.*mapRects(p));
    } else {
        return mapRects(mapRects(mapRects(.5*p)));
    }
}
#else
vec2 getTransform(in vec2 p, int which)
{
    if (which == 0) {
        p = square2circle(p);
		p = mapRects(p);
        p = rotate(time*.1)*p;
		p = mapRects(p);
    } else if (which == 1) {
        p = square2circle(p);
        p = rotate(time*.1)*p;
        p = mapRects(p);
		p = mapRects(p*.9);
		p = mapRects(p);
    } else {
		p = mapRects(p);
		p = mapRects(p*.9);
        p = rotate(time*.1)*p;
		p = mapRects(p);
    }
    return p;
}
#endif

vec2 applyTransform(in vec2 p)
{
    // Slowly fade from 0 to 1 every second.
    float t = time*.3;
//    float pct = smoothstep(-1., 1., sin(-PI/2. + PI*mod(t, 1.)));
//    float pct = smoothstep(0., 1., mod(t, 1.));
    float pct = mod(t, 1.);
    int current = int(mod(t, 3.));
	int next = int(mod(t+1., 3.));
    return mix(getTransform(p, current), getTransform(p, next), pct);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = -1.0 + 2.0 * fragCoord.xy / iResolution.xy;
    p.x *= iResolution.x/iResolution.y;

    p = applyTransform(p);
    float c1 = circle(p);
    float c2 = circle(p*1.7);
    float c3 = circle(p*1.3);
//    float c2 = circle(p - .2*vec2(sin(time*.6), cos(time*.4)));
//    float c3 = circle(p + .2*vec2(sin(time*.5), cos(time*.5)));

	fragColor = vec4(c1, c2, c3, 1.0);
}