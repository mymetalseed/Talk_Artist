Shader "Unlit/ParticelsShader"
{
    Properties
    {
        _Level("Level",int) = 0
        _DispDir("Displacement Direction",Vector) = (0,0,0)
        _uVelScale("VelScale",float) = 2
        _Speed("Speed",Range(0,1)) = 1
        _ShaderStartTime("Shader Start Time",float) = 0
        _FinalColor("Final Color",color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _BurnWidth ("_BurnWidth",Float) = 1
        [HDR] _BorderColor ("_BorderColor",Color) = (1,1,1,0)
        _Noise ("Noise",2D) = "white" {}
        _BuringValue ("_BuringValue",Float) = 1
        [HDR]_FrenelsColor("FrenelsColor",Color) = (1,1,1,1)
        _FrenelsPower("FrenelsPower",Range(0.1,10)) =1 
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        LOD 100
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
            uniform int _Level;
            uniform float3 _DispDir;
            uniform float _uVelScale;
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
            
            struct geometryOutput
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                fixed4 color : COLOR;
                float3 localPos : TEXCOORD1;
                float4 worldPostion : TEXCOORD2;
            }; 

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Noise;
            float4 _Noise_ST;
            float _BurnWidth;
            float4 _BorderColor;
            float _BuringValue;
            float4 _FrenelsColor;
            float _FrenelsPower;

            v2g vert (appdata v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv2, _MainTex);
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

           [maxvertexcount(3)]//v2g input[3]
           void geom(triangle v2g IN[3],inout TriangleStream<geometryOutput> OutputStream)
           {
                //找到中心点
				float3 center = (IN[0].vertex + IN[1].vertex + IN[2].vertex) / 3;
                //找到局部坐标的高度
                float offset = center.z * 5;
                //插值
                float ss_offset = lerp(0, 1, offset);
                //获得法线
			    float3 n0 = IN[0].normal;
				float3 n1 = IN[1].normal;
				float3 n2 = IN[2].normal;
                //根据高度计算消隐比率
                float disLv = clamp((abs(sin(0.1*_Time.y)+0.1) - ss_offset),0,1);
                //计算三角形位移距离
		        float3 translation = (n0 + n1 + n2) / 3 * disLv *_uVelScale;

                for(uint i=0;i<3;i++){
                    geometryOutput o;
                    UNITY_INITIALIZE_OUTPUT(geometryOutput,o);
                    v2g vet = IN[i];
                    //计算每个点的距离
                    float3 v = vet.vertex  + translation;
                    o.pos = UnityObjectToClipPos(v);
                    o.uv = vet.uv;
                    o.localPos = v;
                    o.color.a = clamp(1 - distance(v,center)*20,0,1);
                    o.worldPostion = vet.worldPostion;
                    o.normal = vet.normal;
                    OutputStream.Append(o);
                }
                /*下面代码是点化消散
                float time_SinceBirth = (unityTime - _ShaderStartTime) * 0.1f;
                g2f o = (g2f)o;
                V1 = (input[1].vertex - input[0].vertex).xyz;
                V2 = (input[2].vertex - input[0].vertex).xyz;
                V0 = input[0].vertex.xyz;

                //片心
                CG=(input[0].vertex.xyz + input[1].vertex.xyz+ input[2].vertex.xyz)/3.0f;

                //细分
                int numLayers = 1<<_Level;
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
                        float3 vel = _uVelScale * (v-CG);
                        //计算顶点根据时间计算的最终位置
                        v = CG + vel*(_Speed*time_SinceBirth+1.0f) + 0.5f*_DispDir.xyz*sin(it*is)*(_Speed*time_SinceBirth)*(_Speed*time_SinceBirth);
                        //生成的转到裁剪空间的三角形
                        o.vertex = UnityObjectToClipPos(float4( v, 1.0f ));
                        o.color=_FinalColor;
                        //o.color.w=1.0f-smoothstep(0,1.0f,time_SinceBirth);
                        //将生成的数据加入到流中
                        OutputStream.Append(o);
                        
                        //s加上偏移,计算下一个
                        s += ds;
                    }
                    t -= dt;

                    //t从1到0,s 从0到1
                } 
                */
           }

            fixed4 frag (geometryOutput i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float height = i.localPos.z + 0.01;

                //采样噪音
                float noise = tex2D(_Noise,i.uv).r;
                noise += 0.3;

                _BuringValue = abs(sin(0.1*_Time.y));

                float burn = _BuringValue * noise/3;
                float width = burn + _BurnWidth/10;
                
                clip(height - burn);
                float colLv = step(height,burn) + step(height,width);

                col = lerp(col,col*_BorderColor,colLv);

                //菲涅尔
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.worldPostion.xyz);
                float3 emissive = (_FrenelsColor.rgb*pow(1.0-max(0,dot(i.normal, viewDirection)),_FrenelsPower))+col.rgb;
                return fixed4(emissive,i.color.w);
            }
            ENDCG
        }
    }
}
