using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

[ExecuteInEditMode]
[RequireComponent(typeof(LineRenderer))]
public class LineRenderController : MonoBehaviour
{
    public List<Transform> Points;

    private LineRenderer lineRenderer;
    
    // Start is called before the first frame update
    void Start()
    {
        lineRenderer = GetComponent<LineRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        Points = GetComponentsInChildren<Transform>().ToList();
        Points.Remove(transform);
        
        List<Vector3> positions = new List<Vector3>();

        foreach (Transform point in Points)
        {
            positions.Add(point.position);
        }

        lineRenderer.positionCount = positions.Count;
        lineRenderer.SetPositions(positions.ToArray());        
    }
}
