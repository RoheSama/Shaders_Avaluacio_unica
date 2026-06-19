using UnityEngine;

public class SnowPainterFollowPlayer : MonoBehaviour
{
    public Transform player;
    public float painterHeight = 0.05f;
    public Renderer painterRenderer;
    public float minSpeedToPaint = 0.05f;

    private Vector3 lastPlayerPosition;

    private void Start()
    {
        if (player != null)
            lastPlayerPosition = player.position;
    }

    private void LateUpdate()
    {
        if (player == null) return;

        transform.position = new Vector3(
            player.position.x,
            painterHeight,
            player.position.z
        );

        float speed = (player.position - lastPlayerPosition).magnitude / Time.deltaTime;

        if (painterRenderer != null)
            painterRenderer.enabled = speed > minSpeedToPaint;

        lastPlayerPosition = player.position;
    }
}