precision mediump float;

uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUV;

void main() {
    vec4 textureColor = texture2D(uTexture, vUV);
    gl_FragColor = textureColor;
}