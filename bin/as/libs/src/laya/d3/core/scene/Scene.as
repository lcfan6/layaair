package laya.d3.core.scene {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.RenderTexture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Scene</code> 类用于实现普通场景。
	 */
	public class Scene extends BaseScene {
		/**
		 * 创建一个 <code>Scene</code> 实例。
		 */
		public function Scene() {
			super();
		}
		
		protected override function _renderCamera(gl:WebGLContext, state:RenderState, baseCamera:BaseCamera):void {
			
				var camera:Camera = baseCamera as Camera;
				state.camera = camera;
				camera._prepareCameraToRender();
				beforeRender(state);//渲染之前
				var renderTarget:RenderTexture = camera.renderTarget;
				
				if (renderTarget) {
					renderTarget.start();
					Matrix4x4.multiply(_invertYScaleMatrix, camera.projectionMatrix, _invertYProjectionMatrix);
					Matrix4x4.multiply(_invertYScaleMatrix, camera.projectionViewMatrix, _invertYProjectionViewMatrix);
					state.projectionMatrix = _invertYProjectionMatrix;//todo:
					camera._setShaderValueMatrix4x4(BaseCamera.PROJECTMATRIX, _invertYProjectionMatrix);
					state.projectionViewMatrix = _invertYProjectionViewMatrix;//todo
				} else {
					state.projectionMatrix = camera.projectionMatrix;//todo
					camera._setShaderValueMatrix4x4(BaseCamera.PROJECTMATRIX, camera.projectionMatrix);
					state.projectionViewMatrix = camera.projectionViewMatrix;//todo
				}
				
				camera._setShaderValueMatrix4x4(BaseCamera.VIEWMATRIX, camera.viewMatrix);
				
				state.viewMatrix = camera.viewMatrix;
				state.viewport = camera.viewport;
				_preRenderScene(gl, state);
				_clear(gl, state);
				_renderScene(gl, state);
				
				lateRender(state);//渲染之后
				
				(renderTarget) && (renderTarget.end());
			
		
		}
	}
}