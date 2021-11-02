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

class RayShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
        
        uniform vec2 u_resolution;
        uniform float u_time;

        vec4 lookup(sampler2D src, float x, float y)
        {
            return texture2D(src, vec2(x / u_resolution.x, y / u_resolution.y));
        }

        float rayStrength(vec2 raySource, vec2 rayRefDirection, vec2 coord, float seedA, float seedB, float speed)
        {
            vec2 sourceToCoord = coord - raySource;
            float cosAngle = dot(normalize(sourceToCoord), rayRefDirection);
            
            return clamp(
                (0.45 + 0.15 * sin(cosAngle * seedA + u_time * speed)) +
                (0.3 + 0.2 * cos(-cosAngle * seedB + u_time * speed)),
                0.0, 1.0) *
                clamp((u_resolution.x - length(sourceToCoord)) / u_resolution.x, 0.5, 1.0);
        }

        float bubbleStrength(vec2 startPos, vec2 waveOffset, float radius, float speed, vec2 coord)
        {
            vec2 curPos = vec2(
                mod(startPos.x + waveOffset.x * 0.5, u_resolution.x + radius * 2.0) - radius,
                mod(waveOffset.y - u_time * speed, u_resolution.y + radius * 2.0) - radius);
            return 1.0 - smoothstep(0.0, radius, length(coord - curPos));
        }

        void main()
        {
            vec2 uv = gl_FragCoord.xy / u_resolution.xy;
            uv.y = 1.0 - uv.y;
            vec2 coord = vec2(gl_FragCoord.x, u_resolution.y - gl_FragCoord.y);
            
            float offsetX = (0.1112 * u_resolution.x * cos(1.44125 * (u_time + uv.y))) + (26.77311 * u_time);
            float offsetY = (0.08447 * u_resolution.y * sin(2.14331 * (u_time + uv.x)));
            
            vec2 rayPos1 = vec2(u_resolution.x * 0.7, u_resolution.y * -0.4);
            vec2 rayRefDir1 = normalize(vec2(1.0, -0.116));
            float raySeedA1 = 36.2214;
            float raySeedB1 = 21.11349;
            float raySpeed1 = 1.5;
            
            vec2 rayPos2 = vec2(u_resolution.x * 0.8, u_resolution.y * -0.6);
            vec2 rayRefDir2 = normalize(vec2(1.0, 0.241));
            float raySeedA2 = 22.39910;
            float raySeedB2 = 18.0234;
            float raySpeed2 = 1.1;
            
            vec4 rays1 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                rayStrength(rayPos1, rayRefDir1, coord, raySeedA1, raySeedB1, raySpeed1);
            
            vec4 rays2 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                rayStrength(rayPos2, rayRefDir2, coord, raySeedA2, raySeedB2, raySpeed2);
            
            float bubbleScale = u_resolution.x / 600.0;
            
            vec4 bubble1 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                bubbleStrength(vec2(0.0, 0.0), vec2(offsetX * 0.2312, 0.0), 20.0 * bubbleScale, 60.0, coord);
            
            vec4 bubble2 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                bubbleStrength(vec2(40.0, 400.0), vec2(offsetX * -0.06871, offsetY * 0.301), 7.0 * bubbleScale, 25.0, coord);
            
            vec4 bubble3 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                bubbleStrength(vec2(300.0, 70.0), vec2(offsetX * 0.19832, offsetY * 0.1351), 14.0 * bubbleScale, 45.0, coord);
            
            vec4 bubble4 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                bubbleStrength(vec2(500.0, 280.0), vec2(offsetX * -0.0993, offsetY * -0.2654), 12.0 * bubbleScale, 32.0, coord);
            
            vec4 bubble5 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                bubbleStrength(vec2(400.0, 140.0), vec2(offsetX * 0.2231, offsetY * 0.0111), 10.0 * bubbleScale, 28.0, coord);
            
            vec4 bubble6 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                bubbleStrength(vec2(200.0, 360.0), vec2(offsetX * 0.0693, offsetY * -0.3567), 5.0 * bubbleScale, 12.0, coord);
            
            vec4 bubble7 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                bubbleStrength(vec2(0.0, 0.0), vec2(offsetX * -0.32301, offsetY * 0.2349), 16.0 * bubbleScale, 51.0, coord);
            
            vec4 bubble8 =
                vec4(1.0, 1.0, 1.0, 1.0) *
                bubbleStrength(vec2(130.0, 23.0), vec2(offsetX * 0.1393, offsetY * -0.4013), 8.0 * bubbleScale, 24.0, coord);
                
            gl_FragColor = 
                rays1 * 0.5 +
                rays2 * 0.4 +
                bubble1 * 0.25 +
                bubble2 * 0.1 +
                bubble3 * 0.18 +
                bubble4 * 0.13 +
                bubble5 * 0.15 +
                bubble6 * 0.05 +
                bubble7 * 0.12 +
                bubble8 * 0.11;

            float brightness = 1.0 - (coord.y / u_resolution.y);
            gl_FragColor.x *= 0.2 + (brightness * 0.8);
            gl_FragColor.y *= 0.3 + (brightness * 0.7);
            gl_FragColor.z *= 0.4 + (brightness * 0.6);
        }')
	public function new()
	{
		super();
	}
}

class OverlayShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header
    
    uniform vec4 uBlendColor;

    vec3 blendLighten(vec3 base, vec3 blend) {
        return mix(
            1.0 - 2.0 * (1.0 - base) * (1.0 - blend),
            2.0 * base * blend,
            step( base, vec3(0.5) )
        );
    }

    vec4 blendLighten(vec4 base, vec4 blend, float opacity)
    {
        return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
    }

    void main()
    {
        vec4 base = texture2D(bitmap, openfl_TextureCoordv);
        gl_FragColor = blendLighten(base, uBlendColor, uBlendColor.a);
    }')
	public function new()
	{
		super();
	}
}

class ColorSwapShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header

    uniform float uTime;
    uniform float money;
    uniform bool awesomeOutline;
    
    const float offset = 1.0 / 128.0;

    vec3 normalizeColor(vec3 color)
    {
        return vec3(color[0] / 255.0,color[1] / 255.0,color[2] / 255.0);
    }
    
    vec3 rgb2hsv(vec3 c)
    {
        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;

        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }
    
    vec3 hsv2rgb(vec3 c)
    {
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);

        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }
    
    void main()
    {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);
        
        // [0] is the hue???
        swagColor[0] += uTime;
        // swagColor[1] += uTime;
        
        // money += swagColor[0];
        
        color = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);
        
        
        if (awesomeOutline)
        {
            // Outline bullshit?
            vec2 size = vec2(3, 3);
                 
            if (color.a <= 0.5)
            {
                float w = size.x / openfl_TextureSize.x;
                float h = size.y / openfl_TextureSize.y;
                
                if (flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y)).a != 0.
                    || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y)).a != 0.
                || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + h)).a != 0.
                || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y - h)).a != 0.)
                
                color = vec4(1.0, 1.0, 1.0, 1.0);
            }
        }
        
        gl_FragColor = color;

        /* 
        if (color.a > 0.5)
            gl_FragColor = color;
        else
        {
            float a = flixel_texture2D(bitmap, vec2(openfl_TextureCoordv + offset, openfl_TextureCoordv.y)).a +
             flixel_texture2D(bitmap, vec2(openfl_TextureCoordv, openfl_TextureCoordv.y - offset)).a +
             flixel_texture2D(bitmap, vec2(openfl_TextureCoordv - offset, openfl_TextureCoordv.y)).a +
             flixel_texture2D(bitmap, vec2(openfl_TextureCoordv, openfl_TextureCoordv.y + offset)).a;
             
            if (color.a < 1.0 && a > 0.0)
                gl_FragColor = vec4(0.0, 0.0, 0.0, 0.8);
            else
                gl_FragColor = color;
        }
        */
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
