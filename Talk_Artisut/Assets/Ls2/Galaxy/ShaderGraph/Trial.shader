// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Trial"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0.8679245,0.1915984,0.1915984,1)
		[HDR]_Color2("Color2", Color) = (0.1113563,0.1446208,0.6415094,1)
		_MainTexScrollSpeed("MainTexScrollSpeed", Vector) = (-0.2,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
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

			uniform float4 _Color0;
			uniform float4 _Color2;
			uniform sampler2D _Texture0;
			uniform float2 _MainTexScrollSpeed;
			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.ase_texcoord;
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
				float4 lerpResult4 = lerp( _Color0 , _Color2 , i.ase_texcoord1.x);
				float2 texCoord29 = i.ase_texcoord1.xy * float2( 1,1 ) + ( _Time.y * _MainTexScrollSpeed );
				float2 texCoord55 = i.ase_texcoord1.xy * float2( 1,1 ) + ( _Time.y * float2( -0.2,0 ) );
				float simpleNoise45 = SimpleNoise( texCoord55*35.0 );
				float4 temp_output_11_0 = ( lerpResult4 * ( tex2D( _Texture0, texCoord29 ) * ( ( simpleNoise45 + ( 1.0 - i.ase_texcoord1.xy.x ) ) - i.ase_texcoord1.xy.x ) ) );
				float4 break58 = temp_output_11_0;
				float4 clampResult56 = clamp( temp_output_11_0 , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				float4 appendResult59 = (float4(break58.r , break58.g , break58.b , clampResult56.r));
				
				
				finalColor = appendResult59;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
-85.6;265.6;1523.2;670.2;-399.3164;-328.6989;1.3;True;True
Node;AmplifyShaderEditor.TimeNode;52;-1980.577,1495.146;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;53;-1944.576,1717.547;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;-0.2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;35;-1622.466,1754.529;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1647.476,1572.347;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;34;-1706.622,874.1718;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;37;-1395.429,1804.593;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;46;-1461.932,2147.51;Inherit;False;Constant;_NoiseScale;NoiseScale;4;0;Create;True;0;0;0;False;0;False;35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;24;-1694.303,1033.157;Inherit;True;Property;_MainTexScrollSpeed;MainTexScrollSpeed;3;0;Create;True;0;0;0;True;0;False;-0.2,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-1485.008,1427.282;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;48;-1146.487,1819.573;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;45;-1155.726,1415.305;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1394.862,921.1226;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1183.042,837.9393;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-852.4871,1815.573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;7;-1513.844,210.7534;Inherit;True;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;10;-1349.297,496.8442;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;True;0;False;None;8c4a7fca2884fab419769ccc0355c0c1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;12;-867.3267,639.7418;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-1173.644,-196.2467;Inherit;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;0;False;0;False;0.8679245,0.1915984,0.1915984,1;0.8679245,0.1915984,0.1915984,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;8;-1172.464,199.9266;Inherit;True;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;3;-1178.644,-11.24671;Inherit;False;Property;_Color2;Color2;2;1;[HDR];Create;True;0;0;0;False;0;False;0.1113563,0.1446208,0.6415094,1;0.1113563,0.1446208,0.6415094,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-641.9841,1673.08;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-375.6566,1021.861;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;4;-620.0442,12.85329;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.7075472;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;305.0438,732.5871;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;56;683.3528,795.4539;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;58;703.3528,642.4539;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;59;945.3528,641.4539;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1247.033,637.3191;Float;False;True;-1;2;ASEMaterialInspector;100;1;Trial;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;51;0;52;2
WireConnection;51;1;53;0
WireConnection;37;0;35;0
WireConnection;55;1;51;0
WireConnection;48;0;37;0
WireConnection;45;0;55;0
WireConnection;45;1;46;0
WireConnection;15;0;34;2
WireConnection;15;1;24;0
WireConnection;29;1;15;0
WireConnection;49;0;45;0
WireConnection;49;1;48;0
WireConnection;12;0;10;0
WireConnection;12;1;29;0
WireConnection;8;0;7;0
WireConnection;39;0;49;0
WireConnection;39;1;37;0
WireConnection;43;0;12;0
WireConnection;43;1;39;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;8;0
WireConnection;11;0;4;0
WireConnection;11;1;43;0
WireConnection;56;0;11;0
WireConnection;58;0;11;0
WireConnection;59;0;58;0
WireConnection;59;1;58;1
WireConnection;59;2;58;2
WireConnection;59;3;56;0
WireConnection;0;0;59;0
ASEEND*/
//CHKSM=FF65E82E8760E6519E20A6BCF70EEF44096FBB69