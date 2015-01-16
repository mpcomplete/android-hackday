float SIZE = 0.05;

void main(void)
{
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
    float t = 0.5+0.5*sin(iGlobalTime);
    uv.y += 0.1*sin((uv.x / (1.75*SIZE))*3.0 + iGlobalTime);
    vec2 dot = step(mod(uv, 1.75*SIZE), vec2(SIZE));
    float inSquare = dot.x*dot.y;
    gl_FragColor = inSquare*vec4(uv,t,1.0);
}