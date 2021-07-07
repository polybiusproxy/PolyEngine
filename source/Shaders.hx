package;

// TODO: add overlay shader for week 4
import flixel.system.FlxAssets.FlxShader;

typedef ShaderEffect =
{
	var shader:Dynamic;
}

class PyramidShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
        
        uniform vec2 u_resolution;
        uniform float u_time;

        vec3 palette(float d){
            return mix(vec3(0.2,0.7,0.9),vec3(1.,0.,1.),d);
        }

        vec2 rotate(vec2 p,float a){
            float c = cos(a);
            float s = sin(a);
            return p*mat2(c,s,-s,c);
        }

        float map(vec3 p){
            for( int i = 0; i<8; ++i){
                float t = u_time*0.2;
                p.xz =rotate(p.xz,t);
                p.xy =rotate(p.xy,t*1.89);
                p.xz = abs(p.xz);
                p.xz-=.5;
            }
            return dot(sign(p),p)/5.;
        }

        vec4 rm (vec3 ro, vec3 rd){
            float t = 0.;
            vec3 col = vec3(0.);
            float d;
            for(float i =0.; i<64.; i++){
                vec3 p = ro + rd*t;
                d = map(p)*.5;
                if(d<0.02){
                    break;
                }
                if(d>100.){
                    break;
                }
                //col+=vec3(0.6,0.8,0.8)/(400.*(d));
                col+=palette(length(p)*.1)/(400.*(d));
                t+=d;
            }
            return vec4(col,1./(d*100.));
        }

        void main()
        {
            vec2 uv = (gl_FragCoord.xy - (u_resolution.xy / 2.)) / u_resolution.x;
            vec3 ro = vec3(0., 0., -50.);
            vec4 color = texture2D(bitmap, openfl_TextureCoordv);

            ro.xz = rotate(ro.xz, u_time);

            vec3 cf = normalize(-ro);
            vec3 cs = normalize(cross(cf, vec3(0., 1., 0.)));
            vec3 cu = normalize(cross(cf, cs));
            
            vec3 uuv = ro + cf * 3. + uv.x * cs + uv.y * cu; 
            vec3 rd = normalize(uuv - ro);

            vec4 col = rm(ro, rd);
            
            gl_FragColor = col;
        }
    ')
	public function new()
	{
		super();
	}
}

class CreationShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
        
        uniform vec2 u_resolution;
        uniform float u_time;
        
        void main() {
            vec3 c;
            float l, z = u_time;

            for (int i = 0; i < 3; i++) {
                vec2 uv, p = gl_FragCoord.xy / u_resolution;

                uv = p;

                p -= .5;
                p.x *= u_resolution.x / u_resolution.y;

                z += .07;

                l = length(p);
                uv += p / l * (sin(z) + 1.) * abs(sin(l * 9. - z * 2.));

                c[i] = .01 / length(abs(mod(uv, 1.) - .5));
            }

            gl_FragColor = vec4(c / l, u_resolution);
        }
    ')
	public function new()
	{
		super();
	}
}

class VCRShader extends FlxShader
{
	public function new()
	{
		super();
	}
}
