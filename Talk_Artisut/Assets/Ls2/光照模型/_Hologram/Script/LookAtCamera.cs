using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class LookAtCamera : MonoBehaviour
{
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    private Camera cam;

    Camera Cam
    {
        get
        {
            cam = FindObjectOfType<Camera>();
            return cam;
        }
    }
    
    // Update is called once per frame
    void Update()
    {
        transform.localPosition = Vector3.zero;
        transform.LookAt(Camera.main.transform);
    }
}
