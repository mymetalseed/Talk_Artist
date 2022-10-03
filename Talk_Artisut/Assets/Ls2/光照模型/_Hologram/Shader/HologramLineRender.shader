// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HologramLine"
{
	Properties
	{
		_ScanLineWidth("ScanLineWidth", Float) = 1
		[HDR]_HologramColor1("HologramColor", Color) = (0.2584905,0.483906,1,0)
		[HDR]_ScanLineColor("ScanLineColor", Color) = (0.1091644,0.7048749,1,0)
		ScanLine_Speed1("ScanLine_Speed", Float) = 0.5
		_Alpha("Alpha", Range( 0 , 1)) = 0

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

			uniform float4 _HologramColor1;
			uniform float ScanLine_Speed1;
			uniform float _ScanLineWidth;
			uniform float4 _ScanLineColor;
			uniform float _Alpha;

			
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
				float2 texCoord1 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_2_0 = ( 1.0 - texCoord1.x );
				float mulTime6 = _Time.y * ScanLine_Speed1;
				float temp_output_9_0 = frac( mulTime6 );
				float3 appendResult20 = (float3(( _HologramColor1 + ( ( saturate( step( temp_output_2_0 , ( temp_output_9_0 + ( 0.1 * _ScanLineWidth ) ) ) ) - saturate( step( temp_output_2_0 , temp_output_9_0 ) ) ) * _ScanLineColor ) ).rgb));
				float4 appendResult21 = (float4(appendResult20 , _Alpha));
				
				
				finalColor = appendResult21;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
178.2857;282.8571;1809.714;1121.857;38.17163;281.4869;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-1526.654,229.2803;Inherit;False;Property;ScanLine_Speed1;ScanLine_Speed;3;0;Create;False;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1377.202,407.2269;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1352.654,233.2803;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1409.202,519.2267;Inherit;False;Property;_ScanLineWidth;ScanLineWidth;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;9;-1159.654,241.2803;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1137.202,439.2269;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1259.486,-209.4429;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-913.2012,359.2269;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2;-997.2858,-166.6429;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;12;-731.6543,-119.7197;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;11;-725.6543,217.2803;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;13;-501.9543,209.0804;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;14;-492.401,47.96619;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-288.1893,310.9053;Inherit;False;Property;_ScanLineColor;ScanLineColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0.1091644,0.7048749,1,0;0,1.011765,1.498039,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-290.4242,81.45831;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;3.484741,133.5264;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-76.41797,-132.4991;Inherit;False;Property;_HologramColor1;HologramColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0.2584905,0.483906,1,0;0.2584905,0.483906,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;265.9749,-97.4256;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;498.8176,-29.65042;Inherit;False;FLOAT3;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;22;390.8176,68.34958;Inherit;False;Property;_Alpha;Alpha;4;0;Create;True;0;0;0;False;0;False;0;0.58;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;699.8176,-8.650421;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1133.924,28.66611;Float;False;True;-1;2;ASEMaterialInspector;100;1;HologramLine;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;6;0;4;0
WireConnection;9;0;6;0
WireConnection;8;0;7;0
WireConnection;8;1;5;0
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;2;0;1;1
WireConnection;12;0;2;0
WireConnection;12;1;9;0
WireConnection;11;0;2;0
WireConnection;11;1;10;0
WireConnection;13;0;11;0
WireConnection;14;0;12;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;20;0;19;0
WireConnection;21;0;20;0
WireConnection;21;3;22;0
WireConnection;0;0;21;0
ASEEND*/
//CHKSM=C0469703B5FC800023B6346D7FA7E3E523CF8B11