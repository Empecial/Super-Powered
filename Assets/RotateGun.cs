using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateGun : MonoBehaviour
{

    public GrapplingGun grappling;

    private Quaternion desiredRotation;
    private float rotationSpeed=5f;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (!grappling.IsGrappling())
        {
            desiredRotation = transform.parent.rotation;
        }
        else
        {
            desiredRotation = Quaternion.LookRotation(grappling.GetGrapplePoint() - transform.position);
        }

        transform.rotation = Quaternion.Lerp(a: transform.rotation, b: desiredRotation, t: Time.deltaTime * rotationSpeed);
    }




}
