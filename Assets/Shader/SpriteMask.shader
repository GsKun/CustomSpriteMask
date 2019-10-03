Shader "Custom/SpriteMask" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Viewport ("Viewport", Vector) = (0,0,0,0)
        _Width ("Width", Range(0, 1)) = 0.5
        _Height ("Height", Range(0, 1)) = 0.85
        _Scale ("Scale", Range(0, 1)) = 1
        _Intensity ("Intensity", Range(0, 1)) = 1
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal
            #pragma target 3.0
            uniform float _Scale;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _Viewport;
            uniform float _Width;
            uniform float _Height;
            uniform float _Intensity;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };


            void Ellipse_float(float2 UV, float Width, float Height, out float Out)
            {
                float d = length((UV * 2 - 1) / float2(Width, Height));
                Out = saturate((1 - d) / fwidth(d));
            }

            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {

                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));


                float2 uv = float2(i.uv0.r + (_Viewport.r - 0.5) * -1.0 , i.uv0.g - 1.0 *(_Viewport.g - 0.5));

                float remapValue = 5.0;

                _Width = _Width * (_Scale * remapValue);
                _Height = _Height * (_Scale * remapValue);

                float ellipse;
                Ellipse_float(uv, _Width, _Height, ellipse);

                float3 emissive = (_MainTex_var.rgb * ellipse);

                float3 finalColor = emissive;

                float alpha = _MainTex_var.a * ellipse * _Intensity;
                return fixed4(finalColor, alpha);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
