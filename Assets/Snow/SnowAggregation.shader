Shader "Custom/SnowAggregation" {
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", color) = (0.1, 0.1, 0.1,0)
		_Speed("Refresh Speed", float) = 50
	}
		SubShader{
			Tags{ "RenderType" = "Opaque" }

			Pass{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;

			sampler2D _CameraDepthTexture;

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 scrPos:TEXCOORD1;
				float4 pos : SV_POSITION;
			};

			//Vertex Shader
			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.scrPos = ComputeScreenPos(o.pos);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				//for some reason, the y position of the depth texture comes out inverted
				return o;
			}

			float _Speed;

			//Depth code via: http://williamchyr.com/2013/11/unity-shaders-depth-and-normal-textures/

			//Fragment Shader
			half4 frag(v2f i) : COLOR{
				fixed4 mtex = tex2D(_MainTex, i.uv);
				float depthValue = Linear01Depth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r);
				float4 d = float4(depthValue, depthValue, depthValue, depthValue);
				float4 c = d;
				if (d.a == 1) { //cut out background depth
					c = mtex;
				}
				//delayed fading
				if (frac(_Time.x * 50) >= .8) {
					c += _Color;
				}
				return c;
			}
			ENDCG
		}
	}
		FallBack "Diffuse"
}