package  {
	import flash.filters.*;
	import flash.display.*;
	import flash.geom.ColorTransform;
    
	public class FilterEffect {
		
		//필터 효과들을 상수로 구분합니다.
		public const BEVEL:int = 1;    
		public const BLUR:int = 2;     
		public const DROPSHADOW:int = 3;   
		public const GLOW:int = 4; 
		
		//filter array
		private var fArr:Array;
		
		public function FilterEffect() {

		}
		
		//적용한 필터를 제거합니다.
		public function removeFilter(tar:DisplayObject){
			fArr = new Array();
			tar.transform.colorTransform = new ColorTransform()
			tar.filters = fArr;
		}		
		
		//필터를 적용합니다. 효과를 적용할 무비클립, 필터종류
		public function addFilter(tar:DisplayObject, eff:Number){
			
			//DisplayObject 의 filters 를 복사합니다. 
			fArr = tar.filters;
			
			switch(eff){
				case BEVEL: 
					fArr.push(new BevelFilter());
					break;
				case BLUR:
					fArr.push(new BlurFilter(2, 2, BitmapFilterQuality.HIGH));
					break;
				case DROPSHADOW:
					fArr.push(new DropShadowFilter());
					break;
				case GLOW:
					fArr.push(new GlowFilter());
					break;
			}
			tar.filters = fArr;
		}
	}
	
}
