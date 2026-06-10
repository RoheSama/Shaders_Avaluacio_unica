void HexGrid_float(float2 UV, float Scale, out float HexDist, out float2 HexID)
{
    float2 uv = UV * Scale;
    float2 s = float2(1.0, 1.7320508);

    float4 hexCenter = round(float4(uv, uv - float2(0.5, 1.0)) / s.xyxy);
    float4 offset = float4(uv - hexCenter.xy * s,
        uv - (hexCenter.zw + 0.5) * s);

    bool closer = dot(offset.xy, offset.xy) < dot(offset.zw, offset.zw);
    float2 hexOffset = closer ? offset.xy : offset.zw;
    float2 hexId = closer ? hexCenter.xy : hexCenter.zw;

    // SDF al borde del hexágono
    float2 p = abs(hexOffset);
    float dist = max(dot(p, s * 0.5), p.x) - 0.5;

    // Convertir distancia en LÍNEAS de borde
    // dist ~0 = justo en el borde del hex -> brillante
    // dist < 0 = interior -> oscuro
    HexDist = 1.0 - abs(dist) * Scale * 0.8;
    HexID = hexId;
}