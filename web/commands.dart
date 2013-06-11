import 'docObject.dart';

abstract class Command{
	String successMessage;
	String msg;
  	docObject target;
  	
  	Command(){
  	}

  	execute(){
  	}
}

class move extends Command{
	int x,y,layer;
	bool abs;

	move(docObject _target,int _x,int _y,{int _layer:0,bool _abs:false}){
		target = _target;
		x = _x;
		y = _y;
		layer = _layer;
		abs = _abs;
		msg = "moving $x $y ";
	}

	execute(){
		if(target.type == "textArea"){
			if(abs){
				target.changeChar(x);
				target.changeLine(y);
			}else{
				if(x>0)target.l(x);
				else target.h(-x);

				if(y>0)target.k(y);
				else target.j(-y);
			}
		}
		super.execute();

	}
}

class edit extends Command{

	edit(docObject _target,String _text){

	}

	execute(){
		if(target.type == textArea){

		}
		super.execute();
		
	}
}