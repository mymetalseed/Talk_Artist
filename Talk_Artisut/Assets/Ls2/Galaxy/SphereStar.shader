Shader "Unlit/SphereStar"
{
    Properties
    {
        _Level("Level",float) = 0
        _DispDir("Displacement Direction",Vector) = (0,0,0)
        _Speed("Speed",Range(0,1)) = 1
        _ShaderStartTime("Shader Start Time",float) = 0
        [HDR]_FinalColor("Final Color",color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        Cull Off

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha // use alpha blending
            cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom

            #include "UnityCG.cginc"
            //CPU输入变量
            ////细分相关变量
            uniform float _Level;
            uniform float3 _DispDir;
            ////粒子化特效相关变量
            uniform float _Speed;           //粒子位移速度
            uniform float _ShaderStartTime; //粒子化起始时间
            uniform fixed4 _FinalColor;     //粒子颜色

            //内部变量
            float3 V0,V1,V2;
            float3 CG;
            float unityTime;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float3 normal : NORMAL;
            };

            struct g2f{
                float4 vertex : SV_POSITION;
                fixed4 color: COLOR;
            };

            struct v2g
            {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD1;
                float4 worldPostion : TEXCOORD2;
            };

            v2g vert (appdata v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPostion = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

		    float3 randto3D(float3 seed)
			{
				float3 f = sin(float3(dot(seed, float3(127.1, 337.1, 256.2)), dot(seed, float3(129.8, 782.3, 535.3))
				, dot(seed, float3(269.5, 183.3, 337.1))));
				f = -1 + 2 * frac(f * 43785.5453123);
				return f;
			}

			float rand(float3 seed)
			{
				float f = sin(dot(seed, float3(127.1, 337.1, 256.2)));
				f = -1 + 2 * frac(f * 43785.5453123);
				return f;
			}

           [maxvertexcount(120)]//v2g input[3]
           void geom(triangle v2g input[3],inout PointStream<g2f> OutputStream)
           {
                float time_SinceBirth = (unityTime - _ShaderStartTime) * 0.1f;
                g2f o = (g2f)o;
                V1 = (input[1].vertex - input[0].vertex).xyz;
                V2 = (input[2].vertex - input[0].vertex).xyz;
                V0 = input[0].vertex.xyz;

                //片心
                CG=(input[0].vertex.xyz + input[1].vertex.xyz+ input[2].vertex.xyz)/3.0f;

                //细分
                int numLayers = floor(pow(2,_Level));
                //细分层数
                float dt = 1.0f / float(numLayers);
                float t = 1.0f;
                for(int it=0;it<numLayers;it++){
                    //距离V0点的偏移
                    float smax = 1.0f - t;
                    //每层生成的三角形数量
                    int nums = it + 1;
                    //三角形边长
                    float ds = clamp(smax / float(nums - 1),0,1);
                    float s = 0;
                    //计算每层的第i个三角形的数据
                    for(int is = 0;is<nums;is++){
                        float3 v = V0 + s*(V1) + t*V2;

                        v = randto3D(v);

                        o.vertex = UnityObjectToClipPos(float4( v, 1.0f ));
                        o.color=clamp(((rand(v)*_SinTime*100)),0.5,1)+_FinalColor;
                        //o.color.w=1.0f-smoothstep(0,1.0f,time_SinceBirth);
                        //将生成的数据加入到流中
                        OutputStream.Append(o);
                        
                        //s加上偏移,计算下一个
                        s += ds;
                    }
                    t -= dt;

                    //t从1到0,s 从0到1
                } 
           }

            fixed4 frag (g2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}
