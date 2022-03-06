import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 5;
private final static int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }   
  setMines();
}
public void setMines()
{
  //your code
  while (mines.size() < (NUM_ROWS)) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
      System.out.println(r+", "+ c);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  int bombs = 0;
  for (int r = 0; r < NUM_ROWS; r++) 
    for (int c = 0; c < NUM_COLS; c++)
      if (mines.contains(buttons[r][c]) && buttons[r][c].flagged == true)
        bombs++;
  if (bombs == NUM_ROWS)
    return true;
  return false;
}
public void displayLosingMessage()
{
  //your code here
  for (int r = 0; r < NUM_ROWS; r++) 
    for (int c = 0; c < NUM_COLS; c++)
      if (buttons[r][c].flagged == false)
        buttons[r][c].clicked = true;
  buttons[NUM_ROWS/2][NUM_COLS/2].myLabel = "You Lose";
  System.out.println("You Lose!");
}
public void displayWinningMessage()
{
  //your code here
  buttons[NUM_ROWS/2][NUM_COLS/2].myLabel = "You Win";
  System.out.println("You Win!");
}
public boolean isValid(int r, int c)
{
  //your code here
  if ((r >= 0 && r < NUM_ROWS) && (c >= 0 && c < NUM_COLS))
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int r = row - 1; r<=row+1; r++)
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c))
        if (mines.contains(buttons[r][c]))
          numMines++;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT) {
      if (flagged == true)
        flagged = false;
      else if (flagged == false)
        flagged = true;
    } else if (mines.contains(this))
      displayLosingMessage();
    else if (countMines(myRow, myCol) > 0)
      setLabel(countMines(myRow, myCol));
    else {
      for (int row = myRow-1; row<=myRow+1; row++)
        for (int col = myCol-1; col<=myCol+1; col++)
          if (isValid(row, col) && buttons[row][col].clicked == false)
            buttons[row][col].mousePressed();
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
