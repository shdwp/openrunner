#include definitions.glsl

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoord;
layout (location = 2) in vec3 aNorm;

out vec2 TextureCoord;
out vec3 Normal;
out vec3 FragPos;

uniform mat4 local;

vec4 calculateFragPosition() {
    return local * vec4(aPos, 1);
}

vec4 calculatePosition() {
    return projection * world * calculateFragPosition();
}

vec3 calculateNormal() {
    return mat3(transpose(inverse(local))) * aNorm;
}
