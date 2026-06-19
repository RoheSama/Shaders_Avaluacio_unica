using UnityEngine;

public class SnowFootprintPainter : MonoBehaviour
{
    public CharacterController controller;
    public Renderer painterRenderer;

    public float minSpeedToPaint = 0.1f;

    private Vector3 lastPosition;

    private void Start()
    {
        lastPosition = transform.position;
    }

    private void Update()
    {
        float speed = (transform.position - lastPosition).magnitude / Time.deltaTime;

        if (painterRenderer != null)
            painterRenderer.enabled = speed > minSpeedToPaint;

        lastPosition = transform.position;
    }
}