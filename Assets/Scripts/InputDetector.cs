using UnityEngine;
using UnityEngine.UI;

public class InputDetector : MonoBehaviour
{
    [SerializeField]
    private Material mat;

    private bool isActive = false;

    [SerializeField]
    private float speed = 5f;
    private float intensity = 0f;

    private void Update()
    {
        if (isActive && intensity != 1)
        {
            intensity = Mathf.Lerp(intensity, 1, Time.deltaTime * speed);

            if (intensity >= 0.9f)
                intensity = 1f;

            mat.SetFloat("_Intensity", intensity);
        }
        else if (!isActive && intensity != 0)
        {
            intensity = Mathf.Lerp(intensity, 0, Time.deltaTime * speed);

            if (intensity <= 0.1f)
                intensity = 0f;

            mat.SetFloat("_Intensity", intensity);
        }

        if (Input.GetMouseButtonDown(0))
        {
            Vector3 viewport = Camera.main.ScreenToViewportPoint(Input.mousePosition);
            mat.SetVector("_Viewport", viewport);

            isActive = true;
        }

        if (Input.GetMouseButton(0))
        {
            Vector3 viewport = Camera.main.ScreenToViewportPoint(Input.mousePosition);
            mat.SetVector("_Viewport", viewport);
        }

        if (Input.GetMouseButtonUp(0))
        {
            Vector3 viewport = Camera.main.ScreenToViewportPoint(Input.mousePosition);
            mat.SetVector("_Viewport", viewport);
            isActive = false;
        }
    }
}