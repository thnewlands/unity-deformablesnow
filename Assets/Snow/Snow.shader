Shader "Custom/SnowExample" {
	Properties{
		_Tess("Tessellation", Range(1,64)) = 4

		_MainTex("Top Tex (RGB)", 2D) = "white" {}
		_MainTex2("Bottom Tex (RGB)", 2D) = "white" {}

		_DispTex("Displacement Texture", 2D) = "white" {}
		_ImprintTex("Imprint Texture", 2D) = "white" {}

		_Displacement("Displacement", Range(0, 1.0)) = 0.3

		_TopColor("Top Color", color) = (1,1,1,0)
		_BotColor("Bottom Color", color) = (1,1,1,0)
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 300

		CGPROGRAM
		#pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessDistance nolightmap
		#pragma target 4.6
		#include "Tessellation.cginc"

		struct appdata {
		float4 vertex : POSITION;
		float4 tangent : TANGENT;
		float3 normal : NORMAL;
		float2 texcoord : TEXCOORD0;
	};

	float _Tess;

	//this shader is based off of https://docs.unity3d.com/Manual/SL-SurfaceShaderTessellation.html
	float4 tessDistance(appdata v0, appdata v1, appdata v2) {
		float minDist = 10.0;
		float maxDist = 25.0;
		return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
	}

	sampler2D _ImprintTex;
	sampler2D _DispTex;
	float _Displacement;

	//copied from https://forum.unity3d.com/threads/calculate-vertex-normals-in-shader-from-heightmap.169871/
	//....
	float3 FindNormal(sampler2D tex, float2 uv, float u)
	{
		//u is one uint size, ie 1.0/texture size
		float2 offsets[4];
		offsets[0] = uv + float2(u, 0);
		offsets[1] = uv + float2(-u, 0);
		offsets[2] = uv + float2(0, -u);
		offsets[3] = uv + float2(0, u);

		float hts[4];
		for (int i = 0; i < 4; i++)
		{
			hts[i] = tex2D(tex, float2(1 - offsets[i].x, offsets[i].y)).x;
		}

		float2 _step = float2(1.0, 0.0);

		float3 va = normalize(float3(_step.xy, hts[1] - hts[0]));
		float3 vb = normalize(float3(_step.yx, hts[3] - hts[2]));

		return cross(va, vb).rbg; //you may not need to swizzle the normal
	}
	//....

	void disp(inout appdata v)
	{
		//depth texture transformed to fit camera and 
		float d = tex2Dlod(_ImprintTex, float4(1 - v.texcoord.x, v.texcoord.y, 0,0)).r * _Displacement;
		//displace it all for a more interesting overall surface, inverted so it indents from the top and toned down by half
		d *= 1 - tex2Dlod(_DispTex, float4(v.texcoord,0,0)) * .5f;
		//put it all together
		v.vertex.xyz += v.normal * d;
	}

	struct Input {
		float2 uv_MainTex;
	};

	sampler2D _MainTex;
	sampler2D _MainTex2;

	sampler2D _NormalMap;
	fixed4 _TopColor;
	fixed4 _BotColor;

	void surf(Input IN, inout SurfaceOutput o) {
		//lerp between the surface of the snow and what's beneath based on the imprint
		half4 c = lerp(
			tex2D(_MainTex, IN.uv_MainTex) * _TopColor,
			tex2D(_MainTex2, IN.uv_MainTex) * _BotColor,
			1 - tex2D(_ImprintTex, float2(1 - IN.uv_MainTex.x, IN.uv_MainTex.y)).r);
		o.Albedo = c.rgb;
		o.Specular = .2;
		o.Gloss = 1.0;
		//calculate normal based on earlier function
		o.Normal = FindNormal(_DispTex, IN.uv_MainTex, .00025f);
	}
	ENDCG
	}
		FallBack "Diffuse"
}