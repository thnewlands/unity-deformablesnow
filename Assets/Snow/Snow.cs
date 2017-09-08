using UnityEngine;

public class Snow : MonoBehaviour {

    public GameObject snowPlane;
    public Material blitmat;
    public Material white;
    public float updateSpeed = 100f;

    private Camera cam;

	void Start () {
        cam = GetComponent<Camera>();
        cam.depthTextureMode = DepthTextureMode.Depth;

        //scale ortho camera with snow plane assuming it's 1:1
        cam.orthographicSize *= snowPlane.transform.localScale.x; 
    }

    bool backgroundset = false;

    //this function is for refreshing the snow levels over time
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        blitmat.SetFloat("_Speed", updateSpeed);

        if(!backgroundset)
        {
            Graphics.Blit(source, destination, white);
            backgroundset = true;
            return;
        }

        Graphics.Blit(source, destination, blitmat);
    }
}
