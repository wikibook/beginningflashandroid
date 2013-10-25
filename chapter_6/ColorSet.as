
package  {
	import flash.display.*;
	import flash.geom.ColorTransform;
	
	public class ColorSet {

		public function ColorSet() {
		}

		public function hexToargb(val:Number){
			var col:Array = new Array();
			col.alpha = (val >> 24) & 0xFF;
			col.red = (val >> 16) & 0xFF;
			col.green = (val >> 8) & 0xFF;
			col.blue = val & 0xFF;
			return col;
		}
		public function argbTohex(a:Number, r:Number, g:Number, b:Number){
			return (a<<24 | r<<16 | g<<8 | b);
		}
		public function set_colorMC(_mc:MovieClip, ap:Number, r:Number, g:Number, b:Number){
			_mc.transform.colorTransform = new ColorTransform(1, 1, 1, 1, r, g, b, ap);
		}	
	}
	
}
