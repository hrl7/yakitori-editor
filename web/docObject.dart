import 'dart:html';
import 'dart:svg' as svg;

abstract class docObject{
	int x=0,y=0,width=30,height=30,layer;
	List<docObject> ownObjs;
	String id,type;
	bool selected=false;
	svg.SvgSvgElement _doc;
	
	docObject(){
		ownObjs= new List<docObject>();
	}
	
	update(){
	}
  
	add(docObject target){
		ownObjs.add(target);  	
	}

	move(int _x,int _y){
		x += _x;
		y += _y;
		update();
	}

	select(bool _selected){
		selected = _selected;
		update();
	}

	remove(){}

	getArea(){}
	h([int back=1]){

	}
	j([int down=1]){
	}	
	k([int up=1]){
	}	
	l([int forward=1]){
	}

}

class rootObject extends docObject{
	rootObject(){
		print("init");
	}
}

class svgTextArea extends docObject{
	int marginX=10,marginY=10,cLine=0,cChar=0,fontSize=25,lines=0;

	String LE="_";//the character that put end of the each lines
	String fontFamily = "Verdana",id="";
	svg.TextElement area;
	textCursor cursor;

	svgTextArea(var doc){
		type = "textArea";
		_doc = doc;
		cursor = new textCursor();
		area = new svg.TextElement();

    	area.$dom_setAttribute("font-family",fontFamily);
    	area.$dom_setAttribute("font-size","${fontSize}");
		area.$dom_setAttribute("x","${x}px");
    	area.$dom_setAttribute("y","${y}px");
		_doc.children.add(area);
		_doc.children.add(cursor.rec);

		update();
	}
	update(){
		super.update();
		for(var i=0;i<ownObjs.length;++i){
			_update(ownObjs[i],i);
		}
		updateCursor();
	}
	_update(textLine _s,int _line){
		_s.id="textLine_$_line";
		_s.setPos(x,(1+_line)*fontSize+y);


	}
	void insertChars(String t){
		String fs, s = ownObjs[cLine].text;
		fs = s.substring(0,cChar);
		fs += t;
		fs += s.substring(cChar);
		ownObjs[cLine].text = fs;
		if(cChar!=s.length)++cChar;
		updateCursor();
	}

	void deleteChars([int d=1]){
		if(ownObjs[cLine].text.length==1){
			deleteLines(cLine);
		}else {
			if(d == ownObjs[cLine].text.length-1)changeChar(cChar-1);
				String fs, s = ownObjs[cLine].text;
				fs = s.substring(0,cChar);
				fs += s.substring(cChar+d);
				ownObjs[cLine].text = fs;	
		}
		updateCursor();
	}

	void h([int back=1]){
		changeChar(cChar-back);
	}
	void j([int down=1]){
		changeLine(cLine+down);
	}	
	void k([int up=1]){
		changeLine(cLine-up);
	}	
	void l([int forward=1]){
		changeChar(cChar+forward);
	}
	/*
	void deleteChars([int d=1]){
		if(ownObjs[cLine].s.text.length==1){
			deleteLine(cLine);

		}else{
			while(d+cChar >= ownObjs[cLine].s.text.length)changeChar(cChar-1);
				String fs, s = ownObjs[cLine].s.text;
				fs = s.substring(0,cChar);
				fs += s.substring(cChar+d);
				area.children[cLine].text = fs;
			
		}
		updateCursor();

	}*/

	Rect getArea(){
		var r = new Rect(x-marginX,
					y-marginY,
					area.client.width+marginX*2,
					area.client.height+marginY*2);
		print("rect $r");
		return r;
	}
	select(bool _selected){
		super.select(_selected);
		cursor.selected = _selected;
	}

	insertLine(int line,{String text,textLine target}){
		if(text != null){
			var s = new textLine(x,line*fontSize,text);
			_add(s,line);
		}else if(target != null){
			_add(target,line);
		}
		addLineEnd(line);
		update();
	}


	_add(docObject target ,[int line = -1]){
		++lines;
		if(line != -1&&line <ownObjs.length){
			ownObjs.insert(line,target);
			area.children.insert(line,target.s);
			print("inserted in $line");
		} else{
			super.add(target);
			area.children.add(target.s);
			if(line !=-1)print("error in inserting Line at $line but there'is $lines lines");
		}
		target.id ="textLine_$line";
	}

	void updateCursor(){

		if(ownObjs.length!=0){
		   	var tp = ownObjs[cLine].s.getStartPositionOfChar(cChar);
		 	var ep = ownObjs[cLine].s.getEndPositionOfChar(cChar);
			int a,b,c;	
	   		a = tp.x.round();
	    	b = tp.y.round()-fontSize;
	    	c = ep.x.round()-a;
	    	cursor.selected = selected;
	 		cursor.setCursor(a,b,c,fontSize);
   		}
  	}

	void changeChar(int x){
		if(x>=0&&x<ownObjs[cLine].s.text.length-1){
			cChar = x;
		}else if(x<0){
			changeLine(cLine-1);
		}else if(x==ownObjs[cLine].s.text.length-1){
			if(cLine!=lines-1)cChar = 0;
			changeLine(cLine+1);
		}else print("error: cannot acces the $x th char");
		print("$x chars moved");
		updateCursor();
	}

	void changeLine(int y){
		if(y>=0&&y<ownObjs.length){
			cLine = y;
			if(ownObjs[cLine].s.text.length==1){
				cChar=0;
			} else if(cChar>ownObjs[cLine].s.text.length-2){
				cChar = ownObjs[cLine].s.text.length-2;
			}
		}
		print("$cLine lines moved");
		updateCursor();
	}

