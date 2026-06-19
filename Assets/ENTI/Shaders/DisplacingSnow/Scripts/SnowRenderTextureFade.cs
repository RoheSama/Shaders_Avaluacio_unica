using UnityEngine;

public class SnowRenderTextureFade : MonoBehaviour
{
    [Header("Render Textures")]
    public RenderTexture snowTexture;
    public RenderTexture tempTexture;

    [Header("Fade")]
    public Material fadeMaterial;

    [Range(0.90f, 1f)]
    public float fadeAmount = 0.985f;

    private void Start()
    {
        ClearSnowTexture();
    }

    private void Update()
    {
        if (snowTexture == null || tempTexture == null || fadeMaterial == null)
            return;

        fadeMaterial.SetFloat("_FadeAmount", fadeAmount);

        Graphics.Blit(snowTexture, tempTexture, fadeMaterial);
        Graphics.Blit(tempTexture, snowTexture);
    }

    private void ClearSnowTexture()
    {
        RenderTexture activeRT = RenderTexture.active;
        RenderTexture.active = snowTexture;
        GL.Clear(true, true, Color.black);
        RenderTexture.active = activeRT;
    }
}