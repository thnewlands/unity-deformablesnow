Shader "Unlit/SnowAggregation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color", color) = (0.003, 0.003, 0.003,0) // 0.003 --> 1/256 rounded
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//take the snow camera's image
				fixed4 mtex = tex2D(_MainTex, i.uv);
				float col = mtex;
				//and subtract the height color from it (reducing the seen depth to 0 over time assuming the texture's colors are clamped)
				col -= _Color;
				return col;
			}
			ENDCG
		}
	}
}
