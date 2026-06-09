void HexGrid_float(float2 UV, float Scale, out float HexDist, out float2 HexID)
{
    float2 uv = UV * Scale;

    // s = (1, sqrt(3)) — base del algoritmo del blog
    float2 s = float2(1.0, 1.7320508);

    // Dos grids entrelazados (staggered) para formar la cuadrícula hex
    float4 hexCenter = round(float4(uv, uv - float2(0.5, 1.0)) / s.xyxy);
    float4 offset = float4(uv - hexCenter.xy * s,
        uv - (hexCenter.zw + 0.5) * s);

    // Elegir el centro hex más cercano
    bool closer = dot(offset.xy, offset.xy) < dot(offset.zw, offset.zw);
    float2 hexOffset = closer ? offset.xy : offset.zw;
    float2 hexId = closer ? hexCenter.xy : hexCenter.zw;

    // Distancia SDF al borde del hexágono (Method 1 del blog)
    float2 p = abs(hexOffset);
    HexDist = max(dot(p, s * 0.5), p.x) - 0.5;
    HexID = hexId;
}