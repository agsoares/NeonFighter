uniform sampler2D sampler;
varying vec2 uvVarying;

void main() {
    vec4 tex = texture2D ( sampler, uvVarying );
    gl_FragColor = vec4(tex.r, tex.b, tex.g, tex.a);
}
