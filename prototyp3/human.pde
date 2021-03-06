//	human.pde
//	Die Klasse Human sagt bereits mit dem Namen alles aus
//	

class Human{

	protected PVector position = new PVector( 0, 0 );
	protected PVector positionAlteration = new PVector( 0, 0 );
	protected float myColorRed = 0;
	protected float myColorGreen = 0;
	protected float myColorBlue = 200;
	protected float myAlpha = 255;
	protected float radius = 0;
	protected float radiusExtended = 0;
	protected boolean relativeToCamera = true;
	protected Simulation mySim;

	//	Status der Person; 0: gesund, 1: infiziert, aber ohne anzeichen, 2: infiziert, mit anzeichen, 3: im Krankenhaus, 4: geimpft
	protected int state = 0;
	protected Timer timer = new Timer( 10000 + random(-5000, 5000), true );
	protected int fadeStatus = 0;
	protected boolean fadedOut = false;


	Human( float posX, float posY, Simulation _sim ){

		position.x 		= posX;
		position.y 		= posY;
		positionAlteration.x 	= noise( position.x, position.y );
		positionAlteration.y 	= noise( position.y, position.x );
		position.x 		+= positionAlteration.x * 12 ;
		position.y 		+= positionAlteration.y * 12;
		radius			= humanRadius;
		radiusExtended	= humanRadiusExtended;
		mySim 			= _sim;

	}

	Human( float posX, float posY , boolean _relativeToCamera){

		position.x 		= posX;
		position.y 		= posY;
		radius			= humanRadius;
		radiusExtended	= humanRadiusExtended;
		relativeToCamera	= _relativeToCamera;

	}


	public void update(){

		timer.update();

		fadeIn();
		fadeOut();

		if( currentStatus == 1 ){
			fadedOut = true;
		}else{
			fadedOut = false;
		}

		//	Wechsel von Status 1 (Infiziert, ohne Symptome) auf 2 (Infiziert, mit Symptomen)
		if( state == 1 && !timer.paused && !timer.isAlive() ){

			timer.reset();
			timer.set( 3000 + random(-1000,1000) );
			timer.start();
			state = 2;

		}

		//	Wechsel von Status 2 (Infiziert, mit Symptomen) auf 3 (Krankenhaus)
		if(state == 2 && !timer.paused && !timer.isAlive() ){

			timer.reset();

				if( percentChance( 13 ) ){
					state = 3;
				}

		}

		//	Farbe einstellen, je nach Status
		if(state == 0){		//	Gesund
			myColorRed = 2;
			myColorGreen = 191;
			myColorBlue = 249;
		}else if(state == 1 || state == 2 || state == 3){	//	Infiziert
			myColorRed = 239;
			myColorGreen = 42;
			myColorBlue = 22;
		}else if(state == 4){	// 	Geimpft
			myColorRed = 2;
			myColorGreen = 191;
			myColorBlue = 249;
		}

	}


	public void render(){

		noStroke();

		if(relativeToCamera){

			if( state == 4 ){

				fill( 44, 73, 153, myAlpha );
				ellipse( (position.x - mySim.cam.getPosition().x) * mySim.cam.getZoom(), 
					(position.y - mySim.cam.getPosition().y) * mySim.cam.getZoom(), 
					(radius+radiusExtended) * mySim.cam.getZoom(), 
					(radius+radiusExtended) * mySim.cam.getZoom() );

				fill( myColorRed, myColorGreen, myColorBlue, myAlpha );
				ellipse( 
					(position.x - mySim.cam.getPosition().x) * mySim.cam.getZoom(), 
					(position.y - mySim.cam.getPosition().y) * mySim.cam.getZoom(), 
					(radius) * mySim.cam.getZoom(), 
					(radius) * mySim.cam.getZoom() );

			}
			else{

				fill( myColorRed, myColorGreen, myColorBlue, myAlpha );
				ellipse( 
					(position.x - mySim.cam.getPosition().x) * mySim.cam.getZoom(), 
					(position.y - mySim.cam.getPosition().y) * mySim.cam.getZoom(), 
					(radius+radiusExtended) * mySim.cam.getZoom(), 
					(radius+radiusExtended) * mySim.cam.getZoom() );

			}

		}

		if(!relativeToCamera){

			if( state == 4 ){

				fill( 44, 73, 153 );
				ellipse( (position.x), 
					(position.y), 
					(radius+radiusExtended), 
					(radius+radiusExtended)
					);

				fill( myColorRed, myColorGreen, myColorBlue );
				ellipse( 
					(position.x), 
					(position.y), 
					(radius), 
					(radius)
					);

			}
			else{

				fill( myColorRed, myColorGreen, myColorBlue, myAlpha );
				ellipse( 
					(position.x), 
					(position.y), 
					(radius+radiusExtended), 
					(radius+radiusExtended)
					);

			}
			
		}

	}


	public void fadeOut(){

		if( fadedOut && relativeToCamera ){

			if( fadeStatus < 200 ){
				fadeStatus++;
				myAlpha = 255 - fadeStatus;
			}
			else{
				myAlpha = 55;
			}

		}

	}


	public void fadeIn(){

		if( !fadedOut && relativeToCamera ){		

			if( fadeStatus < 255 ){
				fadeStatus--;
				myAlpha = 255 - fadeStatus;
			}
			else{
				myAlpha = 255;
			}

		}

	}


	public boolean inRange( Human h ){

		if( PVector.dist( this.position, h.position ) < sim.infectionRange ){

			return true;

		}

		return false;

	}


	public boolean isInfecting(  ){

		if( this.state == 1 || this.state == 2 ){
			return true;
		}

		return false;

	}


	public void setPosition( PVector _pos ){
		position = _pos;
	}


	public void infect(){

		//	es kann nur infiziert werden, wer es noch nicht ist!
		//	bzw. wer nicht geimpft ist
		if(this.state == 0){
			this.state = 1;
			timer.start();
		}

	}


	public void vaccinate(){

		//	Mensch wird geimpft, falls er es noch nicht ist.
		if(this.state != 4){
			this.state = 4;
		}

	}


	public void setState( int _state ){
		state = _state;
	}


	public PVector getPosition(){
		return position;
	}

}