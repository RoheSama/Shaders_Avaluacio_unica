using System.Collections;
using UnityEngine;

public class BarrierController : MonoBehaviour
{
    [Header("References")]
    public GameObject shieldObject;       // Arrastra aquí el GameObject Shield
    public Material shieldMaterial;       // Arrastra aquí el material Shield

    [Header("Barrier Settings")]
    public KeyCode activationKey = KeyCode.Q;
    public float barrierDuration = 10f;   // 10s como en el ejemplo

    [Header("Fade Settings")]
    public float fadeInDuration = 0.3f;
    public float fadeOutDuration = 0.5f;

    private bool _isActive = false;
    private Coroutine _barrierCoroutine;
    private static readonly int AlphaMultiplier = Shader.PropertyToID("_AlphaMultiplier");
    // Añade esta property al Shader Graph si quieres fade suave

    void Update()
    {
        if (Input.GetKeyDown(activationKey) && !_isActive)
        {
            ActivateBarrier();
        }
    }

    public void ActivateBarrier()
    {
        if (_barrierCoroutine != null)
            StopCoroutine(_barrierCoroutine);
        _barrierCoroutine = StartCoroutine(BarrierRoutine());
    }

    private IEnumerator BarrierRoutine()
    {
        _isActive = true;
        shieldObject.SetActive(true);

        // Mostrar UI "10s Barrier" — conecta aquí con tu UI si tienes
        Debug.Log("Barrier activated for " + barrierDuration + "s");

        yield return new WaitForSeconds(barrierDuration);

        shieldObject.SetActive(false);
        _isActive = false;
        Debug.Log("Barrier expired");
    }

    // Llamable desde otros scripts (por ejemplo al recibir daño)
    public void DeactivateBarrier()
    {
        if (_barrierCoroutine != null)
            StopCoroutine(_barrierCoroutine);
        shieldObject.SetActive(false);
        _isActive = false;
    }

    public bool IsActive() => _isActive;
}