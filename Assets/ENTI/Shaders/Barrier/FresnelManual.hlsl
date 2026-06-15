void FresnelCustom_float(float3 Normal, float3 ViewDir, float Power, out float Fresnel)
{
    // Dot entre normal y dirección de vista (0 = borde, 1 = centro)
    float NdotV = saturate(dot(normalize(Normal), normalize(ViewDir)));
    // Invertir para que los bordes sean brillantes
    Fresnel = pow(1.0 - NdotV, Power);
}