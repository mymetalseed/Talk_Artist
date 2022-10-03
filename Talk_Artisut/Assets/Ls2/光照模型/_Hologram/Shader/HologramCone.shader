// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TA/Hologram/HologramCone"
{
	Properties
	{
		[HDR]_HologramColor("HologramColor", Color) = (0.2584905,0.483906,1,0)
		_AlphaExp("AlphaExp", Float) = 1
		_Line("Line", 2D) = "white" {}
		_FlowSpeed("FlowSpeed", Float) = 0.4
		_Noise("Noise", 2D) = "white" {}
		_CodeNoiseIntensity("CodeNoiseIntensity", Float) = 0
		_TextureNoiseIntensity("TextureNoiseIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _HologramColor;
			uniform sampler2D _Line;
			uniform float4 _Line_ST;
			uniform float _AlphaExp;
			uniform float _TextureNoiseIntensity;
			uniform float _FlowSpeed;
			uniform float _CodeNoiseIntensity;
			uniform sampler2D _Noise;
			uniform float4 _Noise_ST;
					float2 voronoihash73( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi73( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash73( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F2;
					}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_Line = i.ase_texcoord1.xy * _Line_ST.xy + _Line_ST.zw;
				float2 texCoord2 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_cast_2 = (_AlphaExp).xx;
				float4 appendResult11 = (float4(( ( 1.0 * _HologramColor ) + float4( ( (_HologramColor).rgb * tex2D( _Line, uv_Line ).r ) , 0.0 ) ).rgb , saturate( pow( texCoord2 , temp_cast_2 ) ).x));
				float mulTime31 = _Time.y * ( 0.01 * _FlowSpeed );
				float time73 = ( mulTime31 * 360.0 );
				float2 voronoiSmoothId73 = 0;
				float2 texCoord10 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_33_0 = frac( mulTime31 );
				float2 coords73 = ( ( texCoord10 * 0.1 ) + temp_output_33_0 ) * 100.0;
				float2 id73 = 0;
				float2 uv73 = 0;
				float voroi73 = voronoi73( coords73, time73, id73, uv73, 0, voronoiSmoothId73 );
				float2 uv_Noise = i.ase_texcoord1.xy * _Noise_ST.xy + _Noise_ST.zw;
				float2 temp_cast_4 = (( tex2D( _Noise, uv_Noise ).r + temp_output_33_0 )).xx;
				float dotResult4_g3 = dot( temp_cast_4 , float2( 12.9898,78.233 ) );
				float lerpResult10_g3 = lerp( 0.5 , 1.0 , frac( ( sin( dotResult4_g3 ) * 43758.55 ) ));
				float4 FinalColor96 = ( ( ( appendResult11 * _TextureNoiseIntensity ) + ( voroi73 * _CodeNoiseIntensity ) ) * lerpResult10_g3 );
				
				
				finalColor = FinalColor96;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
-373.6;629.6;1523.2;664.6;-153.2472;259.4689;1.404624;True;True
Node;AmplifyShaderEditor.RangedFloatNode;76;-1100.616,1221.554;Inherit;False;Property;_FlowSpeed;FlowSpeed;4;0;Create;True;0;0;0;False;0;False;0.4;19.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;93;-872.3482,-485.5839;Inherit;False;1015.572;507.5421;光线贴图;7;1;37;4;25;16;44;84;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1093.407,1131.315;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-924.6163,1174.554;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-822.3482,-349.538;Inherit;False;Property;_HologramColor;HologramColor;0;1;[HDR];Create;True;0;0;0;False;0;False;0.2584905,0.483906,1,0;0.1563342,0.5037259,1,0.8313726;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;89;-542.4818,135.7689;Inherit;False;684.1437;352.0958;根据uv.y 做Alpha衰减;5;2;8;6;7;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-753.4069,1185.315;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;4;-421.0502,-301.7299;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1014.255,839.6194;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-500.6691,-216.0418;Inherit;True;Property;_Line;Line;3;0;Create;True;0;0;0;False;0;False;-1;1b473f5b8ac49864b8dba9edbd3c9d07;1b473f5b8ac49864b8dba9edbd3c9d07;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;84;-754.8492,-430.5839;Inherit;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-945.8618,975.0128;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-492.4819,185.769;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-451.3186,306.0738;Inherit;False;Property;_AlphaExp;AlphaExp;1;0;Create;True;0;0;0;False;0;False;1;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;33;-631.4068,1045.315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-359.5454,-396.2001;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-483.5581,1224.153;Inherit;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;0;False;0;False;360;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-199.0697,-293.8313;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-677.1503,851.8535;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;98;-195.4265,279.2548;Inherit;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-16.0621,-383.4886;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-317.5581,1140.153;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-411.832,1010.097;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;8;-23.48268,252.4693;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-347.4994,1340.596;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;91;-69.87188,935.7017;Inherit;False;473.8571;434.1428;模拟烟尘流动;3;85;73;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;81;-633.9053,562.5612;Inherit;True;Property;_Noise;Noise;5;0;Create;True;0;0;0;False;0;False;-1;None;40b1e826c04b73745955cd0ae83ce03d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;73;-19.87182,985.7017;Inherit;True;0;0;1;1;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;88;228.6388,311.1084;Inherit;False;Property;_TextureNoiseIntensity;TextureNoiseIntensity;7;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;21.69623,1277.261;Inherit;False;Property;_CodeNoiseIntensity;CodeNoiseIntensity;6;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;291.1404,205.4701;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;253.6962,1017.261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;92;-98.1729,572.237;Inherit;False;314.7143;275.7143;跳动的噪音;1;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;505.4247,212.7132;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-276.9623,647.9279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;14;-51.1729,621.237;Inherit;True;Random Range;-1;;3;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;718.6638,204.8546;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;893.9608,196.9472;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;1127.577,234.4622;Inherit;False;FinalColor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-431.6056,373.1505;Inherit;False;Property;_AlphaScale;AlphaScale;2;0;Create;True;0;0;0;False;0;False;1;7.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;965.5766,-49.53784;Inherit;False;96;FinalColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1356.883,-37.36328;Float;False;True;-1;2;ASEMaterialInspector;100;1;TA/Hologram/HologramCone;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;75;0;32;0
WireConnection;75;1;76;0
WireConnection;31;0;75;0
WireConnection;4;0;1;0
WireConnection;33;0;31;0
WireConnection;37;0;84;0
WireConnection;37;1;1;0
WireConnection;16;0;4;0
WireConnection;16;1;25;1
WireConnection;71;0;10;0
WireConnection;71;1;72;0
WireConnection;98;0;2;0
WireConnection;98;1;6;0
WireConnection;44;0;37;0
WireConnection;44;1;16;0
WireConnection;78;0;31;0
WireConnection;78;1;79;0
WireConnection;17;0;71;0
WireConnection;17;1;33;0
WireConnection;8;0;98;0
WireConnection;73;0;17;0
WireConnection;73;1;78;0
WireConnection;73;2;74;0
WireConnection;11;0;44;0
WireConnection;11;3;8;0
WireConnection;85;0;73;0
WireConnection;85;1;86;0
WireConnection;80;0;11;0
WireConnection;80;1;88;0
WireConnection;82;0;81;1
WireConnection;82;1;33;0
WireConnection;14;1;82;0
WireConnection;87;0;80;0
WireConnection;87;1;85;0
WireConnection;30;0;87;0
WireConnection;30;1;14;0
WireConnection;96;0;30;0
WireConnection;0;0;97;0
ASEEND*/
//CHKSM=5BA062C3D1F0D3C2CC20FC79D61455BC9F7B2EC2