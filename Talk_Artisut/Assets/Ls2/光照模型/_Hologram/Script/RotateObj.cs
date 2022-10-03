using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateObj : MonoBehaviour
{
    public float RoateSpeed = 1f;


    private Vector3 RotateAxia = Vector3.up;

    public bool reverse = false;
    
    // Start is called before the first frame update
    void Start()
    {
        RotateAxia = transform.InverseTransformDirection(Vector3.up).normalized;
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate( reverse? RotateAxia : -RotateAxia,RoateSpeed*Time.deltaTime);
    }   
}
