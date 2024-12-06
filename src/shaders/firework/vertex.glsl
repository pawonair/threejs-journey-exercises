uniform float uSize;
uniform vec2 uResolution;
uniform float uProgress;

attribute float aSize;
attribute float aTimeMultiplier;

/*
* value: the value you want to remap
* originMin and originMax: the start and end of the original range
* (the part that you want to transform into another range)
* destinationMin and destinationMax: the start and end of the destination range
* (in our case it’s just 0 and 1, but we could have had a different destination range)
*/
float remap(float value, float originMin, float originMax, float destinationMin, float destinationMax) {
    return destinationMin + (value - originMin) * (destinationMax - destinationMin) / (originMax - originMin);
}

void main() {
    float progress = uProgress * aTimeMultiplier;
    vec3 newPosition = position;

    // Explode
    float explodingProgress = remap(progress, 0.0, 0.1, 0.0, 1.0);
    explodingProgress = clamp(explodingProgress, 0.0, 1.0);
    explodingProgress = 1.0 - pow(1.0 - explodingProgress, 3.0);
    newPosition *= explodingProgress;

    // Fall
    float fallingProgress = remap(progress, 0.1, 1.0, 0.0, 1.0);
    fallingProgress = clamp(fallingProgress, 0.0, 1.0);
    fallingProgress = 1.0 - pow(1.0 - fallingProgress, 3.0);
    newPosition.y -= fallingProgress * 0.2;

    // Scale
    float sizeOpeningProgress = remap(progress, 0.0, 0.125, 0.0, 1.0);
    float sizeClosingProgress = remap(progress, 0.125, 1.0, 1.0, 0.0);
    float sizeProgress = min(sizeOpeningProgress, sizeClosingProgress);
    sizeProgress = clamp(sizeProgress, 0.0, 1.0);

    // Twinkle
    float twinklingProgress = remap(progress, 0.2, 0.8, 0.0, 1.0);
    float sizeTwinkling = sin(progress * 30.0) * 0.5 + 0.5;
    twinklingProgress = clamp(twinklingProgress, 0.0, 1.0);
    sizeTwinkling = 1.0 - sizeTwinkling * twinklingProgress;

    // Final position
    vec4 modelPosition = modelMatrix * vec4(newPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    gl_Position = projectionMatrix * viewPosition;

    // Final size
    gl_PointSize = uSize * uResolution.y * aSize * sizeProgress * sizeTwinkling;
    gl_PointSize *= 1.0 / -viewPosition.z;
}