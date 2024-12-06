uniform sampler2D uTexture;

void main() {
    float textureAlpha = texture(uTexture, gl_PointCoord).x;
    
    // Final color
    gl_FragColor = vec4(1.0, 1.0, 1.0, textureAlpha);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}