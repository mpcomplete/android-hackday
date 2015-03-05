// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// Volumetric clouds. It performs level of detail (LOD) for faster rendering and antialiasing

#define USE_LOD

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	vec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;
	vec2 rg = texture2D( iChannel0, (uv+ 0.5)/256.0, -100.0 ).yx;
	return -1.0+2.0*mix( rg.x, rg.y, f.z );
}

float map5( in vec3 p )
{
	vec3 q = p - vec3(1.0,0.1,0.0)*iGlobalTime;
	float f;
    f  = 0.50000*noise( q ); q = q*2.02;
    f += 0.25000*noise( q ); q = q*2.03;
    f += 0.12500*noise( q ); q = q*2.01;
    f += 0.06250*noise( q ); q = q*2.02;
    f += 0.03125*noise( q );
	return clamp( 1.5 - p.y + 1.75*f, 0.0, 1.0 );
}
#ifdef USE_LOD
float map4( in vec3 p )
{
	vec3 q = p - vec3(1.0,0.1,0.0)*iGlobalTime;
	float f;
    f  = 0.50000*noise( q ); q = q*2.02;
    f += 0.25000*noise( q ); q = q*2.03;
    f += 0.12500*noise( q ); q = q*2.01;
    f += 0.06250*noise( q );
	return clamp( 1.5 - p.y + 1.75*f, 0.0, 1.0 );
}
float map3( in vec3 p )
{
	vec3 q = p - vec3(1.0,0.1,0.0)*iGlobalTime;
	float f;
    f  = 0.50000*noise( q ); q = q*2.02;
    f += 0.25000*noise( q ); q = q*2.03;
    f += 0.12500*noise( q );
	return clamp( 1.5 - p.y + 1.75*f, 0.0, 1.0 );
}
float map2( in vec3 p )
{
	vec3 q = p - vec3(1.0,0.1,0.0)*iGlobalTime;
	float f;
    f  = 0.50000*noise( q ); q = q*2.02;
    f += 0.25000*noise( q );;
	return clamp( 1.5 - p.y + 1.75*f, 0.0, 1.0 );
}
#endif

vec3 sundir = normalize( vec3(-1.0,0.0,-0.1) );

vec4 integrate( in vec4 sum, in float dif, in float den, in vec3 bgcol, in float t )
{
    // lighting
    vec3 lin = vec3(0.65,0.68,0.7)*1.3 + 0.5*vec3(0.7, 0.5, 0.3)*dif;
    vec4 col = vec4( mix( 1.15*vec3(1.0,0.95,0.8), vec3(0.65), den ), den );
    col.xyz *= lin;
    col.xyz = mix( col.xyz, bgcol*0.9, 1.0-exp(-0.002*t*t) );
    // front to back blending
    col.a *= 0.4;
    col.rgb *= col.a;
    return sum + col*(1.0-sum.a);
}

vec4 raymarch( in vec3 ro, in vec3 rd, in vec3 bgcol )
{
	vec4 sum = vec4(0, 0, 0, 0);

	float t = 0.0;

#ifndef USE_LOD
	for(int i=0; i<120; i++)
	{
        vec3  pos = ro + t*rd;
        if( pos.y<-1.0 || pos.y>4.0 || sum.a > 0.99 ) break;
		float den = map5( pos );
		if( den>0.01 )
        {
            float dif =  clamp((den - map5(pos+0.3*sundir))/0.6, 0.0, 1.0 );
            sum = integrate( sum, dif, den, bgcol, t );
        }
		t += max(0.1,0.02*t);
	}
#else
	for(int i=0; i<30; i++)
	{
        vec3  pos = ro + t*rd;
        if( pos.y<-1.0 || pos.y>4.0 || sum.a > 0.99 ) break;
		float den = map5( pos );
		if( den>0.01 )
        {
            float dif =  clamp((den - map5(pos+0.3*sundir))/0.6, 0.0, 1.0 );
            sum = integrate( sum, dif, den, bgcol, t );
        }
		t += max(0.1,0.02*t);
	}
	for(int i=0; i<30; i++)
	{
        vec3  pos = ro + t*rd;
        if( pos.y<-1.0 || pos.y>4.0 || sum.a > 0.99 ) break;
		float den = map4( pos );
		if( den>0.01 )
        {
            float dif =  clamp((den - map4(pos+0.3*sundir))/0.6, 0.0, 1.0 );
            sum = integrate( sum, dif, den, bgcol, t );
        }
		t += max(0.1,0.02*t);
	}
	for(int i=0; i<30; i++)
	{
        vec3  pos = ro + t*rd;
        if( pos.y<-1.0 || pos.y>4.0 || sum.a > 0.99 ) break;
		float den = map3( pos );
		if( den>0.01 )
        {
            float dif =  clamp((den - map3(pos+0.3*sundir))/0.6, 0.0, 1.0 );
            sum = integrate( sum, dif, den, bgcol, t );
        }
		t += max(0.1,0.02*t);
	}
	for(int i=0; i<30; i++)
	{
        vec3  pos = ro + t*rd;
        if( pos.y<-1.0 || pos.y>4.0 || sum.a > 0.99 ) break;
		float den = map2( pos );
		if( den>0.01 )
        {
            float dif =  clamp((den - map2(pos+0.3*sundir))/0.6, 0.0, 1.0 );
            sum = integrate( sum, dif, den, bgcol, t );
        }
		t += max(0.1,0.02*t);
	}
#endif
	return clamp( sum, 0.0, 1.0 );
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 p = (-iResolution.xy + 2.0*fragCoord.xy)/ iResolution.y;

    vec2 mo = -1.0 + 2.0*iMouse.xy / iResolution.xy;

    // camera
    vec3 ro = 4.0*normalize(vec3(cos(2.75-3.0*mo.x), 0.7+(mo.y+1.0), sin(2.75-3.0*mo.x)));
	vec3 ta = vec3(0.0, 1.0, 0.0);
    vec3 ww = normalize( ta - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );

    // background sky
	float sun = clamp( dot(sundir,rd), 0.0, 1.0 );
	vec3 col = vec3(0.6,0.71,0.75) - rd.y*0.2*vec3(1.0,0.5,1.0) + 0.15*0.5;
	col += 0.2*vec3(1.0,.6,0.1)*pow( sun, 8.0 );

    // clouds
    vec4 res = raymarch( ro, rd, col );
    col = col*(1.0-res.w) + res.xyz;

    // sun glare
	col += 0.1*vec3(1.0,0.4,0.2)*pow( sun, 3.0 );

    fragColor = vec4( col, 1.0 );
}
