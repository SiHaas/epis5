//	caption.pde
//	Die Klasse Caption ist für die Legende zuständig
//	

class Caption{

	boolean healthyVisible = false;
	boolean infectedVisible = false;
	boolean vaccinedVisible = false;

	boolean mousePressedBefore = false;
	boolean dragMode = false;
	VaccineRing h6;

	Human h1 = new Human( windowResolution.x / 7 * 2.4, windowResolution.y - 30, false );
	Human h2 = new Human( windowResolution.x / 7 * 4.4, windowResolution.y - 30, false );
	Human h5 = new Human( windowResolution.x / 7 * 3.4, windowResolution.y - 30, false );

	Caption(){

		h2.setState( 1 );
		h2.timer.reset();
		h5.setState( 4 );
		h5.timer.reset();
		h6 = new VaccineRing( new PVector(-500,-500) );

	}

	void update(){

		h1.update();
		h2.update();
		h5.update();
		h6.update();

		dragVaccine();

	}

	void render(){

		//	Sobald einer der drei Legendenelemente sichtbar ist
		//	soll eine halbtransparente weiße Leiste dahinter gelegt
		//	werden
		if( healthyVisible || infectedVisible || vaccinedVisible ){
			fill(255, 200);
			rect( 0, windowResolution.y - 60, windowResolution.x, 60 );
		}

		if( healthyVisible ){
			h1.render();
			fill(0);
			text( "Gesund", h1.getPosition().x  + 20, h1.getPosition().y + 2.5 );
		}

		if( infectedVisible ){
			h2.render();
			fill(0);
			text( "Infiziert", h2.getPosition().x  + 20, h2.getPosition().y + 2.5 );
		}

		if( vaccinedVisible ){
			h5.render();
			fill(0);
			text( "Geimpft", h5.getPosition().x  + 20, h5.getPosition().y + 2.5 );
		}

		h6.render();


	}

	public void dragVaccine(){

		//	Falls die Maus gedrückt wurde innerhalb von einem Radius von 25 um 
		//	das Legendenelement "Geimpft", so wird der Dragmodus angeschaltet
		if( 	mousePressed && !mousePressedBefore &&
			PVector.dist( new PVector( mouseX, mouseY), h5.getPosition() ) <= 25){
			dragMode = true;
		}


		//	Ist der Dragmodus aktiviert, so soll h6 der Maus folgen
		if( dragMode 
			&& PVector.dist( new PVector(sim2.cam.getPosition().x+mouseX, sim2.cam.getPosition().y+mouseY), sim2.city.humans.get(91).getPosition() ) > 200  
		){
			h6.setPosition( new PVector( mouseX, mouseY ) );
		}


		//	Ist der Dragmodus aktiviert und die Maus nahe am Kind so soll der VaccineRing nahe an h6 sein
		if( dragMode 
			&& PVector.dist( new PVector(sim2.cam.getPosition().x+mouseX, sim2.cam.getPosition().y+mouseY), sim2.city.humans.get(91).getPosition() ) <= 200  
			&& PVector.dist( new PVector(sim2.cam.getPosition().x+mouseX, sim2.cam.getPosition().y+mouseY), sim2.city.humans.get(91).getPosition() ) > 100
		){
			PVector pv1 = 	PVector.sub( 
							new PVector(sim2.cam.getPosition().x+ mouseX,sim2.cam.getPosition().y+ mouseY) ,
							sim2.city.humans.get(91).getPosition()
							);
			pv1.normalize();
			h6.setPosition( 
				PVector.add(
					PVector.mult(
						pv1,
						50), 
					PVector.sub(
						sim2.city.humans.get(91).getPosition() ,
						sim2.cam.getPosition()
						)
					)
				);
		}
				//	Ist der Dragmodus aktiviert und die Maus nahe am Kind so soll der VaccineRing nahe an h6 sein
		if( dragMode 
			&& PVector.dist( new PVector(sim2.cam.getPosition().x+mouseX, sim2.cam.getPosition().y+mouseY), sim2.city.humans.get(91).getPosition() ) <= 100  
		){
			h6.setPosition( 
					PVector.sub(
						sim2.city.humans.get(91).getPosition() ,
						sim2.cam.getPosition()
						)
					);
		}



		//	Falls die Maus losgelassen wurde, so wird der Dragmodus ausgeschaltet
		if(  
			!mousePressed && mousePressedBefore &&  
			PVector.dist( new PVector(sim2.cam.getPosition().x+mouseX, sim2.cam.getPosition().y+mouseY), sim2.city.humans.get(91).getPosition() ) > 200  
		
		){
			dragMode = false;
			h6.setPosition( new PVector( - 500, -500 ) );	
		}


		//	Falls die Maus losgelassen wurde innerhalb des "Aktionsraumes", dann bitte impfen!
		if(  
			!mousePressed && mousePressedBefore &&  
			PVector.dist( new PVector(sim2.cam.getPosition().x+mouseX, sim2.cam.getPosition().y+mouseY), sim2.city.humans.get(91).getPosition() ) <= 200  
		
		){
			dragMode = false;
			h6.setPosition( new PVector( - 500, -500 ) );	
			sim2.city.humans.get(91).vaccinate();
		}




		if( mousePressed ){
			mousePressedBefore = true;
		}else{
			mousePressedBefore = false;
		}

	}

}