varying vec2 vUV;

void main()
{
    gl_FragColor = vec4(vUV.x, vUV.x, vUV.x, 1.0);
}