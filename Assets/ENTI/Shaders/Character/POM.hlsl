void POM_float(
    float2 UV,
    UnityTexture2D HeightTex,
    UnitySamplerState HeightSampler,
    float3 ViewDirTS,
    float Steps,
    float Amplitude,
    out float2 OffsetUV)
{
    // Normalizar y escalar el vector de desplazamiento
    float2 uvDelta = (ViewDirTS.xy / max(ViewDirTS.z, 0.0001))
        * (Amplitude * 0.001);
    float stepSize = 1.0 / Steps;
    float2 currentUV = UV;
    float  layerDepth = 0.0;

    // Sample inicial
    float heightSample = 1.0 - SAMPLE_TEXTURE2D(
        HeightTex.tex, HeightSampler.samplerstate, currentUV).r;

    // Loop de raymarching
    UNITY_LOOP
        for (int i = 0; i < 32; i++)
        {
            if (i >= (int)Steps)    break;
            if (heightSample <= layerDepth) break;

            layerDepth += stepSize;
            currentUV -= uvDelta * stepSize;
            heightSample = 1.0 - SAMPLE_TEXTURE2D(
                HeightTex.tex, HeightSampler.samplerstate, currentUV).r;
        }

    // Interpolación entre el paso actual y anterior (suaviza artefactos)
    float2 prevUV = currentUV + uvDelta * stepSize;
    float  afterH = heightSample - layerDepth;
    float  beforeH = (1.0 - SAMPLE_TEXTURE2D(
        HeightTex.tex, HeightSampler.samplerstate, prevUV).r)
        - (layerDepth - stepSize);
    float  t = afterH / (afterH - beforeH);
    OffsetUV = lerp(currentUV, prevUV, t);
}