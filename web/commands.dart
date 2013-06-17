import 'docObject.dart';
import 'dart:html';
import 'dart:svg'as svg;

class Evaluator{
	List<docObject> targets = new List<docObject>();
	List<Command> hist = new List<Command>();
	svg.SvgElement view;
	int layer = 0;

	Evaluator(var _view){
		view = _view;
		targets.add(new rootObject());
		layer = 0;
	}
	void eval(String func,List args){
		 if(args != null&&funcs1.containsKey(func)){
		 	Function.apply(funcs1[func],args);
		 	}else print("not exist func");
	}


	bool regExp(String cmd){
		RegExp exp = new RegExp(r"([A-Za-z][1-9]*[A-Za-z])");
		var m = exp.firstMatch(cmd);
		if(m!=null){
			String match = m.group(0);	 
  			print("regExp: $match");
  			if(match.substring(0,1)==match.substring(match.length-1)){
  					test();

  				if("d"==match.substring(0,1)){
 						print("delete Line");
 						addObj("rect");

  				}	
  			}
  			return true;

		}else print("no match");
		return false;
	}


	test(){
		var c = new add("text",view);
		targets.add(c.execute());
		layer = targets.length-1;
		targets[layer].insertLine(0,text:"hello world");
		targets[layer].select(true);
		targets[layer-1].add(targets[layer]);
		print(layer);
	}
	addObj(String type){
		if(targets[layer].type != "textArea"){
			var c = new add(type,view);
			targets.add(c.execute());
			if(type =="text"){
				targets[targets.length-1].insertLine(0,text:"hello world");
			}
			if(type =="rect"){
				print("this is the rectangle");
			}
			targets[layer].select(true);
			targets[layer].ownObjs.add(targets[layer+1]);
			++layer;
			print(layer);
		}
	}

	moveObj(int _x,int _y){
		targets[layer].move(_x,_y);
	}

	moveLayer([bool dpr=true]){
		if(dpr){
			if(layer+1<targets.length){
				targets[layer].select(false);
				targets[++layer].select(true);
			}else{
				if(targets[layer].ownObjs.length>0&&
					targets[layer].type!="textArea"){
					targets.add(targets[layer].ownObjs[0]);
	
				}
			}
		}else{//move up layer
			if(layer>0){
				targets[layer].select(false);
				targets[--layer].select(true);
				targets.removeAt(layer+1);
			}
		}
		print("layer: $layer");
	}

	moveSelector({int x:0,int y:0}){
		if(targets[layer].type=="rectangle"){
			while(layer>=targets.length-2)targets.removeAt(layer+1);
			if(x>0||y>0)targets.add(targets[layer].moveSelector(true));
			else targets.add(targets[layer].moveSelector(false));
			print("selector move");
		}else if(targets[layer].type == "textArea"){
			if(x>0)targets[layer].l(x);
			if(x<0)targets[layer].h(-x);
			if(y>0)targets[layer].j(y);
			if(y<0)targets[layer].k(-y);
		}
	}
	insertChar(String text){
		if(targets[layer].type == "textArea"){
			targets[layer].insertChar("text");
		}
	}

}
abstract class Command{
	String successMessage;
	String msg;
  	docObject target;
  	
  	Command(){
  	}

  	execute(){
  	}
}
class add extends Command{
	String docType="";
	svg.SvgElement view;
	add(String _docType,svg.SvgElement _view){
		view = _view;
		docType = _docType;
	}

	docObject execute(){
		if(docType=="text"){
			var a = new svgTextArea(view);
			return a;
		}
		if(docType=="rect"){
			var a = new rectangle(view);
			return a;
		}
	}
}

class move extends Command{
	int x,y,layer;
	bool abs;

	move(docObject _target,{int _x:0,int _y:0,int _layer:0,bool _abs:false,List<docObject> objs}){
		target = _target;
		x = _x;
		y = _y;
		layer = _layer;
		abs = _abs;
		msg = "moving $x $y ";
	}

	execute(){
		if(objs!=null){
		} else if(target.type == "textArea"){
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

		super.execute();
	}
}