// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Malbers/Color3x3"
{
	Properties
	{
		[Header(Albedo(A Gradient))] _Color1("Color 1", Color) = (1,0.1544118,0.1544118,0)
		_Color2("Color 2", Color) = (1,0.1544118,0.8017241,1)
		_Color3("Color 3", Color) = (0.2535501,0.1544118,1,1)
		[Space(10)]_Color4("Color 4", Color) = (0.9533468,1,0.1544118,1)
		_Color5("Color 5", Color) = (0.2669384,0.3207547,0.0226949,1)
		_Color6("Color 6", Color) = (1,0.4519259,0.1529412,1)
		[Space(10)]_Color7("Color 7", Color) = (0.9099331,0.9264706,0.6267301,1)
		_Color8("Color 8", Color) = (0.1544118,0.1602434,1,1)
		_Color9("Color 9", Color) = (0.1529412,0.9929401,1,1)

		[HideInInspector] _texcoord("", 2D) = "white" {}
		[HideInInspector] __dirty("", Int) = 1

		_Ramp("Toon Ramp (RGB)", 2D) = "gray" {}
		_RimColor("Rim Color", Color) = (0.26,0.19,0.16,0.0)
		_RimPower("Rim Power", Range(0.5,8.0)) = 3.0
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
		_Outline("Outline width", Range(0, 0.05)) = .005

		_Color8Texture("Color8Texture",2D) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 4.0
		#pragma surface surf ToonRamp keepalpha
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
		};

		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float4 _Color3;
		uniform float4 _Color4;
		uniform float4 _Color5;
		uniform float4 _Color6;
		uniform float4 _Color7;
		uniform float4 _Color8;
		uniform float4 _Color9;


		sampler2D _Ramp;
		sampler2D _Color8Texture;


		// custom lighting function that uses a texture ramp based
		// on angle between light direction and normal
#pragma lighting ToonRamp exclude_path:prepass
		inline half4 LightingToonRamp(SurfaceOutput s, half3 lightDir, half atten)
		{
#ifndef USING_DIRECTIONAL_LIGHT
			lightDir = normalize(lightDir);
#endif

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb;
			c.a = s.Alpha;
			return c;
		}

		sampler2D _MainTex;
		float4 _RimColor;
		float _RimPower;


		void surf(Input i , inout SurfaceOutput o)
		{
			float temp_output_3_0_g361 = 1.0;
			float temp_output_7_0_g361 = 3.0;
			float temp_output_9_0_g361 = 3.0;
			float temp_output_8_0_g361 = 3.0;
			float temp_output_3_0_g351 = 2.0;
			float temp_output_7_0_g351 = 3.0;
			float temp_output_9_0_g351 = 3.0;
			float temp_output_8_0_g351 = 3.0;
			float temp_output_3_0_g365 = 3.0;
			float temp_output_7_0_g365 = 3.0;
			float temp_output_9_0_g365 = 3.0;
			float temp_output_8_0_g365 = 3.0;
			float temp_output_3_0_g360 = 1.0;
			float temp_output_7_0_g360 = 3.0;
			float temp_output_9_0_g360 = 2.0;
			float temp_output_8_0_g360 = 3.0;
			float temp_output_3_0_g363 = 2.0;
			float temp_output_7_0_g363 = 3.0;
			float temp_output_9_0_g363 = 2.0;
			float temp_output_8_0_g363 = 3.0;
			float temp_output_3_0_g359 = 3.0;
			float temp_output_7_0_g359 = 3.0;
			float temp_output_9_0_g359 = 2.0;
			float temp_output_8_0_g359 = 3.0;
			float temp_output_3_0_g358 = 1.0;
			float temp_output_7_0_g358 = 3.0;
			float temp_output_9_0_g358 = 1.0;
			float temp_output_8_0_g358 = 3.0;
			float temp_output_3_0_g362 = 2.0;
			float temp_output_7_0_g362 = 3.0;
			float temp_output_9_0_g362 = 1.0;
			float temp_output_8_0_g362 = 3.0;
			float temp_output_3_0_g364 = 3.0;
			float temp_output_7_0_g364 = 3.0;
			float temp_output_9_0_g364 = 1.0;
			float temp_output_8_0_g364 = 3.0;
			float4 temp_output_155_0 = (((_Color1 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g361 - 1.0) / temp_output_7_0_g361))) * (step(i.uv_texcoord.x , (temp_output_3_0_g361 / temp_output_7_0_g361)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g361 - 1.0) / temp_output_8_0_g361))) * (step(i.uv_texcoord.y , (temp_output_9_0_g361 / temp_output_8_0_g361)) * 1.0)))) + (_Color2 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g351 - 1.0) / temp_output_7_0_g351))) * (step(i.uv_texcoord.x , (temp_output_3_0_g351 / temp_output_7_0_g351)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g351 - 1.0) / temp_output_8_0_g351))) * (step(i.uv_texcoord.y , (temp_output_9_0_g351 / temp_output_8_0_g351)) * 1.0)))) + (_Color3 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g365 - 1.0) / temp_output_7_0_g365))) * (step(i.uv_texcoord.x , (temp_output_3_0_g365 / temp_output_7_0_g365)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g365 - 1.0) / temp_output_8_0_g365))) * (step(i.uv_texcoord.y , (temp_output_9_0_g365 / temp_output_8_0_g365)) * 1.0))))) + ((_Color4 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g360 - 1.0) / temp_output_7_0_g360))) * (step(i.uv_texcoord.x , (temp_output_3_0_g360 / temp_output_7_0_g360)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g360 - 1.0) / temp_output_8_0_g360))) * (step(i.uv_texcoord.y , (temp_output_9_0_g360 / temp_output_8_0_g360)) * 1.0)))) + (_Color5 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g363 - 1.0) / temp_output_7_0_g363))) * (step(i.uv_texcoord.x , (temp_output_3_0_g363 / temp_output_7_0_g363)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g363 - 1.0) / temp_output_8_0_g363))) * (step(i.uv_texcoord.y , (temp_output_9_0_g363 / temp_output_8_0_g363)) * 1.0)))) + (_Color6 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g359 - 1.0) / temp_output_7_0_g359))) * (step(i.uv_texcoord.x , (temp_output_3_0_g359 / temp_output_7_0_g359)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g359 - 1.0) / temp_output_8_0_g359))) * (step(i.uv_texcoord.y , (temp_output_9_0_g359 / temp_output_8_0_g359)) * 1.0))))) + ((_Color7 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g358 - 1.0) / temp_output_7_0_g358))) * (step(i.uv_texcoord.x , (temp_output_3_0_g358 / temp_output_7_0_g358)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g358 - 1.0) / temp_output_8_0_g358))) * (step(i.uv_texcoord.y , (temp_output_9_0_g358 / temp_output_8_0_g358)) * 1.0)))) + (_Color8 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g362 - 1.0) / temp_output_7_0_g362))) * (step(i.uv_texcoord.x , (temp_output_3_0_g362 / temp_output_7_0_g362)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g362 - 1.0) / temp_output_8_0_g362))) * (step(i.uv_texcoord.y , (temp_output_9_0_g362 / temp_output_8_0_g362)) * 1.0)))) + (_Color9 * (((1.0 - step(i.uv_texcoord.x , ((temp_output_3_0_g364 - 1.0) / temp_output_7_0_g364))) * (step(i.uv_texcoord.x , (temp_output_3_0_g364 / temp_output_7_0_g364)) * 1.0)) * ((1.0 - step(i.uv_texcoord.y , ((temp_output_9_0_g364 - 1.0) / temp_output_8_0_g364))) * (step(i.uv_texcoord.y , (temp_output_9_0_g364 / temp_output_8_0_g364)) * 1.0))))));
			float2 uv_TexCoord258 = i.uv_texcoord * float2(3,3);

			half rim = 1.0 - saturate(dot(normalize(i.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
			o.Albedo = temp_output_155_0.rgb;

			o.Alpha = 1;
		}

		ENDCG
		UsePass "Toon/Basic Outline/OUTLINE"
	}
}