/*
JugglingList.as
*/
package  {
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class JugglingList {			
		//플리킹 Top 영역
		public var TOP:Number;
		//플리킹 Bottom 영역 
		public var BOTTOM:Number;
		//리스트의 전체 높이
		private var LIST_H:Number;
		//리스트 1개의 높이
		private var CELL_H:Number;
		//리스트 내부의 전체 라인수
		private var TOTAL:Number;
		//리스트 배열
		private var listArr:Array;
		
		public var topIndex:Number = 0; //data index
		//public var viewTopIndex:Number = 0; //data index
		public var topMCIndex:Number = 0; //mc index
		//public var viewTopMCIndex:Number = 0;// mc index
		
		public var dataUpdate:Function;
		
		//플리킹의 대상 
		public var tar:MovieClip;
		
		public function JugglingList(list_mc:MovieClip, top:Number, bottom:Number) {
			// constructor code
			this.tar = list_mc;
			this.TOP = top;
			this.BOTTOM = bottom;		
						
		}
		
		//리스트의 전체 개수, 리스트 1개의 높이 
		public function setLength(total:Number, h:Number, list:Array, dataset:Function = null){
			this.CELL_H = h;
			this.LIST_H = total*h;
			this.TOTAL = total;
			this.listArr = list;						
			this.dataUpdate = dataset;
		}
		
		public function listUpdate(){
			var gap:Number = 0; //벌어진 정도
			var lstmc = lastMC();			
			var lstPos:Number = getGlobalY(lstmc) + CELL_H;
			var fstPos:Number = getGlobalY(listArr[topMCIndex]);
			//trace(fstPos +"/"+ lstPos);
			var i:Number;
			//하단을 벗어난 경우			
			if(lstPos < BOTTOM){				
				gap = Math.ceil((BOTTOM - lstPos)/CELL_H);

				if((topIndex + listArr.length + gap) >= TOTAL){
					gap = TOTAL - (topIndex + listArr.length);
				}

				for(i=0; i<gap; i++){									
					listArr[topMCIndex].y = lastMC().y + CELL_H;
					if(dataUpdate != null){
						dataUpdate(topIndex + listArr.length, listArr[topMCIndex]);
					}
					topMCIndex ++; 
					topIndex ++;
					if(topMCIndex >= listArr.length){
						topMCIndex = 0;
					}					
				}
			}else if(fstPos > TOP){ //상단을 벗어나는 경우 
				gap = Math.ceil((fstPos - TOP)/CELL_H);
				
				if(topIndex - gap <= 0){
					gap = topIndex;
				}
				
				for(i=0; i<gap; i++){									
					lstmc = lastMC();
					lstmc.y = listArr[topMCIndex].y - CELL_H;
					
					if(dataUpdate != null){
						dataUpdate(topIndex - 1, lstmc);
					}										
					
					topMCIndex --; 
					topIndex --;
					if(topMCIndex < 0 ){
						topMCIndex = listArr.length - 1;
					}				
					if(topIndex < 0) topIndex = 0;
				}
			}
		
		}
		//마지막 무비클립을 구합니다. 
		private function lastMC():MovieClip{
			var num = topMCIndex + listArr.length - 1;
			if(num >= listArr.length){
				num =  topMCIndex - 1;				
			}			
			return listArr[num];
		}		
		
		//global Y 좌표를 리턴합니다.
		private function getGlobalY(mc:MovieClip):Number{
			var num:Point = this.tar.localToGlobal(new Point(0, mc.y));
			return num.y;			
		}
	}		
}