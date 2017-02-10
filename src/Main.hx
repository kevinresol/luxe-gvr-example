
import gvr.c.*;
import luxe.GameConfig;
import luxe.Input;
import luxe.Visual;
import luxe.Vector;
import luxe.Color;
import phoenix.RenderTexture;
import phoenix.Batcher;
import phoenix.Camera;
import phoenix.geometry.QuadGeometry;
import snow.modules.opengl.GL;

// @:unreflective
class Main extends luxe.Game {
    
    

    override function config(config:GameConfig) {

        config.window.title = 'luxe game';
        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;

        return config;
        

    } //config


    var context:Context;
    var viewportList:BufferViewportList;
    var leftEyeViewport:BufferViewport;
    var rightEyeViewport:BufferViewport;
    var swapChain:SwapChain;
    var frame:Frame;
    var head:Mat4f;
    var visuals:Array<Visual>;
    
    var default_fbo:GLFramebuffer;
    var texture:RenderTexture;
    var batcher:Batcher;
    
    override function ready() {
        texture = new RenderTexture({id: 'name', width: 512, height: 512});
        context = Gvr.create();
        Gvr.initializeGl(context);
        viewportList = Gvr.getRecommendedBufferViewports(context);
        swapChain = Gvr.swapChainCreate(context, 1);
        
        visuals = [];
        
        for(i in 0...100) {
            var size = new Vector(Math.random() * 300 + 100, Math.random() * 300 + 100);
            visuals.push(new Visual({
                size: size,
                origin: size.divideScalar(2),
                pos: new Vector(Math.random() * Luxe.screen.width, Math.random() * Luxe.screen.height),
                color: new Color(Math.random(), Math.random(), Math.random(), 1), 
            }));
        }
        Luxe.renderer.clear_color.rgb(0xffffff);
        
        batcher = Luxe.renderer.create_batcher({
            name: 'eye',
            camera: new phoenix.Camera({camera_name: 'eye_view'}),
            no_add: true,
            layer: 1000,
        });
        
        // var display_quad = new QuadGeometry({
        //     batcher: batcher,
        //     texture: texture,
        //     x: 0, y: 0, w: Luxe.screen.w, h: Luxe.screen.h,
        // });
        
        // default_fbo = Luxe.renderer.default_fbo;
        // Luxe.renderer.default_fbo = texture.fbo;
        // GL.bindFramebuffer(GL.FRAMEBUFFER, texture.fbo);
        
        // Luxe.on(luxe.Ev.tickstart, ontickstart);
        // Luxe.on(luxe.Ev.tickend, ontick);
        // Luxe.on(luxe.Ev.update, onupdate);
    } //ready
    

    override function update(delta:Float) {
        for(i in 0...visuals.length) visuals[i].rotation_z += (i-50) / 500;

    } //update
    
    function ontickstart(_) {
        trace(opengl.WebGL.getError());
        GL.bindFramebuffer(GL.FRAMEBUFFER, texture.fbo);
    }
    
    var debug = false;
    function ontick(_) {
        trace(opengl.WebGL.getError());
        if(!debug) {
            debug = true;
            var frame = Gvr.swapChainAcquireFrame(swapChain);
            var time = Gvr.getTimePointNow();
            var head = Gvr.getHeadSpaceFromStartSpaceRotation(context, time);
            var fboId = Gvr.frameGetFramebufferObject(frame, 0);
            trace('gvr: $fboId default:${Luxe.renderer.default_fbo}');
            Gvr.frameSubmit(frame, viewportList, head);
            batcher.draw();
            Luxe.renderer.state.bindFramebuffer();
            trace(opengl.WebGL.getError());
            untyped __cpp__('glInsertEventMarkerEXT(0, "com.apple.GPUTools.event.debug-frame")');
        }
        // trace(Gvr.getErrorString(Gvr.getError(context)));
        // var fbo = new GLFramebuffer(fboId);
        
        // GL.bindFramebuffer(GL.FRAMEBUFFER, fbo);
        
        
        // Gvr.frameUnbind(frame);
        // GL.bindFramebuffer(GL.FRAMEBUFFER, default_fbo);
        // Gvr.frameSubmit(frame, viewportList, head);
    }
    
    function onupdate(_) {
        
    }
    

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

} //Main