	void deleteLine(int l){
		if(l>0&&l<ownObjs.length){
			ownObjs.removeAt(l);
			area.children[l].remove();
			--lines;
			if(cLine>=lines)changeLine(lines-1);
			update();
		}else print("error :cannot delete line,line $l is not exist");

	}

	void addLineEnd(int l){
		if(!ownObjs[l].s.text.endsWith(LE)){
			ownObjs[l].s.text+=LE;
		}
	}


}

class textLine extends docObject{//this object is exist in svgTextArea or textLine
	String text;
	svg.TSpanElement s;

	textLine([int _x=0,int _y=0,String text="hello wordld"]){
		type ="textLine";
		x = _x;
		y = _y;
		s = new svg.TSpanElement();
		s.$dom_setAttribute("x","${x}px");
    	s.$dom_setAttribute("y","${y}px");
		s.text = text;
	}

	setPos(int _x,int _y){
		x = _x;
		y = _y;
    	s.$dom_setAttribute("id","$id");

		s.$dom_setAttribute("x","${x}px");
    	s.$dom_setAttribute("y","${y}px");
	}

}

class rectangle extends docObject{
	int selectObj = 0;
	var rect = new svg.RectElement();
	rectangle(var doc,{int tx:10,int ty:10,int twidth:100,int theight:100,docObject target}){
		type ="rect";
		x = tx;
		y = ty;
		width = twidth;
		height = theight;
		if(target != null)ownObjs.add(target);
		rect.$dom_setAttribute("x","${x}px");
		rect.$dom_setAttribute("y","${y}px");
		rect.$dom_setAttribute("width","${width}px");
		rect.$dom_setAttribute("height","${height}px");
		rect.$dom_setAttribute("fill-opacity","0.0");
		rect.$dom_setAttribute("stroke-opacity","0.4");
		rect.$dom_setAttribute("stroke","red");
		_doc = doc;
		_doc.children.add(rect);
	}

	move(int _x,int _y){
		super.move(_x,_y);
		for(final obj in ownObjs)obj.move(_x,_y);
		update();
		print("move");
	}

	absMove(int _x,int _y){
		move(_x-x,_y-y);
	}
	docObject moveSeletor([bool fw=true]){
		if(fw){
			if(selectObj < ownObjs.length-1 )return ownObjs[++selectObj];
		}else if(selectObj>0)return ownObjs[--selectObj];
	}
	update(){
		chkArea();
		rect.$dom_setAttribute("x","${x}px");
		rect.$dom_setAttribute("y","${y}px");
		rect.$dom_setAttribute("width","${width}px");
		rect.$dom_setAttribute("height","${height}px");
		rect.$dom_setAttribute("fill-opacity","0.0");
		rect.$dom_setAttribute("stroke-opacity","1.0");
		if(selected){
			rect.$dom_setAttribute("stroke","red");
			rect.$dom_setAttribute("stroke-width","10");
		}else{
			rect.$dom_setAttribute("stroke","black");
			rect.$dom_setAttribute("stroke-width","2");
		}
	}

	chkArea(){
		int _x,_y,_w,_h;
		if(ownObjs.length !=0){
			_x = ownObjs[0].getArea().left;
			_y = ownObjs[0].getArea().top;
			_w = ownObjs[0].getArea().bottomRight.x;
			_h = ownObjs[0].getArea().bottomRight.y;
			
			if(ownObjs.length >0){
				for(var i=0;i<ownObjs.length;++i){
					print("getArea ${ownObjs[i]} $i");
					if(ownObjs[i].getArea().left<_x)_x=ownObjs[i].getArea().left;
					if(ownObjs[i].getArea().top<_y)_y=ownObjs[i].getArea().top;
					if(ownObjs[i].getArea().bottomRight.x>_w)_w=ownObjs[i].getArea().bottomRight.x;
					if(ownObjs[i].getArea().bottomRight.y>_h)_h=ownObjs[i].getArea().bottomRight.y;
				}
			}
			x = _x;
			y = _y;
			width = _w-x;
			height = _h-y;
		}
	}



}
class circle extends docObject{
	circle(){
		type ="circle";
	}
}
class arrow extends docObject{
	arrow(){
		type="arrow";
	}
}

class textCursor{
	int x,y,dx,dy=20;
	svg.RectElement rec;
	bool selected=false;
	textCursor(){
    	rec= new svg.RectElement();
    	rec.$dom_setAttribute("fill","black");
    	rec.$dom_setAttribute("fill-opacity","0.1");
    	rec.$dom_setAttribute("stroke","black");
    	rec.$dom_setAttribute("x","${4}px");
    	rec.$dom_setAttribute("y","${4}px");
    	rec.$dom_setAttribute("width","${20}px");
    	rec.$dom_setAttribute("height","${20}px");
	}
 
	void setCursor(int _x,int _y,int _dx,int _dy){
	 	x = _x;
		y = _y;
		dx = _dx;
		dy = _dy;
	   	update();
	}
 
	void update(){
   		rec.$dom_setAttribute("x","${x}px");
   		rec.$dom_setAttribute("y","${y}px");
   		rec.$dom_setAttribute("width","${dx}px");
   		rec.$dom_setAttribute("height","${dy}px");
   		print("selected $selected");
   		if(selected){
	    	rec.$dom_setAttribute("fill-opacity","0.1");
	    	rec.$dom_setAttribute("stroke-opacity","0.9");
   		}else{
	    	rec.$dom_setAttribute("fill-opacity","0.0");
	    	rec.$dom_setAttribute("stroke-opacity","0.0");
   		}
 	}

}
