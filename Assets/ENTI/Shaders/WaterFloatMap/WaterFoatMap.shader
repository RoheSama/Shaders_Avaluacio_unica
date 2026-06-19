Shader "Custom/WaterFlowMap"
{
    Properties
    {
        [Header(Surface Inputs)]
        _WaterColor("Water Color", Color) = (0.45, 0.95, 1, 1)
        _Metallic("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0, 1)) = 0.9
        _Tiling("Tiling", Vector) = (1, 1, 0, 0)

        _WaterTexture("WaterTexture", 2D) = "white" {}

        [Header(Normals)]
        _NormalMap("Normals", 2D) = "bump" {}
        _Strength("Strength", Range(0, 1)) = 0.1
        _Speed("Speed", Range(0, 5)) = 0.7
    }

        SubShader
        {
            Tags
            {
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Opaque"
                "Queue" = "Geometry"
            }

            Pass
            {
                Name "ForwardLit"
                Tags { "LightMode" = "UniversalForward" }

                HLSLPROGRAM

                #pragma vertex vert
                #pragma fragment frag

                #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
                #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
                #pragma multi_compile _ _ADDITIONAL_LIGHTS
                #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
                #pragma multi_compile _ _SHADOWS_SOFT
                #pragma multi_compile_fog

                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

                TEXTURE2D(_WaterTexture);
                SAMPLER(sampler_WaterTexture);

                TEXTURE2D(_NormalMap);
                SAMPLER(sampler_NormalMap);

                CBUFFER_START(UnityPerMaterial)
                    float4 _WaterColor;
                    float _Metallic;
                    float _Smoothness;
                    float4 _Tiling;
                    float _Strength;
                    float _Speed;
                CBUFFER_END

                struct Attributes
                {
                    float4 positionOS : POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                };

                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 positionWS : TEXCOORD1;
                    float3 normalWS : TEXCOORD2;
                    float4 tangentWS : TEXCOORD3;
                    float fogCoord : TEXCOORD4;
                };

                Varyings vert(Attributes input)
                {
                    Varyings output;

                    VertexPositionInputs pos = GetVertexPositionInputs(input.positionOS.xyz);
                    VertexNormalInputs norm = GetVertexNormalInputs(input.normalOS, input.tangentOS);

                    output.positionCS = pos.positionCS;
                    output.positionWS = pos.positionWS;
                    output.normalWS = norm.normalWS;
                    output.tangentWS = float4(norm.tangentWS, input.tangentOS.w);

                    output.uv = input.uv * _Tiling.xy;
                    output.fogCoord = ComputeFogFactor(output.positionCS.z);

                    return output;
                }

                float2 FlowUV(float2 uv, float2 direction, float offset)
                {
                    float t = frac(_Time.y * _Speed + offset);
                    return uv + direction * t * _Strength;
                }

                half4 frag(Varyings input) : SV_Target
                {
                    float2 uv = input.uv;

                    float2 flowDirA = float2(1.0, 0.35);
                    float2 flowDirB = float2(-0.45, 1.0);

                    float2 uvA = FlowUV(uv, flowDirA, 0.0);
                    float2 uvB = FlowUV(uv, flowDirB, 0.5);

                    float blend = abs(frac(_Time.y * _Speed) * 2.0 - 1.0);

                    float4 texA = SAMPLE_TEXTURE2D(_WaterTexture, sampler_WaterTexture, uvA);
                    float4 texB = SAMPLE_TEXTURE2D(_WaterTexture, sampler_WaterTexture, uvB);

                    float4 waterTex = lerp(texA, texB, blend);

                    float3 normalA = UnpackNormal(SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, uvA));
                    float3 normalB = UnpackNormal(SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, uvB));

                    float3 normalTS = normalize(lerp(normalA, normalB, blend));

                    float3 tangentWS = normalize(input.tangentWS.xyz);
                    float3 normalWSBase = normalize(input.normalWS);
                    float3 bitangentWS = normalize(cross(normalWSBase, tangentWS) * input.tangentWS.w);

                    float3 normalWS = TransformTangentToWorld(
                        normalTS,
                        half3x3(tangentWS, bitangentWS, normalWSBase)
                    );

                    normalWS = normalize(normalWS);

                    SurfaceData surfaceData;
                    surfaceData.albedo = waterTex.rgb * _WaterColor.rgb;
                    surfaceData.alpha = 1;
                    surfaceData.metallic = _Metallic;
                    surfaceData.specular = 0;
                    surfaceData.smoothness = _Smoothness;
                    surfaceData.normalTS = normalTS;
                    surfaceData.emission = 0;
                    surfaceData.occlusion = 1;
                    surfaceData.clearCoatMask = 0;
                    surfaceData.clearCoatSmoothness = 0;

                    InputData inputData;
                    inputData.positionWS = input.positionWS;
                    inputData.normalWS = normalWS;
                    inputData.viewDirectionWS = SafeNormalize(GetWorldSpaceViewDir(input.positionWS));
                    inputData.shadowCoord = TransformWorldToShadowCoord(input.positionWS);
                    inputData.fogCoord = input.fogCoord;
                    inputData.vertexLighting = half3(0, 0, 0);
                    inputData.bakedGI = SAMPLE_GI(0, 0, normalWS);
                    inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
                    inputData.shadowMask = half4(1, 1, 1, 1);

                    half4 color = UniversalFragmentPBR(inputData, surfaceData);
                    color.rgb = MixFog(color.rgb, input.fogCoord);

                    return color;
                }

                ENDHLSL
            }
        }

            FallBack "Hidden/Universal Render Pipeline/FallbackError"
}