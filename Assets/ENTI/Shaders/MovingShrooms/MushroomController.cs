using UnityEngine;

public class MushroomController : MonoBehaviour
{
    public Transform player;
    public MeshRenderer[] mushroomRenderers;

    private static readonly int PlayerPositionID = Shader.PropertyToID("_PlayerPosition");

    void Update()
    {
        if (player == null) return;

        Vector3 playerPos = player.position;

        foreach (MeshRenderer rend in mushroomRenderers)
        {
            if (rend == null) continue;

            foreach (Material mat in rend.materials)
            {
                mat.SetVector(PlayerPositionID, playerPos);
            }
        }
    }
}