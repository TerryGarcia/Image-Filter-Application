class MenuGui
{
  int xPos, yPos, xLength, yLength;
  int fill = #FFFFFF; 
  int activeFill = #CCE8FF; 
  int mouseFill = #E5F3FF;
  int strokeFill = #99D1FF;
  String text;
  MenuGui(int x, int y, int xWidth, String txt)
  {
    xPos = x;
    yPos = y;
    text = txt;
    xLength = xWidth;
    yLength = 20;
  }
  boolean checkOnObj()
  {
    return (xPos <= mouseX && mouseX <= xPos + xLength && yPos <= mouseY &&
      mouseY <= yPos + yLength);
  }
}

class MenuSwitch extends MenuGui
{
  boolean active = false;
  MenuSwitch(int x, int y, int xWidth, String txt)
  {
    super(x, y, xWidth, txt);
  }

  void drawMenuSwitch()
  {
    if (active) fill(activeFill);
    else if (super.checkOnObj()) fill(mouseFill);
    else fill(255);
    if (active || super.checkOnObj()) stroke(strokeFill);
    else noStroke();
    rect(xPos, yPos, xLength, yLength);
    if (focused) fill(0);
    else fill(#999999);
    textAlign(LEFT, TOP);
    text(text, xPos + 5, yPos + 2);
  }

  void checkIfClicked()
  {
    if (!active) active = super.checkOnObj();
    else active = false;
  }
}

class MenuButton extends MenuGui
{
  MenuButton(int x, int y, int xWidth, String txt)
  {
    super(x, y, xWidth, txt);
  }
  void drawMenuButton()
  {
    if (super.checkOnObj()) fill(mouseFill);
    else fill(#F2F2F2);
    if (super.checkOnObj()) stroke(strokeFill);
    else noStroke();
    rect(xPos, yPos, xLength, yLength);
    if (focused) fill(0);
    else fill(#999999);
    textAlign(LEFT, TOP);
    text(text, xPos + 2, yPos + 2);
  }

  boolean checkIfClicked()
  {
    return super.checkOnObj();
  }
}

class SubMenuSwitch extends MenuGui
{
  boolean active = false;
  int xCorner, yCorner, xOCorner, yOCorner;
  SubMenuSwitch(int x, int y, int xWidth, String txt, MenuButton lastButton)
  {
    super(x, y, xWidth, txt);
    xCorner = xPos + xWidth;
    yCorner = yPos;
    xOCorner = lastButton.xPos + lastButton.xLength;
    yOCorner = lastButton.yPos + lastButton.yLength;
  }

  void drawSubMenuSwitch()
  {
    check();
    if (active) fill(mouseFill);
    else fill(#F2F2F2);
    if (active) stroke(strokeFill);
    else noStroke();
    rect(xPos, yPos, xLength, yLength);
    if (focused) fill(0);
    else fill(#999999);
    textAlign(LEFT, TOP);
    text(text, xPos + 2, yPos + 2);
  }
  void check()
  {
    active = (super.checkOnObj() || (active && checkIfOnSub())) ? true : false;
  }
  boolean checkIfOnSub()
  {
    return (xCorner < mouseX && mouseX < xOCorner && yCorner < 
      mouseY && mouseY < yOCorner);
  }
}

class ActionHistoryButton
{
  int xPos, yPos, size, centerX, centerY, index, temp;

  ActionHistoryButton(int i)
  {
    index = i;
    size = 110;
    xPos = width - 155;
    yPos = size * i + 10 * i + 30;
    centerX = (size / 2) + xPos;
    centerY = (size / 2) + yPos;
  }
  boolean clicked()
  {
    return (xPos < mouseX && mouseX < xPos + size && yPos + scrollOffset < mouseY && 
      mouseY < yPos + size + scrollOffset);
  }
  void drawItem()
  {
    PImage image = imageStack.get(index);
    setupVariables();
    if (index == currentImageIndex) fill(#ADD8E6);
    else fill(#FFFF00);
    rect(xPos, yPos + scrollOffset, size, size, 10);
    if (image.width > image.height) image(image, centerX, centerY + scrollOffset, 
      size, size * image.height / image.width);
    else image(image, centerX, centerY + scrollOffset, size * image.width / 
      image.height, size);
  }
  void setupVariables()
  {
    xPos = width - 155;
    centerX = (size / 2) + xPos;
  }
}