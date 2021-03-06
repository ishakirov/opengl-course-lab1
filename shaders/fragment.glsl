#version 120

// from vertex shader
varying vec2 UV;
varying vec3 Position_worldspace;
varying vec3 Normal_cameraspace;
varying vec3 EyeDirection_cameraspace;
varying vec3 LightDirection_cameraspace;

// const
uniform sampler2D myTextureSampler;
uniform mat4 MV;
uniform vec3 LightPosition_worldspace;

void main() {
  vec3 LightColor = vec3(1, 1, 1);
	float LightPower = 50.0f;

  vec3 MaterialDiffuseColor = texture2D( myTextureSampler, UV ).rgb;
	vec3 MaterialAmbientColor = vec3(0.1,0.1,0.1) * MaterialDiffuseColor;
	vec3 MaterialSpecularColor = vec3(0.3,0.3,0.3);

  float distance = length( LightPosition_worldspace - Position_worldspace );

  vec3 n = normalize(Normal_cameraspace);
  vec3 l = normalize(LightDirection_cameraspace);

  float cosTheta = clamp(dot(n, l), 0, 1);

  vec3 E = normalize(EyeDirection_cameraspace);
  vec3 R = reflect(-l,n);

  float cosAlpha = clamp(dot(E, R), 0, 1);

  gl_FragColor.rgb =
		// Ambient : simulates indirect lighting
		MaterialAmbientColor +
		// Diffuse : "color" of the object
		MaterialDiffuseColor * LightColor * LightPower * cosTheta / (distance*distance) +
		// Specular : reflective highlight, like a mirror
		MaterialSpecularColor * LightColor * LightPower * pow(cosAlpha,5) / (distance*distance);

  // luminosity
  float bw = 0.21 * gl_FragColor.x + 0.72 * gl_FragColor.y + 0.07 * gl_FragColor.z;
  gl_FragColor = vec4(bw, bw, bw, 1);
}
