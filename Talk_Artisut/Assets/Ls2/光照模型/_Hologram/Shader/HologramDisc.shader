// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HologramDisc"
{
	Properties
	{
		_HologramColor("HologramColor", Color) = (0,0.5835931,1,0)
		_Alpha("Alpha", Range( 0 , 1)) = 0.5

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
				float mulTime13 = _Time.y * 0.1;
				float temp_output_14_0 = frac( mulTime13 );
				float2 CenteredUV15_g3 = ( i.ase_texcoord1.xy - float2( 0.5,0.5 ) );
				float2 break17_g3 = CenteredUV15_g3;
				float2 appendResult23_g3 = (float2(( length( CenteredUV15_g3 ) * 1.0 * 2.0 ) , ( atan2( break17_g3.x , break17_g3.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
				float temp_output_12_0 = (0.0 + (appendResult23_g3.y - -0.5) * (1.0 - 0.0) / (0.5 - -0.5));
				float3 appendResult27 = (float3(( _HologramColor + ( step( temp_output_14_0 , temp_output_12_0 ) - step( ( temp_output_14_0 + 0.01 ) , temp_output_12_0 ) ) ).rgb));
				float4 appendResult28 = (float4(appendResult27 , _Alpha));
				
				
				finalColor = appendResult28;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
134.8571;57.14286;1809.714;1116.143;503.3833;412.4722;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;20;-1029.429,25.78574;Inherit;False;Constant;_Float4;Float 4;2;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;7;-1350.429,335.7858;Inherit;True;Polar Coordinates;-1;;3;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;13;-897.429,28.78574;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;14;-730.4287,32.78574;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;11;-989.429,346.7857;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;18;-757.4287,164.7857;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;12;-560.4287,418.7857;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;0.5;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-579.4287,148.7857;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;19;-193.4287,312.7857;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;10;-226.4287,-30.21426;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;20.3714,-222.5715;Inherit;False;Property;_HologramColor;HologramColor;0;0;Create;True;0;0;0;False;0;False;0,0.5835931,1,0;0,0.8216958,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;51.7262,150.8915;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;350.4887,-66.95657;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;568.6887,-43.25658;Inherit;False;FLOAT3;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;460.7887,99.74339;Inherit;False;Property;_Alpha;Alpha;1;0;Create;True;0;0;0;False;0;False;0.5;0.226;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;781.8887,-39.25659;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1038.9,-39.80001;Float;False;True;-1;2;ASEMaterialInspector;100;1;HologramDisc;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;13;0;20;0
WireConnection;14;0;13;0
WireConnection;11;0;7;0
WireConnection;12;0;11;1
WireConnection;17;0;14;0
WireConnection;17;1;18;0
WireConnection;19;0;17;0
WireConnection;19;1;12;0
WireConnection;10;0;14;0
WireConnection;10;1;12;0
WireConnection;21;0;10;0
WireConnection;21;1;19;0
WireConnection;26;0;2;0
WireConnection;26;1;21;0
WireConnection;27;0;26;0
WireConnection;28;0;27;0
WireConnection;28;3;29;0
WireConnection;0;0;28;0
ASEEND*/
//CHKSM=1ECED57FF3C9A9467F23BB3B8C84ACD9C7C0CD7B