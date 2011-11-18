
// The trigger class, by kritzikratzi
class Trigger{
  long start = millis(); 
  int rate; 
  
  public Trigger( int rate ){
    this( rate, false ); 
  }
  
  /**
   * additional boolean parameter to indicate whether the trigger 
   * should fire immediately
   */
   public Trigger( int rate, boolean immediately ){
     setRate( rate ); 
     if( immediately ) start -= rate; 
   }
   
  /** 
   * changes the rate at which the trigger fires in milliseconds 
   */
  public void setRate( int rate ){
    this.rate = rate; 
  }
  
  /**
   * returns the rate at which the trigger fires, in milliseconds
   */
  public int getRate(){
    return rate; 
  }
  
  /**
   * returns true if the trigger has fired, false otherwise
   */
  public boolean fires(){
    if( millis() - start >= rate ){
      start += rate; 
      return true; 
    }
    else{
      return false; 
    }
  }
  
  /**
   * resets the timer, 
   * next trigger will occur in _rate_ milliseconds.  
   */
  public void reset(){
    start = millis(); 
  }
}
