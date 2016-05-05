#version 120

// input
attribute vec3 vertexPosition_modelspace;
attribute vec2 vertexUV;
attribute vec3 vertexNormal_modelspace;

// output
varying vec2 UV;
varying vec3 Position_worldspace;
varying vec3 Normal_cameraspace;
varying vec3 EyeDirection_cameraspace;
varying vec3 LightDirection_cameraspace;

// const
uniform mat4 MVP;
uniform mat4 V;
uniform mat4 M;
uniform vec3 LightPosition_worldspace;
uniform mat3 normalMatrix;

void main() {
  gl_Position =  MVP * vec4(vertexPosition_modelspace, 1);

  Position_worldspace = (M * vec4(vertexPosition_modelspace,1)).xyz;

  vec3 vertexPosition_cameraspace = (V * M * vec4(vertexPosition_modelspace,1)).xyz;
  EyeDirection_cameraspace = vec3(0,0,0) - vertexPosition_cameraspace;

  vec3 LightPosition_cameraspace = ( vec4(LightPosition_worldspace,1)).xyz;
  LightDirection_cameraspace = LightPosition_cameraspace + EyeDirection_cameraspace;
  Normal_cameraspace = ( normalMatrix * vertexNormal_modelspace);

  UV = vertexUV;
}
