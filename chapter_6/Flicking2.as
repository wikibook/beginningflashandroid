// Flicking.as 
//-----------------------------------------

package  {
	import flash.display.*;	
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.geom.Rectangle;


	public class Flicking2{
		//플리킹 Top 영역
		public var TOP:Number;
		//플리킹 Bottom 영역 
		public var BOTTOM:Number;
		//리스트가 보여지는 영역 : BOTTOM - TOP
		private var CONT_H:Number;
		
		//플리킹의 대상 
		public var tar:MovieClip;
		
		//스크롤바의 사용여부 
		private var scrollFlag:Boolean;
		//scrollbar
		private var sc:MovieClip;
		//scrollbar size
		private var scSize:Number;
				
		private var ypArr:Array; //이동한 거리를 저장
		private var prvYpos:Number;//이전의 y좌표		
		private var pressy:Number; 		
		//리스트가 움직이는 동안 호출될 함수
		public var onMove:Function;
		
		private var moveGubun:Boolean = true; //true : move, false : flick  
		private var flickTarY:Number; //flick 할 거리 
		private var cnt:Number = 0;
		
		//플리킹 하여 자리를 찾아가기 
		//public var flickConst:Array = [0.35, 0.25, 0.15, 0.1, 0.05, 0.04, 0.03, 0.02, 0.01];
		public var flickConst:Array = [0.35, 0.25, 0.15, 0.1, 0.06, 0.04, 0.02, 0.015, 0.01, 0.005, 0];

		
		//생성자
		public function Flicking2(list_mc:MovieClip, top:Number, bottom:Number) {
			// constructor code			
			
			this.tar = list_mc;
			this.TOP = top;
			this.BOTTOM = bottom;
			this.CONT_H = bottom - top;
			
			//스크롤바의 사용 여부 		
			this.scrollFlag = false;		
			//Flicking 여부를 판별
			if(this.tar.height > this.CONT_H){
				
				this.tar.addEventListener(MouseEvent.MOUSE_DOWN, touchDown);
				this.tar.addEventListener(MouseEvent.MOUSE_UP, touchUp);
			}			
		}
		
		
		private function touchDown(evt:Event){
			ypArr = new Array(); //초기화 
			prvYpos = getY(); //이전 좌표
			pressy = this.tar.mouseY;
			moveGubun = true;
			this.tar.addEventListener(Event.ENTER_FRAME, touchMove);			
		}
		
		private function touchUp(evt:Event){
			
			//Top, Bottom 체크하여 제자리로 돌아갑니다.
			if(this.tar.y > this.TOP){ //top
				flickTarY = this.TOP - this.tar.y;				
			}else if((this.tar.y + this.tar.height) < this.BOTTOM){//bottom
				flickTarY = this.BOTTOM - this.tar.height - this.tar.y;
				//moveTo(this.BOTTOM - this.tar.height);
			}else{ 
				// 규칙1. 거리(속도) 측정				
				// 플릭킹 판단위치 내의 거리 합
				var sum:Number = 0;
				
				for(var i=0;i<3;i++){
					sum += (ypArr[i])?(ypArr[i]):(0);
				}				
								
				//플리킹할 추가 거리 				
				flickTarY = Math.floor(sum/3)*10;
				
				//거리가 Top, Bottom 영역을 벗어나는 경우 
				sum = this.tar.y + flickTarY;			
				if(sum > this.TOP){ //top
					flickTarY = this.TOP - this.tar.y;		
				}else if((sum + this.tar.height) < this.BOTTOM){//bottom
					flickTarY = this.BOTTOM - this.tar.height - this.tar.y;
				}				
							
			}
			//flicking 으로 전환
			cnt = 0;
			moveGubun = false;
		}
				
		private function touchMove(evt:Event){
			if(moveGubun){ //move
				this.tar.y =  getY() - pressy;
				
				//Top, Bottom 을 벗어나는 경우 1:1 이 아닌 조금 늘어지게 표현함
				if(this.tar.y > this.TOP){ //top
					this.tar.y -= 2;
				}else if((this.tar.y + this.tar.height) < this.BOTTOM){//bottom
					this.tar.y += 2;
				}			
							
				
				// 차례로 배열에 y거리 push
				if(ypArr.length>2) ypArr.shift();
				var n:Number = getY() - prvYpos;
				ypArr.push(n);
				
				prvYpos = getY(); //이전 좌표
				
			}else{ //flick 
				this.tar.y += flickTarY*flickConst[cnt];
				cnt ++;
				if(cnt >= flickConst.length){
					this.tar.removeEventListener(Event.ENTER_FRAME, touchMove);					
				}				
			}
			
			//스크롤바 작동
			if(scrollFlag){
				this.sc.visible = true;
				setScrollPos();
			}
			if(onMove != null){
				onMove();
			}			
		}
		
				
		//root.mouseY 좌표를 리턴함.
		private function getY():Number{
			var np:Point = this.tar.localToGlobal(new Point(0, this.tar.mouseY))			
			return np.y;
		}
		
		//scroll bar 관련 기능 ================================
		
		//스크롤바를 추가합니다.
		public function addScroll(sc:MovieClip):Boolean{
			//초기화 합니다.
			sc.visible = false;
			this.scrollFlag = false;
			this.sc = sc;
			
			//sc 의 내부구조는 3개의 무비클립으로 구성됩니다.
			if(sc.numChildren == 3){
				scrollFlag = true;
				//스크롤바의 크기 계산 
				//스크롤바크기:영역  = 영역:리스트길이 				
				//this.scper = this.CONT_H/this.tar.height;
				this.scSize = int(this.CONT_H/this.tar.height*this.CONT_H); 
				
				setScrollPos();
				//setScrollSize();				
				//trace(sc.numChildren);
			}
			return this.scrollFlag;
		}
		
		//스크롤바의 크기를 조절합니다.
		private function setScrollSize(){
			var tarSize = this.scSize;			
			
			//TOP 영역을 벗어나는 경우
			if(this.tar.y > this.TOP ){
				tarSize = this.scSize - this.TOP + this.sc.y;
				this.sc.y = this.TOP;
			}else if((this.tar.y + this.tar.height) < this.BOTTOM){
			//BOTTOM 영역을 벗어나는 경우 	
				tarSize = this.scSize - this.sc.y - this.sc.height + this.BOTTOM;			
				this.sc.y = this.BOTTOM - tarSize;
			}
			
			//예외 처리 
			if(tarSize < 4)tarSize = 4;
			tarSize = int(tarSize);
			
			this.sc.mid_mc.height = tarSize - this.sc.top_mc.height + this.sc.bottom_mc.height;
			this.sc.bottom_mc.y = this.sc.mid_mc.y + this.sc.mid_mc.height;			
		}
		
		//스크롤바의 위치를 설정합니다.
		private function setScrollPos(){
			this.sc.y = this.CONT_H*-(this.tar.y - this.TOP)/this.tar.height + this.TOP;
			
			setScrollSize();
		}
		
	}	
}

