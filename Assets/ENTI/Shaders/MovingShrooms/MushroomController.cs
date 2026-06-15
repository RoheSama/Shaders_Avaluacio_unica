using UnityEngine;

public class MushroomController : MonoBehaviour
{
    public Transform player;
    public Renderer[] mushroomRenderers;

    private static readonly int PlayerPositionID =
        Shader.PropertyToID("_PlayerPosition");

    // Cache del PropertyBlock para evitar GC alloc cada frame
    private MaterialPropertyBlock _mpb;

    private void Awake()
    {
        _mpb = new MaterialPropertyBlock();
    }

    private void Update()
    {
        if (player == null) return;

        Vector3 playerPos = player.position;

        foreach (Renderer rend in mushroomRenderers)
        {
            rend.GetPropertyBlock(_mpb);
            _mpb.SetVector(PlayerPositionID, playerPos);
            rend.SetPropertyBlock(_mpb);
        }
    }
}