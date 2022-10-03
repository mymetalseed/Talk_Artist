// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TA/Holohram/HologramLand"
{
	Properties
	{
		_Alpha("Alpha", Range( 0 , 1)) = 0.5
		[HDR]_HoloColor("HoloColor", Color) = (0.3716981,0.7857255,1,0)
		[HDR]_HoloPointColor("HoloPointColor", Color) = (0.3716981,0.7857255,1,0)
		_UVScale("UVScale", Float) = 3
		_ScanLineWidth("ScanLineWidth", Float) = 0
		HeightScanTimeScale("HeightScanTimeScale", Float) = 0
		_MaxScanDistance("MaxScanDistance", Float) = 10
		_MaxHeightScan("MaxHeightScan", Float) = 10
		_ScanLineColor("ScanLineColor", Color) = (0.1091644,0.7048749,1,0)
		ScanLine_Speed("ScanLine_Speed", Float) = 0.5
		_WorldY("World Y", Float) = -4
		_HeightScanIntensity("HeightScanIntensity", Float) = 10

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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
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

			uniform float4 _HoloColor;
			uniform float4 _HoloPointColor;
			uniform float _UVScale;
			uniform float _WorldY;
			uniform float _MaxHeightScan;
			uniform float HeightScanTimeScale;
			uniform float _HeightScanIntensity;
			uniform float _MaxScanDistance;
			uniform float ScanLine_Speed;
			uniform float _ScanLineWidth;
			uniform float4 _ScanLineColor;
			uniform float _Alpha;
			uniform float _Height;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.vertex;
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
				float2 temp_cast_1 = (( 0.01 * 10.0 )).xx;
				float2 break26 = step( frac( (( i.ase_texcoord1.xyz * _UVScale )).xz ) , temp_cast_1 );
				float temp_output_81_0 = saturate( ( max( ( WorldPosition.y - _WorldY ) , 0.0 ) / _MaxHeightScan ) );
				float mulTime84 = _Time.y * HeightScanTimeScale;
				float temp_output_85_0 = frac( mulTime84 );
				float HeightLine96 = ( ( step( temp_output_81_0 , ( temp_output_85_0 + ( 0.01 * 3.0 ) ) ) - step( temp_output_81_0 , temp_output_85_0 ) ) * _HeightScanIntensity * temp_output_81_0 );
				float temp_output_41_0 = ( distance( float3(0,0,0) , WorldPosition ) / _MaxScanDistance );
				float mulTime45 = _Time.y * ScanLine_Speed;
				float temp_output_46_0 = frac( mulTime45 );
				float temp_output_68_0 = saturate( temp_output_41_0 );
				float4 ScanLine58 = ( ( saturate( step( temp_output_41_0 , ( temp_output_46_0 + ( 0.01 * _ScanLineWidth ) ) ) ) - saturate( step( temp_output_68_0 , temp_output_46_0 ) ) ) * _ScanLineColor );
				float4 FinalColor59 = ( ( float4( (( float4( 0,0,0,0 ) * _HoloColor )).rgb , 0.0 ) + ( _HoloPointColor * ( break26.x + break26.y ) * ( HeightLine96 + 1.0 ) ) ) + ScanLine58 );
				float4 appendResult13 = (float4(FinalColor59.rgb , _Alpha));
				
			
				
				finalColor = appendResult13;


				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
6.4;136;1523.2;659;-473.0536;-392.1174;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;104;-1023.966,1331.503;Inherit;False;2176.376;796.7153;网格线 从下往上扫描 ScanLine;20;102;84;89;93;88;90;81;91;101;96;86;94;82;103;83;78;80;87;85;100;网格线 从下往上扫描 ScanLine;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;82;-962.9664,1372.503;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;83;-949.1109,1529.574;Inherit;False;Property;_WorldY;World Y;14;0;Create;True;0;0;0;False;0;False;-4;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;102;-738.9032,1435.031;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-572.8961,1671.843;Inherit;False;Property;HeightScanTimeScale;HeightScanTimeScale;7;0;Create;False;0;0;0;False;0;False;0;1.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;103;-578.9036,1430.031;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;84;-345.7358,1672.332;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;63;-1076.947,2215.654;Inherit;False;2413.796;1048.045;从上往下扫描 ScanLine;25;58;66;65;55;43;53;52;47;41;50;39;56;42;46;57;49;35;45;38;64;68;70;74;75;76;从上往下扫描 ScanLine;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-450.0308,1848.468;Inherit;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-457.0537,1929.507;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-606.5061,1533.303;Inherit;False;Property;_MaxHeightScan;MaxHeightScan;9;0;Create;True;0;0;0;False;0;False;10;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-906.7432,2825.996;Inherit;False;Property;ScanLine_Speed;ScanLine_Speed;11;0;Create;False;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;38;-1004.044,2316.654;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;33;-510.6107,692.5514;Inherit;False;1378.188;415.6637;网格线条;11;17;31;32;20;19;16;15;24;18;25;26;网格线条;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;35;-1019.947,2471.177;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;80;-326.2473,1445.359;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;85;-177.7354,1670.332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-223.8959,1869.844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;39;-686.0443,2426.654;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;45;-719.2281,2832.032;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-695.1866,3056.236;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-403.6847,883.3904;Inherit;False;Property;_UVScale;UVScale;5;0;Create;True;0;0;0;False;0;False;3;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;32;-449.0673,738.3704;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;81;-41.81945,1496.321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-754.4865,2556.976;Inherit;False;Property;_MaxScanDistance;MaxScanDistance;8;0;Create;True;0;0;0;False;0;False;10;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-38.03067,1840.468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-722.0519,3140.612;Inherit;False;Property;_ScanLineWidth;ScanLineWidth;6;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-199.7716,803.5403;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-526.0519,3063.612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;46;-537.2275,2826.032;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;41;-492.2274,2459.032;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;91;196.104,1810.844;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;86;194.8842,1639.888;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2.341007,992.9294;Inherit;False;Constant;_Float4;Float 4;4;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-8.628596,905.0739;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;510.7033,1759.978;Inherit;False;Property;_HeightScanIntensity;HeightScanIntensity;15;0;Create;True;0;0;0;False;0;False;10;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;-350.8001,2328.995;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;372.6957,1601.619;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;16;-35.54949,816.2787;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-236.1869,2910.235;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;15;216.4503,832.2787;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;705.7032,1557.978;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;52;-30.05239,2879.613;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;47;-35.22818,2773.032;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;207.7402,911.4977;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;34;-396.894,-161.0369;Inherit;False;1278.857;584.4286;Fresnel;10;2;1;3;7;4;6;5;9;8;12;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;43;164.7724,2560.032;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;53;114.9481,2881.613;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;927.9799,1548.067;Inherit;False;HeightLine;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;17;409.2492,827.9166;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;9;234.106,214.963;Inherit;False;Property;_HoloColor;HoloColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0.3716981,0.7857255,1,0;0,0.9568627,2,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;97;542.4363,1153.352;Inherit;False;96;HeightLine;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;565.4363,1232.352;Inherit;False;Constant;_Float5;Float 5;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;338.9481,2644.612;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;301.483,2809.259;Inherit;False;Property;_ScanLineColor;ScanLineColor;10;0;Create;True;0;0;0;False;0;False;0.1091644,0.7048749,1,0;0.09099322,0.2577212,0.3396226,0.8078431;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;26;541.7327,828.6173;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;30;703.7587,493.0255;Inherit;False;Property;_HoloPointColor;HoloPointColor;4;1;[HDR];Create;True;0;0;0;False;0;False;0.3716981,0.7857255,1,0;0.02927163,0.4390744,0.8488771,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;598.157,2472.881;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;703.0062,827.8264;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;764.4363,1160.352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;493.106,123.9631;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;767.9391,2477.694;Inherit;False;ScanLine;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;948.7587,489.0255;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;12;628.1061,135.963;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;1080.699,144.9128;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;1199.154,393.1846;Inherit;False;58;ScanLine;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;1417.154,160.1846;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;1636.145,137.1462;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;76;40.36237,2308.268;Inherit;False;277.7143;206.8572;扫描线 渐出;1;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;10;2356.077,951.5286;Inherit;False;Property;_Alpha;Alpha;2;0;Create;True;0;0;0;False;0;False;0.5;0.463;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;2454.259,855.8812;Inherit;False;59;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;70;-156.8283,2327.145;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;1;-356.894,-81.0369;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;71;80.36263,2353.268;Inherit;False;PowerScale;-1;;3;;0;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;2679.003,885.8629;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-113.8939,-23.03695;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;5;229.106,63.96308;Inherit;False;PowerScale;-1;;2;;0;0;0
Node;AmplifyShaderEditor.RangedFloatNode;6;3.10605,157.963;Inherit;False;Property;_Exp;Exp;0;0;Create;True;0;0;0;False;0;False;1;4.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;23.10606,268.9628;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;0;False;0;False;1;1.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2;-346.894,72.96306;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;4;28.10605,41.96308;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-194.6378,2404.268;Inherit;False;Property;_ScanLine_FadeExp;ScanLine_FadeExp;12;0;Create;True;0;0;0;False;0;False;3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-222.6378,2470.268;Inherit;False;Property;_ScanLine_FadeScale;ScanLine_FadeScale;13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2861.252,871.6906;Float;False;True;-1;2;ASEMaterialInspector;100;1;TA/Holohram/HologramLand;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;102;0;82;2
WireConnection;102;1;83;0
WireConnection;103;0;102;0
WireConnection;84;0;87;0
WireConnection;80;0;103;0
WireConnection;80;1;78;0
WireConnection;85;0;84;0
WireConnection;88;0;89;0
WireConnection;88;1;93;0
WireConnection;39;0;38;0
WireConnection;39;1;35;0
WireConnection;45;0;64;0
WireConnection;81;0;80;0
WireConnection;90;0;85;0
WireConnection;90;1;88;0
WireConnection;19;0;32;0
WireConnection;19;1;20;0
WireConnection;56;0;49;0
WireConnection;56;1;57;0
WireConnection;46;0;45;0
WireConnection;41;0;39;0
WireConnection;41;1;42;0
WireConnection;91;0;81;0
WireConnection;91;1;90;0
WireConnection;86;0;81;0
WireConnection;86;1;85;0
WireConnection;68;0;41;0
WireConnection;94;0;91;0
WireConnection;94;1;86;0
WireConnection;16;0;19;0
WireConnection;50;0;46;0
WireConnection;50;1;56;0
WireConnection;15;0;16;0
WireConnection;100;0;94;0
WireConnection;100;1;101;0
WireConnection;100;2;81;0
WireConnection;52;0;41;0
WireConnection;52;1;50;0
WireConnection;47;0;68;0
WireConnection;47;1;46;0
WireConnection;24;0;18;0
WireConnection;24;1;25;0
WireConnection;43;0;47;0
WireConnection;53;0;52;0
WireConnection;96;0;100;0
WireConnection;17;0;15;0
WireConnection;17;1;24;0
WireConnection;55;0;53;0
WireConnection;55;1;43;0
WireConnection;26;0;17;0
WireConnection;66;0;55;0
WireConnection;66;1;65;0
WireConnection;31;0;26;0
WireConnection;31;1;26;1
WireConnection;98;0;97;0
WireConnection;98;1;99;0
WireConnection;8;1;9;0
WireConnection;58;0;66;0
WireConnection;29;0;30;0
WireConnection;29;1;31;0
WireConnection;29;2;98;0
WireConnection;12;0;8;0
WireConnection;28;0;12;0
WireConnection;28;1;29;0
WireConnection;62;0;28;0
WireConnection;62;1;61;0
WireConnection;59;0;62;0
WireConnection;70;0;68;0
WireConnection;13;0;60;0
WireConnection;13;3;10;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;4;0;3;0
WireConnection;0;0;13;0
ASEEND*/
//CHKSM=42B523C117AF27D15CD71BBA562435EB3788B5C6