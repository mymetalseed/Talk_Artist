
Shader "ShaderMan/MyShader"
	{

	Properties{
	//Properties
	}

	SubShader
	{
	Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

	Pass
	{
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"

	struct VertexInput {
    fixed4 vertex : POSITION;
	fixed2 uv:TEXCOORD0;
    fixed4 tangent : TANGENT;
    fixed3 normal : NORMAL;
	//VertexInput
	};


	struct VertexOutput {
	fixed4 pos : SV_POSITION;
	fixed2 uv:TEXCOORD0;
	//VertexOutput
	};

	//Variables

	#define PI 3.141592
#define TAU (PI*2.0)

fixed rand(fixed2 n) { 
	return frac(sin(dot(n, fixed2(12.9898, 4.1414))) * 43758.5453);
}

fixed noise(fixed2 p){
	fixed2 ip = floor(p);
	fixed2 u = frac(p);
	u = u*u*(3.0-2.0*u);
	
	fixed res = lerp(
		lerp(rand(ip),rand(ip+fixed2(1.0,0.0)),u.x),
		lerp(rand(ip+fixed2(0.0,1.0)),rand(ip+fixed2(1.0,1.0)),u.x),u.y);
	return res*res;
}

//Fractal Brownian Motion 分形布朗运动
fixed fbm(fixed2 p) {
    fixed r = 0.0;
    fixed amp = 1.0;
    fixed freq = 1.0;
    [unroll(100)]
for(int i = 0; i < 3; i++) {
        r += amp * noise(freq*p);
        amp *= 0.5;
        freq *= 1.0/0.5;
    }
    return r;
}

fixed2x2 rot( fixed th ){ fixed2 a = sin(fixed2(1.5707963, 0) + th); return fixed2x2(a, -a.y, a.x); }

fixed remap(fixed val, fixed im, fixed ix, fixed om, fixed ox)
{
    return clamp(om + (val - im) * (ox - om) / (ix - im), om, ox);
}

fixed cio(fixed t) {
	return t < 0.5
	? 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t))
	: 0.5 * (sqrt((3.0 - 2.0 * t) * (2.0 * t - 1.0)) + 1.0);
}

fixed animHeight(fixed2 p)
{
    fixed s = 0., hs = 1.;
    fixed t = fmod(_Time.y, 7.);
    fixed tt = remap(t, 1., 2., 0., 1.);
    s = lerp(0., .3, cio(tt));

    tt = remap(t, 3., 4., 0., 1.);
    fixed2x2 lk = rot(cio(tt) * 3.);
    p = mul(p,lk);

    tt = remap(t, 4., 5., 0., 1.);
    s = lerp(s, 1.0, cio(tt));

    tt = remap(t, 5., 6., 0., 1.);
    p = mul(p,rot(-cio(tt) * 3.));;

    tt = remap(t, 6.5, 7., 0., 1.);
    p = mul(p,rot(cio(tt) * 1.));
    hs = lerp(1., 0., cio(tt));

    fixed pls = (sin(t * TAU - PI*.5) * .5 + .5) * step(fmod(t, 2.), 1.) * .2;
    return (fbm(p * s + t * .5) + pls) * hs;
}

fixed sdBox( fixed3 p, fixed3 b )
{
  fixed3 d = abs(p) - b;
  return length(max(d,0.0));
}

fixed2 rep( in fixed2 p, in fixed2 c)
{
    return fmod(p,c)-0.5*c;
}

fixed map(fixed3 p)
{
    fixed bd = length(p.xz) - 5.0;
    if (bd > 0.1) {
    	return bd;
    }
    fixed2 id = floor(p.xz / 0.2);
    fixed height = animHeight(id * 0.2) * 0.5;
    p.xz = rep(p.xz, fixed2(0.2,0.2));
    p.y -= height;
    fixed box = sdBox(p, fixed3(0.03, height, 0.03));
    return max(box, bd) * .5;
}

fixed2 trace(fixed3 p, fixed3 ray, fixed mx)
{
    fixed t = 0.0;
    fixed3 pos;
    fixed dist;
    for (int i = 0; i < 128; i++) {
        pos = p + ray * t;
        dist = map(pos);
        if (dist < 0.002 || t > mx) {
        	break;
        }
        t += dist;
    }
    return fixed2(t, dist);
}

fixed3 getColor(fixed3 p, fixed3 ray)
{
    fixed2 t = trace(p, ray, 100.0);
    fixed3 pos = p + ray * t.x;
    if (t.x > 100.0) {
        return fixed3(0.0,0.0,0.0);
    }
    return max(fixed3(0.2, 0.5, 0.8) * 7.0 * pow(pos.y, 4.0) * smoothstep(0.0, -1.0, length(pos.xz) - 5.0), fixed3(0.0,0.0,0.0));
}

fixed3x3 camera(fixed3 ro, fixed3 ta, fixed cr )
{
	fixed3 cw = normalize(ta - ro);
	fixed3 cp = fixed3(sin(cr), cos(cr),0.);
	fixed3 cu = normalize( cross(cw,cp) );
	fixed3 cv = normalize( cross(cu,cw) );
    return fixed3x3( cu, cv, cw );
}

fixed luminance(fixed3 col)
{
    return dot(fixed3(0.3, 0.6, 0.1), col);
}

fixed3 acesFilm(const fixed3 x) {
    const fixed a = 2.51;
    const fixed b = 0.03;
    const fixed c = 2.43;
    const fixed d = 0.59;
    const fixed e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d ) + e), 0.0, 1.0);
}





	VertexOutput vert (VertexInput v)
	{
	VertexOutput o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = v.uv;
	//VertexFactory
	return o;
	}
	fixed4 frag(VertexOutput i) : SV_Target
	{
	
    fixed2 p = (i.uv * 2.0 - 1) / min(1, 1);
    
    fixed t = _Time.y * 0.1;
    fixed3 ro = fixed3(cos(t) * 10.0, 5.5, sin(t) * 10.0);
    fixed3 ta = fixed3(0.0, 1.0, 0.0);
    fixed3x3 c = camera(ro, ta, 0.0);
    fixed3 ray = mul(c,normalize(fixed3(p, 2.5)));
    fixed3 col = getColor(ro, ray);
    
    fixed3 lp = fixed3(0.0, 6.0, 0.0), rd = ray;

    fixed s = 7.5, vol = 0.0;
    [unroll(100)]
for(int i = 0; i < 60; i++) {
        fixed3 pos = ro + rd*s;
        
        fixed3 v = -normalize(lp - pos);
        
    	fixed tt = -(lp.y-2.) / v.y;
        
        fixed3 ppos = lp + v * tt;
	    vol += pow(animHeight(ppos.xz), 3.0) * 0.05 * smoothstep(0.0, 1.5, pos.y) * smoothstep(-1.0, -4.0, length(ppos.xz) - 5.0);

        s += 0.1;
    
	}
        col += 1.6*fixed3(0.3*vol, 0.5*vol, vol);

        col = acesFilm(col * 0.5);
        col = pow(col, 1.0/2.2);

        return fixed4(col,1.0);
	}
    	ENDCG
  }
}

    }