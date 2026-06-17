Shader "Hidden/Enti/SnowFade"
{
    Properties
    {
        _MainTex("Main Tex", 2D) = "black" {}
        _FadeAmount("Fade Amount", Float) = 0.98
    }

        SubShader
        {
            Tags { "RenderPipeline" = "UniversalRenderPipeline" }

            Pass
            {
                ZWrite Off
                ZTest Always
                Cull Off

                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);

                float _FadeAmount;

                struct Attributes
                {
                    float4 positionOS : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct Varyings
                {
                    float4 positionHCS : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                Varyings vert(Attributes IN)
                {
                    Varyings OUT;
                    OUT.positionHCS = float4(IN.positionOS.xy, 0, 1);
                    OUT.uv = IN.uv;
                    return OUT;
                }

                half4 frag(Varyings IN) : SV_Target
                {
                    half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                    col *= _FadeAmount;
                    return col;
                }

                ENDHLSL
            }
        }
}