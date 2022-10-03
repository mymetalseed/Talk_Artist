using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class Rotate : MonoBehaviour
{
    float start=0.0f, end=360f;
    public float speed;
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        transform.rotation = Quaternion.Euler(-90,0,Mathf.Sin(Time.time / speed) * 360f);
    }
}
