Shader "课程/消融"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Noise ("Noise",2D) = "white" {}
        _BuringValue ("_BuringValue",Float) = 1
        _BurnWidth ("_BurnWidth",Float) = 1
        [HDR] _BorderColor ("_BorderColor",Color) = (1,1,1,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;   
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;//顶点法线
                float4 tangent : TANGENT;//顶点的切线
                float4 color : COLOR;//顶点颜色
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 worldNormal : TEXCOORD1;
                float3 localPosition : TEXCOORD2;
                float3 worldPosition : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Noise;
            float4 _Noise_ST;
            float _BuringValue;
            float _BurnWidth;
            float4 _BorderColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = mul(v.normal,unity_WorldToObject);
                o.localPosition = v.vertex.xyz;
                o.worldPosition = mul(unity_ObjectToWorld,v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float height = i.localPosition.y + 0.55;

                //采样噪音
                float noise = tex2D(_Noise,i.uv).r;
                noise += 0.3;

                float burn = _BuringValue * noise;
                float width = burn + _BurnWidth;
                
                clip(height - burn);
                float colLv = step(height,burn) + step(height,width);

                return lerp(col,col*_BorderColor,colLv);

                //clip(height - burn);

                //return col;
            }
            ENDCG
        }
    }
}
