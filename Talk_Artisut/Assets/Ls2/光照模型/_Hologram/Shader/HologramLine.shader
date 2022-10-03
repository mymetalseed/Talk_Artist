// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TA/Holohram/HologramLine"
{
	Properties
	{
		_FresnelExp("FresnelExp", Float) = 1
		_FresnelScale("FresnelScale", Float) = 1
		_Float1("Float 1", Range( 0 , 1)) = 0.5
		[HDR]_Color0("Color 0", Color) = (0.3716981,0.7857255,1,0)
		_HologramLine("HologramLine", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		_Height("Height",Float) = 10
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
		
		
		ZTest LEqual
		Offset 0 , 0
		
		Pass{
			Cull Front
			ZWrite On
			ColorMask 0
		}

		
		Pass	
		{	
			ZWrite Off
			Cull Off
				
					ColorMask RGBA
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True" }
			CGPROGRAM

	

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 localVertex : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color0;
			uniform sampler2D _HologramLine;
			uniform float4 _HologramLine_ST;
			uniform float _FresnelExp;
			uniform float _FresnelScale;
			uniform float _Float1;
			uniform float _Height;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
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

				o.localVertex = v.vertex;

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
				float2 uv_HologramLine = i.ase_texcoord1.xy * _HologramLine_ST.xy + _HologramLine_ST.zw;
				float4 tex2DNode29 = tex2D( _HologramLine, uv_HologramLine );
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float dotResult41 = dot( ase_worldNormal , ase_worldViewDir );
				float4 appendResult34 = (float4((( ( _Color0 * tex2DNode29 ) * ( pow( ( 1.0 - dotResult41 ) , _FresnelExp ) * _FresnelScale ) )).rgb , ( tex2DNode29.r * _Float1 )));
				
				
				finalColor = appendResult34;

				float a = lerp(0, _Height/500,  i.localVertex.y);
				finalColor.a = saturate(1 - a+0.6);
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
-94.66663;1080.667;1754.286;1156.143;-421.8023;-1029.579;1;True;False
Node;AmplifyShaderEditor.WorldNormalVector;43;967.3737,1215.15;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;42;964.3737,1399.15;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;41;1197.374,1303.15;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;1270.374,1456.15;Inherit;False;Property;_FresnelExp;FresnelExp;1;0;Create;True;0;0;0;False;0;False;1;3.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;1339.374,1368.15;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;1268.374,1558.15;Inherit;False;Property;_FresnelScale;FresnelScale;3;0;Create;True;0;0;0;False;0;False;1;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;1678.908,589.7211;Inherit;False;Property;_Color0;Color 0;8;1;[HDR];Create;True;0;0;0;False;0;False;0.3716981,0.7857255,1,0;0.3725491,0.7843137,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;29;1489.467,829.9434;Inherit;True;Property;_HologramLine;HologramLine;11;0;Create;True;0;0;0;False;0;False;-1;b6d11fb650791ab48944b18e40cc3213;b6d11fb650791ab48944b18e40cc3213;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;1912.203,687.488;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;40;1540.374,1390.15;Inherit;False;PowerScale;-1;;2;5ba70760a40e0a6499195a0590fd2e74;0;3;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;2030.802,821.5789;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;1888.467,1262.943;Inherit;False;Property;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;2152.134,929.2768;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;2163.467,1124.943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;457.4,447.3;Inherit;False;Property;_Alpha;Alpha;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;12;629.4,227.3;Inherit;False;True;True;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;23;876.8871,684.9336;Inherit;False;Remap01;-1;;3;;0;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;27;1398.467,649.9434;Inherit;False;True;True;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;599.8871,764.9336;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;352.6152,679.1862;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2;-360.6,140.3;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;19;363.8871,1011.934;Inherit;False;Property;_ULine;ULine;9;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;671.8871,907.9336;Inherit;False;Property;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;14.39996,109.3;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;952.7084,454.7416;Inherit;False;Property;_HoloColor;HoloColor;7;1;[HDR];Create;True;0;0;0;False;0;False;0.3716981,0.7857255,1,0;0.3716981,0.7857255,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;25;1512.467,534.9434;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;7;9.399963,336.3;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;22;1055.887,808.9336;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;5;215.4,131.3;Inherit;False;PowerScale;-1;;1;5ba70760a40e0a6499195a0590fd2e74;0;3;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-127.6,44.29999;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;1;-357.6,-43.70001;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;479.4,191.3;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1254.467,864.9434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-10.60004,225.3;Inherit;False;Property;_Exp;Exp;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;1250.467,559.9434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;1026.467,1006.943;Inherit;False;Property;_Float3;Float 3;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;876.4,253.3;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;16;771.6152,706.1862;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;18;346.8871,870.9336;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;2366.134,968.2768;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2585.498,892.1559;Float;False;True;-1;2;ASEMaterialInspector;100;1;TA/Holohram/HologramLine;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;41;0;43;0
WireConnection;41;1;42;0
WireConnection;44;0;41;0
WireConnection;39;0;38;0
WireConnection;39;1;29;0
WireConnection;40;1;44;0
WireConnection;40;2;46;0
WireConnection;40;3;45;0
WireConnection;47;0;39;0
WireConnection;47;1;40;0
WireConnection;33;0;47;0
WireConnection;37;0;29;1
WireConnection;37;1;36;0
WireConnection;27;0;24;0
WireConnection;17;0;14;1
WireConnection;17;1;18;0
WireConnection;17;2;19;0
WireConnection;4;0;3;0
WireConnection;25;0;27;0
WireConnection;25;3;28;0
WireConnection;22;1;21;0
WireConnection;5;1;4;0
WireConnection;5;2;6;0
WireConnection;5;3;7;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;8;0;5;0
WireConnection;28;0;22;0
WireConnection;28;1;26;0
WireConnection;24;1;22;0
WireConnection;13;0;12;0
WireConnection;13;3;10;0
WireConnection;16;0;17;0
WireConnection;34;0;33;0
WireConnection;34;3;37;0
WireConnection;0;0;34;0
ASEEND*/
//CHKSM=A69DC2FA8ED3739784E74BE6BA693A747C723135