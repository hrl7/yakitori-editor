import 'dart:html';
import 'commands.dart';
var modeList = ["Normal Mode","Insert Mode","CommandLine Mode","Visual Mode","Search Mode"];
int mode = 0;
var testRect;
		
var mainView = query("#output");
var input = query("#input");
var test3;
var eval = new Evaluator(mainView);
var ime;

void main() {

	input.onKeyPress.listen(keyDown);
	//input.onKeyDown.listen((e)=>print("keyDowned"));
	input.onKeyUp.listen(keyUp);

	query("#display").text = modeList[0];

	ime = input.getInputContext();
/*
	var test = new svgTextArea(mainView);
	var test2 = new svgTextArea(mainView);
	test3 = new svgTextArea(mainView);

	test2.move(300,0);
	testRect = new rectangle(mainView);
	targets.add(testRect);

	testRect.move(100,40);
	test.move(0,100);
	test2.insertLine(0,text:"this is the test");
	for(int i=0;i<9;++i)test3.insertLine(test3.ownObjs.length,text:"this is $i times hello");
	for(int i=9;i<19;++i)test3.insertLine(0,text:"this is $i times hello");

	testRect.add(test);
	testRect.add(test2);
	testRect.add(test3);
	testRect.move(100,40);

	testRect.update();
	test3.cLine=4;
	test3.cChar=4;

	test3.select(true);
	test3.update();
	test3.changeChar(50);
	test3.changeLine(1);
*/	
	window.onClick.listen(mouseClicked);
	input.focus();
	window.onMouseMove.listen(mouseMove);
}

void cmdEval(int cmd){

}

void modeChange(int _mode){
 	mode = _mode;
 	query("#display").text = modeList[mode];
	switch(_mode){
    	case 0:
    	 	input.value ="";
    	 	input.classes.remove('show');
    	 	input.classes.add('hide');
    	  	break;
  		case 2:
  		 	input.value ="";
  		 	input.focus();
  		 	input.classes.remove('hide');
  		 	input.classes.add('show');
  			break;
  		case 1://Insert Mode
    	default:
    		break;
  	}
}
void mouseMove(MouseEvent e){
	input.focus();
}

void keyUp(KeyboardEvent e){
	print("upped: ${input.value} ${e.$dom_keyCode}");
	String t = input.value;
	if(e.ctrlKey){
		switch(e.$dom_keyCode){
			case 72:
				eval.moveObj(-50,0);
				break;
			case 75:
				eval.moveObj(0,-50);
				break;
			case 74:
				eval.moveObj(0,50);
				break;
			case 76:
				eval.moveObj(50,0);
				break;
			case 85:
				eval.moveLayer(false);
				break;
			case 68:
				eval.moveLayer(true);
				break;
			case 219:
				modeChange(0);
				break;
			default:
				break;
		}
	}else{
		if(mode==0){
			switch(t){
				case 'mr':
					eval.addObj("rect");
					input.value="";	
					break;
				case 'mt':
					eval.addObj("text");
					input.value="";
					break;	
				case 'h':
					eval.moveSelector(x:-1);
					input.value="";
					break;
				case 'l':
					eval.moveSelector(x:1);
					input.value="";
					break;
				case 'j':
					eval.moveSelector(y:1);
					input.value="";
					break;
				case 'k':
					eval.moveSelector(y:-1);
					input.value="";
					break;
				case 'i':
					modeChange(1);
					input.value="";
					break;
				case 'x':
					eval.edit();
					input.value="";
					break;
				default:
					if(eval.regExp(t))input.value="";
					break;
			}
		}else if(mode == 1){
			
		}
	}
}

void keyDown(KeyboardEvent e){
	//print("keydown: ${e.charCode}");
	String t = new String.fromCharCode(e.$dom_keyCode);

}
void mouseClicked(MouseEvent e){

}