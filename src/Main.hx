
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
        Luxe.renderer.state.bindFramebuffer();
        Luxe.renderer.state.bindRenderbuffer();
        
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
        
        // batcher = Luxe.renderer.create_batcher({
        //     name: 'eye',
        //     camera: new phoenix.Camera({camera_name: 'eye_view'}),
        //     no_add: true,
        //     layer: 1000,
        // });
        
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
    
    override function onprerender() {
        frame = Gvr.swapChainAcquireFrame(swapChain);
        var time = Gvr.getTimePointNow();
        head = Gvr.getHeadSpaceFromStartSpaceRotation(context, time);
        Gvr.frameBindBuffer(frame, 0);
    }
    
    override function onpostrender() {
        Gvr.frameUnbind(frame);
        Gvr.frameSubmit(frame, viewportList, head);
        
        Luxe.renderer.state.bindFramebuffer();
        Luxe.renderer.state.bindRenderbuffer();
    }
    

    override function update(delta:Float) {
        for(i in 0...visuals.length) visuals[i].rotation_z += (i-50) / 500;

    } //update
    
    

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

} //Main
