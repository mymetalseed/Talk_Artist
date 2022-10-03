Shader "Unlit/LightingModel"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Value ("_Value",Float) = 1
        _RangeValue("_RangeValue",Range(0,1)) = 0.5
        _Color("_Color",Color) = (0.5,0.3,0.2,1)

        _PhongExp("_PhongExp",Float) = 1
        _PhongScale("_PhongScale",Float) = 1

        _BlinnPhongExp("_BlinnPhongExp",Float) = 1
        _BlinnPhongScale("_BlinnPhongScale",Float) = 1
        _WrapValue("_WrapValue",Float) = 1

        [Space(5)]
        _CheapSSSValue("_CheapSSSValue",Float) = 0.5
        _CheapSSSExp("_CheapSSSExp",Float) = 1
        _CheapSSSScale("_CheapSSSScale",Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" "Queue" = "Geometry"}


        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fullforwardshadows
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityGlobalIllumination.cginc"
            #include "AutoLight.cginc"

            

            struct MeshData{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 vertexColor : COLOR;
            };

            struct vertex2FragmentData
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 tangent : TEXCOORD1;
                float3 bitangent : TEXCOORD2;
                float3 normal : TEXCOORD3;
                float3 worldPosition : TEXCOORD4;
                float3 localPosition : TEXCOORD5;
                float3 localNormal : TEXCOORD6;
                float4 vertexColor : TEXCOORD7;
                float2 uv2 : TEXCOORD8;
            };

            vertex2FragmentData vert (MeshData v)
            {
                vertex2FragmentData o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.uv2 = v.uv2;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul(unity_ObjectToWorld,v.vertex);
                o.localPosition = v.vertex.xyz;
                o.tangent = UnityObjectToWorldDir(v.tangent);
                o.bitangent = cross(o.normal,o.tangent) * v.tangent.w;
                o.localNormal = v.normal;
                o.vertexColor = v.vertexColor;
                return o;
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _PhongExp,_PhongScale;
            float _BlinnPhongExp,_BlinnPhongScale;
            float _WrapValue;
            float _CheapSSSValue,_CheapSSSExp,_CheapSSSScale;

            fixed4 frag (vertex2FragmentData i) : SV_Target
            {
                float3 N = normalize(i.normal);                 //世界空间 法线
                float3 L = normalize(UnityWorldSpaceLightDir(i.worldPosition.xyz));//世界空间光线
                float3 V = normalize(UnityWorldSpaceViewDir(i.worldPosition.xyz));//世界空间,视角
                float3 R = reflect(-L,N);   //世界空间 反射光线
                float3 H = normalize(L+V);  //世界空间,半角向量
                float NL = dot(N,L);

                float4 FinalColor = 0;
                float4 Diffuse = 0;
                float4 Specular = 0;

                float Lambert = NL;
                float HalfLambert = pow(NL*0.5+0.5,2);

                //这个效果可以实现类似于ramp的渐变(HanlfLambert,其中2就是分层数)
                float HalfLambertLine = floor((NL*0.5+0.5)*2)/2;
                //return HalfLambertLine;

                float DiffuseWrap = pow(dot(N,L)*_WrapValue + (1-_WrapValue),2);

                float VR = dot(V,R);
                float Phong = pow(VR,_PhongExp) * _PhongScale;
  
                float NH = dot(N,H);
                float BilnnPhong = pow(NH,_BlinnPhongExp)*_BlinnPhongScale;

                float4 BaseColor = tex2D(_MainTex,i.uv2);

                Diffuse = max(0,HalfLambert);
                Specular = max(0,BilnnPhong);

                float3 N_Shift = -normalize(N*_CheapSSSValue+L);//沿着光线方向向上偏移法线,最后再取反
                float BackLight = saturate(pow(saturate(dot(N_Shift,V)),_CheapSSSExp)*_CheapSSSScale);

                FinalColor = (Diffuse + BackLight)* BaseColor+ Specular;

                return FinalColor;
            }
            ENDCG
        }
    }
}
