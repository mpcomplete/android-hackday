float kSpeed = 0.2;

// Fuzzy circle with radius .5 centered at (.5, .5).
float circle(in vec2 uv)
{
    float r = .5;
    vec2 center = vec2(r, r);
    float d = distance(uv, center);
    return step(d, r) * pow(1.-d, 4.);
}

void main(void)
{
    float minResolution = min(iResolution.x, iResolution.y);
	vec2 uv = gl_FragCoord.xy / minResolution;
    float time = iGlobalTime * kSpeed;

    float sets[6];

    // First set:
    vec2 p = uv;
    p.x += sin(3.*p.y)*sin(2.*p.x + time);
    sets[0] = circle(mod(p, .2)*7.);

    // Second set:
    p = uv;
    p.y += sin(10.*p.y)*sin(2.3*p.x + .8*time);
    sets[1] = circle(mod(p*.6, .2)*7.);

    // Third set:
    p = uv;
    p.y += sin(10.*p.x)*sin(2.3*p.y + 2.*time);
    p.x += sin(p.y)*sin(p.x) + sin(time);
    sets[2] = circle(mod(p*.4, .2)*4.);

    // Fourth set:
    p = uv;
    p.y += sin(5.*p.x)*sin(2.*p.y + 1.4*time);
    p.x += sin(5.*p.y)*sin(p.x) + sin(time);
    sets[3] = circle(mod(p, .4)*3.);

    // Fifth set:
    p = uv;
    p.x += sin(2.*uv.y)*sin(5.*uv.x + 2.5*time);
    p.y += sin(2.*uv.x)*sin(5.*uv.x + 2.0*time);
    sets[4] = circle(mod(p, .2)*5.);

    gl_FragColor.xy += sets[0];
    gl_FragColor.yz += sets[1];
    gl_FragColor.xz += sets[2];
    gl_FragColor.y += 0.5*sets[3];
    gl_FragColor.xyz += vec3(0.2, 0.4, 0.7)*sets[4];
    gl_FragColor.w = 1.;
}