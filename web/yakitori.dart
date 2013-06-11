import 'dart:html';
import 'docObject.dart';
import 'commands.dart';
var modeList = ["Normal Mode","Insert Mode","CommandLine Mode","Visual Mode","Search Mode"];
int mode = 0;
var testRect;
List<docObject> targets = new List<docObject>();
List<Command> history = new List<Command>();
int layer=0;
		
var mainView = query("#output");
var input = query("#input");
var test3;
void main() {

	input.onKeyPress.listen(keyDown);
	query("#display").text = modeList[0];


	input.focus();
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

void keyDown(KeyboardEvent e){
	print(e.charCode);
	String t = new String.fromCharCode(e.$dom_keyCode);
	switch(t){
		case 'h':
			print(t);
			var c = new move(test3,-1,0);
			history.add(c);
			c.execute();
			break;
		case 'j':
			print(t);
			var c = new move(test3,0,-1);
			history.add(c);
			c.execute();
			break;
		case 'k':
			print(t);
			var c = new move(test3,0,1);
			history.add(c);
			c.execute();
			break;
		case 'l':
			print(t);
			var c = new move(test3,1,0);
			history.add(c);
			c.execute();
			break;
		case 'n':
			print(t);
			var c = new move(test3,1,0);
			history.add(c);
			c.execute();
			break;
		case 'm':
			print(t);
			var c = new move(test3,1,0);
			history.add(c);
			c.execute();
			break;
		case 's':
			for(final c in history)print(c.msg);
			break;
		default:
			break;
	}
}
void mouseClicked(MouseEvent e){
	testRect.absMove(e.clientX,e.clientY);
	//testRect.select(!testRect.selected);
	test3.deleteChars();
}