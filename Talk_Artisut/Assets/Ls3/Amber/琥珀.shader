// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "琥珀"
{
	Properties
	{
		_Height("Height", Float) = 0
		_Scale("Scale", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_FresnelColor("FresnelColor", Color) = (0,0,0,1)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Angle("Angle", Range( 0 , 1)) = 0
		_BubbleUVScale("BubbleUVScale", Float) = 0
		_Float2("Float 2", Float) = 0
		_Float3("Float 3", Float) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_LambertColor("LambertColor", Color) = (0,0,0,0)
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_SpecularNormalMapIntensity("SpecularNormalMapIntensity", Range( 0 , 1)) = 0
		_SpecularVector("SpecularVector", Vector) = (0,0,0,0)
		_SpecularColor("SpecularColor", Color) = (0,0,0,0)
		_TextureSample5("Texture Sample 5", 2D) = "white" {}
		_MatCapIntensity("MatCapIntensity", Float) = 0
		_MatCapColor("MatCapColor", Color) = (0,0,0,0)
		_TextureSample6("Texture Sample 6", 2D) = "white" {}
		_CubeMapIntensity("CubeMapIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
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
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityStandardBRDF.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
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
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			//This is a late directive
			
			uniform sampler2D _TextureSample2;
			uniform float _BubbleUVScale;
			uniform float _Float2;
			uniform float _Float3;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float _Angle;
			uniform sampler2D _TextureSample6;
			uniform float _CubeMapIntensity;
			uniform float4 _LambertColor;
			uniform sampler2D _TextureSample0;
			uniform float _Height;
			uniform float _Scale;
			uniform float4 _FresnelColor;
			uniform sampler2D _TextureSample5;
			uniform float _MatCapIntensity;
			uniform float4 _MatCapColor;
			uniform sampler2D _TextureSample3;
			uniform float4 _TextureSample3_ST;
			uniform float _SpecularNormalMapIntensity;
			uniform float2 _SpecularVector;
			uniform float4 _SpecularColor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
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
				float2 texCoord36 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float2 Offset39 = ( ( _Float2 - 1 ) * ase_worldViewDir.xy * _Float3 ) + ( texCoord36 * _BubbleUVScale );
				float2 BubbleUV43 = Offset39;
				float4 color49 = IsGammaSpace() ? float4(0,0,0,1) : float4(0,0,0,1);
				float4 BubbleTex50 = ( ( tex2D( _TextureSample2, BubbleUV43 ) + float4( 0,0,0,0 ) ) * color49 );
				float2 uv_TextureSample1 = i.ase_texcoord1.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal18 = UnpackNormal( tex2D( _TextureSample1, uv_TextureSample1 ) );
				float3 worldNormal18 = float3(dot(tanToWorld0,tanNormal18), dot(tanToWorld1,tanNormal18), dot(tanToWorld2,tanNormal18));
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(WorldPosition);
				float3 lerpResult19 = lerp( worldNormal18 , worldSpaceLightDir , _Angle);
				float3 normalizeResult23 = normalize( lerpResult19 );
				float dotResult25 = dot( -normalizeResult23 , ase_worldViewDir );
				float4 color33 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 CheapSSS34 = ( ( pow( saturate( dotResult25 ) , 0.0 ) * 0.0 ) * color33 );
				float4 tex2DNode106 = tex2D( _TextureSample6, reflect( -ase_worldViewDir , ase_worldNormal ).xy );
				float fresnelNdotV109 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode109 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV109, 5.0 ) );
				float4 CubeMap111 = ( ( tex2DNode106 * tex2DNode106 ) * fresnelNode109 * _CubeMapIntensity );
				float dotResult65 = dot( ase_worldNormal , worldSpaceLightDir );
				float temp_output_66_0 = saturate( dotResult65 );
				float4 Lambert69 = ( temp_output_66_0 * _LambertColor );
				float2 texCoord2 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = Unity_SafeNormalize( ase_tanViewDir );
				float2 Offset3 = ( ( _Height - 1 ) * ase_tanViewDir.xy * _Scale ) + texCoord2;
				float2 ParallaxUV7 = Offset3;
				float3 tanNormal11 = UnpackNormal( tex2D( _TextureSample0, ParallaxUV7 ) );
				float3 worldNormal11 = normalize( float3(dot(tanToWorld0,tanNormal11), dot(tanToWorld1,tanNormal11), dot(tanToWorld2,tanNormal11)) );
				float fresnelNdotV12 = dot( worldNormal11, ase_worldViewDir );
				float fresnelNode12 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV12 , 0.0001 ), 5.0 ) );
				float4 FresnelOut15 = ( fresnelNode12 * _FresnelColor );
				float3 worldToViewDir93 = mul( UNITY_MATRIX_V, float4( ase_worldNormal, 0 ) ).xyz;
				float4 MatCap100 = ( tex2D( _TextureSample5, ( ( worldToViewDir93 * _MatCapIntensity ) + _MatCapIntensity ).xy ) * _MatCapColor );
				float SaturateNL87 = temp_output_66_0;
				float2 uv_TextureSample3 = i.ase_texcoord1.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float3 tanNormal71 = UnpackNormal( tex2D( _TextureSample3, uv_TextureSample3 ) );
				float3 worldNormal71 = float3(dot(tanToWorld0,tanNormal71), dot(tanToWorld1,tanNormal71), dot(tanToWorld2,tanNormal71));
				float3 lerpResult74 = lerp( worldNormal71 , ase_worldNormal , _SpecularNormalMapIntensity);
				float3 normalizeResult80 = normalize( ( worldSpaceLightDir + ase_worldViewDir ) );
				float dotResult76 = dot( lerpResult74 , normalizeResult80 );
				float4 Specular90 = ( ( pow( saturate( dotResult76 ) , _SpecularVector.x ) * _SpecularVector.y ) * _SpecularColor * SaturateNL87 );
				
				
				finalColor = ( BubbleTex50 + CheapSSS34 + CubeMap111 + Lambert69 + FresnelOut15 + MatCap100 + float4( ParallaxUV7, 0.0 , 0.0 ) + SaturateNL87 + Specular90 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
6.4;134.4;1523.2;642.2;1833.628;903.9347;1.170587;True;True
Node;AmplifyShaderEditor.CommentaryNode;16;-1941.132,-6.714057;Inherit;False;2436.718;539.9289;CheapSSS;17;33;26;25;24;23;22;20;28;19;17;29;31;30;18;27;32;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;17;-1906.863,94.48399;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1631.421,379.6111;Inherit;False;Property;_Angle;Angle;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;-3427.503,49.99599;Inherit;False;1253.173;627.7289;BubbleParallaxUV;8;43;41;40;38;36;39;37;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;20;-1594.421,219.6111;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;18;-1578.421,65.61112;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;70;-1531.414,2704.331;Inherit;False;2040.357;1028.29;Specular;18;90;74;81;78;84;72;83;75;77;79;85;76;86;82;80;73;71;89;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;-3011.462,-749.9631;Inherit;False;823;680;视察UV;6;2;3;4;5;6;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;19;-1334.421,103.6111;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2947.461,-541.963;Inherit;False;Property;_Height;Height;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-2969.461,-300.963;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3301.369,115.368;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-3287.369,254.368;Inherit;False;Property;_BubbleUVScale;BubbleUVScale;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;-1488.269,2804.987;Inherit;True;Property;_TextureSample3;Texture Sample 3;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2977.462,-692.963;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;79;-1271.27,3474.987;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;5;-2949.461,-440.9631;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;77;-1282.27,3305.987;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;23;-1136.42,106.6111;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-3055.369,375.3682;Inherit;False;Property;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;-470.0688,2131.01;Inherit;False;981;474;Diffuse 漫反射 Lambert;8;65;68;64;62;66;67;69;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-3048.369,160.368;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-3054.369,279.368;Inherit;False;Property;_Float2;Float 2;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;3;-2672.46,-559.963;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;101;-1237.374,4685.822;Inherit;False;1744.292;688.3037;CubeMap;10;111;108;105;103;104;110;107;109;106;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;91;-1235.393,3869.471;Inherit;False;1743.071;694.187;MatCap;9;100;95;98;93;92;96;97;94;99;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;73;-1163.27,2991.987;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;71;-1166.27,2809.987;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-1012.27,3339.987;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1180.27,3169.987;Inherit;False;Property;_SpecularNormalMapIntensity;SpecularNormalMapIntensity;16;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;42;-3050.369,483.3681;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;26;-1019.42,249.6111;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;62;-427.0688,2183.01;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;64;-429.0688,2360.01;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-2418.46,-549.963;Inherit;False;ParallaxUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;80;-812.2701,3322.987;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;24;-957.4205,104.6111;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;8;-1156.624,-615.021;Inherit;False;1630.59;480.4361;Fresnel;7;14;15;12;11;10;9;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;102;-1162.374,4773.822;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;92;-1147.238,3974.413;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ParallaxMappingNode;39;-2754.369,203.368;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;74;-856.2701,2910.987;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-2478.37,204.368;Inherit;False;BubbleUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;25;-738.4205,145.6111;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;65;-157.0688,2276.01;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-1124.92,-548.5851;Inherit;False;7;ParallaxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;103;-963.3739,4794.822;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;105;-1007.374,4972.822;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;76;-606.27,2944.987;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;93;-904.2375,4009.413;Inherit;False;World;View;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;95;-884.2375,4239.415;Inherit;False;Property;_MatCapIntensity;MatCapIntensity;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;44;-713.6657,650.5694;Inherit;False;1217.518;496.7289;Bubble;6;46;45;47;48;50;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;66;-2.877878,2281.795;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ReflectOpNode;104;-780.374,4822.822;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;81;-438.27,2939.987;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-513.4202,122.6111;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-862.7674,-550.9857;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;45;-673.4322,709.4413;Inherit;False;43;BubbleUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-563.4203,252.6111;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-665.2375,3980.413;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;83;-437.27,3163.987;Inherit;False;Property;_SpecularVector;SpecularVector;17;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;106;-515.3739,4781.822;Inherit;True;Property;_TextureSample6;Texture Sample 6;22;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-366.2177,358.0048;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;28;-349.4202,125.6111;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;11;-534.9879,-546.5319;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-499.2376,4033.414;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;46;-440.691,705.3486;Inherit;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;89;-176.9064,3477.96;Inherit;False;255.6;165.3999;不希望高光在暗部出现;1;88;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;82;-230.2699,3018.987;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;129.4246,2197.274;Inherit;False;SaturateNL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;49;-128.9249,936.5023;Inherit;False;Constant;_Color1;Color 1;10;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;109;-260.374,5077.822;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;97;-301.2376,3966.413;Inherit;True;Property;_TextureSample5;Texture Sample 5;19;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-162.2178,128.0047;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-55.26992,3067.987;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-90.0906,730.7617;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;68;-157.0688,2409.01;Inherit;False;Property;_LambertColor;LambertColor;14;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;110;-272.3739,5256.822;Inherit;False;Property;_CubeMapIntensity;CubeMapIntensity;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;99;-145.2375,4198.415;Inherit;False;Property;_MatCapColor;MatCapColor;21;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-169.2178,305.0048;Inherit;False;Constant;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;86;-146.2699,3244.987;Inherit;False;Property;_SpecularColor;SpecularColor;18;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;12;-279.049,-550.4263;Inherit;False;Standard;WorldNormal;ViewDir;False;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-265.5925,-355.5631;Inherit;False;Property;_FresnelColor;FresnelColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;88;-126.9064,3527.96;Inherit;False;87;SaturateNL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-151.3739,4863.822;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;115.6154,737.8434;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;139.7625,4056.414;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;66.73125,170.6242;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;90.62602,4902.822;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;14.45216,-530.0148;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;128.7302,3133.987;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;154.9947,2297.519;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;300.5802,839.5616;Inherit;False;BubbleTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;293.6262,4954.822;Inherit;False;CubeMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;308.1881,2350.9;Inherit;False;Lambert;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;306.0938,3158.96;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;285.9905,169.0361;Inherit;False;CheapSSS;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;306.7624,4044.414;Inherit;False;MatCap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;250.2631,-527.8029;Inherit;False;FresnelOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;1324.124,1266.429;Inherit;False;50;BubbleTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;1363.424,2122.105;Inherit;False;87;SaturateNL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;51;-1059.272,1292.243;Inherit;False;1577.944;740.7443;FlowNoise;9;60;59;55;56;53;52;54;58;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;1350.424,2224.804;Inherit;False;90;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;1331.518,1518.847;Inherit;False;111;CubeMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;1377.88,1780.539;Inherit;False;15;FresnelOut;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;1338.729,1406.548;Inherit;False;34;CheapSSS;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;1368.608,1674.42;Inherit;False;69;Lambert;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;1355.625,2015.504;Inherit;False;7;ParallaxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;1371.721,1904.45;Inherit;False;100;MatCap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;1353.154,1584.786;Inherit;False;60;FlowNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;53;-678.8495,1393.297;Inherit;True;Property;_amber_mix;amber_mix;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;55;-141.8495,1428.297;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;59;-188.8496,1653.297;Inherit;False;Property;_FlowNoiseColor;FlowNoiseColor;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;52;-968.4658,1374.2;Inherit;False;7;ParallaxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;113;1601.451,1346.791;Inherit;False;9;9;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;FLOAT2;0,0;False;7;FLOAT;0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-347.8495,1414.297;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;99.15046,1463.297;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;294.424,1489.542;Inherit;False;FlowNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;-510.8495,1818.297;Inherit;False;Property;_NoiseColor2;NoiseColor2;13;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;56;-514.8495,1613.297;Inherit;False;Property;_NoiseColor;NoiseColor;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1858.37,1473.198;Float;False;True;-1;2;ASEMaterialInspector;100;1;琥珀;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;18;0;17;0
WireConnection;19;0;18;0
WireConnection;19;1;20;0
WireConnection;19;2;22;0
WireConnection;23;0;19;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;3;2;5;0
WireConnection;3;3;6;0
WireConnection;71;0;72;0
WireConnection;78;0;77;0
WireConnection;78;1;79;0
WireConnection;7;0;3;0
WireConnection;80;0;78;0
WireConnection;24;0;23;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;39;2;41;0
WireConnection;39;3;42;0
WireConnection;74;0;71;0
WireConnection;74;1;73;0
WireConnection;74;2;75;0
WireConnection;43;0;39;0
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;65;0;62;0
WireConnection;65;1;64;0
WireConnection;103;0;102;0
WireConnection;76;0;74;0
WireConnection;76;1;80;0
WireConnection;93;0;92;0
WireConnection;66;0;65;0
WireConnection;104;0;103;0
WireConnection;104;1;105;0
WireConnection;81;0;76;0
WireConnection;27;0;25;0
WireConnection;10;1;9;0
WireConnection;94;0;93;0
WireConnection;94;1;95;0
WireConnection;106;1;104;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;11;0;10;0
WireConnection;96;0;94;0
WireConnection;96;1;95;0
WireConnection;46;1;45;0
WireConnection;82;0;81;0
WireConnection;82;1;83;1
WireConnection;87;0;66;0
WireConnection;97;1;96;0
WireConnection;30;0;28;0
WireConnection;30;1;31;0
WireConnection;84;0;82;0
WireConnection;84;1;83;2
WireConnection;47;0;46;0
WireConnection;12;0;11;0
WireConnection;107;0;106;0
WireConnection;107;1;106;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;98;0;97;0
WireConnection;98;1;99;0
WireConnection;32;0;30;0
WireConnection;32;1;33;0
WireConnection;108;0;107;0
WireConnection;108;1;109;0
WireConnection;108;2;110;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;85;0;84;0
WireConnection;85;1;86;0
WireConnection;85;2;88;0
WireConnection;67;0;66;0
WireConnection;67;1;68;0
WireConnection;50;0;48;0
WireConnection;111;0;108;0
WireConnection;69;0;67;0
WireConnection;90;0;85;0
WireConnection;34;0;32;0
WireConnection;100;0;98;0
WireConnection;15;0;13;0
WireConnection;53;1;52;0
WireConnection;55;0;56;0
WireConnection;55;1;57;0
WireConnection;55;2;54;0
WireConnection;113;0;112;0
WireConnection;113;1;114;0
WireConnection;113;2;115;0
WireConnection;113;3;117;0
WireConnection;113;4;118;0
WireConnection;113;5;119;0
WireConnection;113;6;120;0
WireConnection;113;7;121;0
WireConnection;113;8;122;0
WireConnection;54;0;53;2
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;60;0;58;0
WireConnection;0;0;113;0
ASEEND*/
//CHKSM=AE5A4558EDA12FD007FB1CAD7AFE8D66DF459729