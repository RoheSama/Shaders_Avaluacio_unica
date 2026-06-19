using UnityEngine;

public class SnowPostProcessZone : MonoBehaviour
{
    [SerializeField] private SnowPostProcessController snowController;
    [SerializeField] private string playerTag = "Player";

    private void OnTriggerEnter(Collider other)
    {
        Transform root = other.transform.root;

        Debug.Log("entra algo en snow zone: " + other.name + " / root: " + root.name);

        if (!root.CompareTag(playerTag)) return;

        if (snowController != null)
        {
            snowController.EnableSnow();
            Debug.Log("nievecita start");
        }
    }

    private void OnTriggerExit(Collider other)
    {
        Transform root = other.transform.root;

        Debug.Log("sale algo de snow zone: " + other.name + " / root: " + root.name);

        if (!root.CompareTag(playerTag)) return;

        if (snowController != null)
        {
            snowController.DisableSnow();
            Debug.Log("nievecita end");
        }
    }
}