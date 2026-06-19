using UnityEngine;

public class SnowPostProcessController : MonoBehaviour
{
    [Header("Material")]
    [SerializeField] private Material snowPostProcessMaterial;

    [Header("Transition")]
    [SerializeField] private float transitionDuration = 2f;
    [SerializeField, Range(0f, 1f)] private float targetSnowAmount = 1f;

    [Header("Shader Property")]
    [SerializeField] private string snowAmountProperty = "SnowAmount";

    private float currentAmount = 0f;
    private float desiredAmount = 0f;

    private void Awake()
    {
        if (snowPostProcessMaterial != null)
        {
            snowPostProcessMaterial.SetFloat(snowAmountProperty, 0f);
        }
    }

    private void Update()
    {
        if (snowPostProcessMaterial == null) return;

        float speed = transitionDuration <= 0f ? 999f : 1f / transitionDuration;

        currentAmount = Mathf.MoveTowards(
            currentAmount,
            desiredAmount,
            speed * Time.deltaTime
        );

        snowPostProcessMaterial.SetFloat(snowAmountProperty, currentAmount);
    }

    public void EnableSnow()
    {
        desiredAmount = targetSnowAmount;
    }

    public void DisableSnow()
    {
        desiredAmount = 0f;
    }

    public void SetSnowActive(bool active)
    {
        desiredAmount = active ? targetSnowAmount : 0f;
    }
}