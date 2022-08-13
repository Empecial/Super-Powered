// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Hologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Effect Speed", Float) = 250
        _Alp ("LiveAlpha", Range(0.0,0.5)) = 0.25
        _Col ("Color", Color) = (1, 0, 0, 1)
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 100
        ZWrite Off
        Blend SrcAlpha One
        Cull Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 objVertex : TEXCOORD1;
            };

            float _Alp;
            float _Speed;
            sampler2D _MainTex;
            fixed4 _Col;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.objVertex = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float rand(float3 co)
            {
                return frac(sin(dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                col = _Col * cos(i.objVertex.y * 250 + _Time.x * _Speed) * .5;
                col.a = rand(_Alp);
                //col = _Col * max(0, cos(i.objVertex.y * 100));
                return col;
            }
            ENDCG
        }
    }
}
