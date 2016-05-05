#include <vector>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <sstream>

#include <glm/glm.hpp>

#include "object.hpp"

using namespace std;

bool parseObj(
  const string filePath,
  vector<glm::vec3> & out_vertices,
  vector<glm::vec2> & out_uvs,
  vector<glm::vec3> & out_normals
) {
  printf("Loading OBJ file %s...\n", filePath.c_str());

  vector<unsigned int> vertexIndices, uvIndices, normalIndices;
  vector<glm::vec3> temp_vertices;
  vector<glm::vec2> temp_uvs;
  vector<glm::vec3> temp_normals;

  ifstream input(filePath);

  for (string line; getline(input, line); ) {
    istringstream in(line);
    string type;
    in >> type;

    if (type == "v") {
      glm::vec3 vertex;
      in >> vertex.x >> vertex.y >> vertex.z;
      temp_vertices.push_back(vertex);
    }
    if (type == "vt") {
      glm::vec2 uv;
      in >> uv.x >> uv.y;
      temp_uvs.push_back(uv);
    }
    if (type == "vn") {
      glm::vec3 normal;
      in >> normal.x >> normal.y >> normal.z;
      temp_normals.push_back(normal);
    }
    if (type == "f") {
      unsigned int vertexIndex[3], uvIndex[3], normalIndex[3];
      char ch;
      in >> vertexIndex[0] >> ch >> uvIndex[0] >> ch >> normalIndex[0];
      in >> vertexIndex[1] >> ch >> uvIndex[1] >> ch >> normalIndex[1];
      in >> vertexIndex[2] >> ch >> uvIndex[2] >> ch >> normalIndex[2];

      vertexIndices.push_back(vertexIndex[0]);
			vertexIndices.push_back(vertexIndex[1]);
			vertexIndices.push_back(vertexIndex[2]);
			uvIndices    .push_back(uvIndex[0]);
			uvIndices    .push_back(uvIndex[1]);
			uvIndices    .push_back(uvIndex[2]);
			normalIndices.push_back(normalIndex[0]);
			normalIndices.push_back(normalIndex[1]);
			normalIndices.push_back(normalIndex[2]);
    }
  }

  // workaround (since we withoutn texture coords)
  // temp_uvs.push_back(glm::vec2(0.0, 0.0));

  for(int i = 0; i < vertexIndices.size(); i++) {
		unsigned int vertexIndex = vertexIndices[i];
		unsigned int uvIndex = uvIndices[i];
		unsigned int normalIndex = normalIndices[i];

		glm::vec3 vertex = temp_vertices[ vertexIndex-1 ];
		glm::vec2 uv = temp_uvs[ uvIndex-1 ];
		glm::vec3 normal = temp_normals[ normalIndex-1 ];

		out_vertices.push_back(vertex);
		out_uvs     .push_back(uv);
		out_normals .push_back(normal);
	}

	return true;
}
