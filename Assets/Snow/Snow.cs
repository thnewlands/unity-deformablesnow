using UnityEngine;

public class Snow : MonoBehaviour {

    public GameObject snowPlane;
    public Material blitmat;
    public float updateDelay = .05f;

    private Camera cam;

	void Start () {
        cam = GetComponent<Camera>();
        cam.depthTextureMode = DepthTextureMode.Depth;

        //scale ortho camera with snow plane assuming it's 1:1
        cam.orthographicSize *= snowPlane.transform.localScale.x; 
    }

    //this function is for refreshing the snow levels over time
    float timer = 0;
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        timer += Time.deltaTime;
        if(timer >= updateDelay)
        {
            Graphics.Blit(source, destination, blitmat);
            timer = 0;
        } else
        {
            Graphics.Blit(source, destination);
        }
    }
}
