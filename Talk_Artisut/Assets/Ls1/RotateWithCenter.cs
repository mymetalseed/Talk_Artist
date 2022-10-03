using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateWithCenter : MonoBehaviour
{
    float start=0.0f, end=360f;
    public static float selfSpeed = 5;
    float distance;
    public Transform center;
    public float originTheta;
    public float publicSpeed;
    void Start()
    {
        distance = Vector3.Distance(transform.position, center.position);
    }

    // Update is called once per frame
    void Update()
    {
        //transform.rotation = Quaternion.Euler(-90,0,Mathf.Sin(Time.time / selfSpeed) * 360f);
        originTheta = (originTheta + (publicSpeed * Time.deltaTime)) % 360.0f;

        transform.RotateAround(center.position, transform.up, selfSpeed / publicSpeed );
    }

    /// <summary>
    /// 获取某向量的垂直向量
    /// </summary>
    public static Vector3 GetVerticalDir(Vector3 _dir)
    {
        //（_dir.x,_dir.z）与（？，1）垂直，则_dir.x * ？ + _dir.z * 1 = 0
        if (_dir.x == 0)
        {
            return new Vector3(1, 0, 0);
        }
        else
        {
            return new Vector3(-_dir.z / _dir.x, 0, 1).normalized;
        }
    }

}
