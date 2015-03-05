float SIZE = 0.05;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    float t = 0.5+0.5*sin(iGlobalTime);
    uv.y += 0.1*sin((uv.x / (1.75*SIZE))*3.0 + iGlobalTime);
    vec2 dot = step(mod(uv, 1.75*SIZE), vec2(SIZE));
    float inSquare = dot.x*dot.y;
    fragColor = inSquare*vec4(uv,t,1.0);
}
