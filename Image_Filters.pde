import javax.swing.JOptionPane; //<>//

PImage original;
ArrayList<PImage> imageStack = new ArrayList<PImage>(10);
PFont font;
String fileLocation, outputName;
int xOffset, yOffset, centerX, centerY, newImageWidth, newImageHeight, canvasSize, 
  delay, currentImageIndex;
float zoom = 1;
int scrollOffset;

MenuSwitch File = new MenuSwitch(0, 0, 30, "File");
MenuButton Open = new MenuButton(0, 20, 45, "Open");
MenuButton Save = new MenuButton(0, 40, 45, "Save");
MenuButton SaveAs = new MenuButton(0, 60, 45, "Save as");
MenuButton Close = new MenuButton(0, 80, 45, "Close");
MenuButton Revert = new MenuButton(0, 100, 45, "Revert");
MenuButton Quit = new MenuButton(0, 120, 45, "Quit");

MenuSwitch Filters = new MenuSwitch(30, 0, 40, "Filters");
MenuButton Invert = new MenuButton(30, 80, 90, "Invert");
MenuButton BlackAndWhite = new MenuButton(30, 100, 90, "Black and White");
MenuButton Grayscale = new MenuButton(30, 120, 90, "Grayscale");
MenuButton Posterize = new MenuButton(30, 140, 90, "Posterize");
MenuButton Pixelate = new MenuButton(30, 160, 90, "Pixelate");
MenuButton Mosaic = new MenuButton(30, 180, 90, "Mosaic");
MenuButton Sepia = new MenuButton(30, 200, 90, "Sepia");
MenuButton ImageMirror = new MenuButton(30, 220, 90, "ImageMirror");

MenuButton Emboss = new MenuButton(120, 20, 80, "Emboss");
MenuButton TopSobel = new MenuButton(120, 40, 80, "Top Sobel");
MenuButton BottomSobel = new MenuButton(120, 60, 80, "Bottom Sobel");
MenuButton LeftSobel = new MenuButton(120, 80, 80, "Left Sobel");
MenuButton RightSobel = new MenuButton(120, 100, 80, "Right Sobel");
SubMenuSwitch Sobels = new SubMenuSwitch(30, 20, 90, "Sobels           >", 
  RightSobel);

MenuButton EdgeEnchance = new MenuButton(120, 40, 125, "Edge Enchance");
MenuButton EdgeDetect = new MenuButton(120, 60, 125, "Edge Detect");
MenuButton ExcessiveEdges = new MenuButton(120, 80, 125, "Excessive Edges");
MenuButton Sharpen = new MenuButton(120, 100, 125, "Sharpen");
MenuButton Outlines = new MenuButton(120, 120, 125, "Outlines");
SubMenuSwitch Edges = new SubMenuSwitch(30, 40, 90, "Edges            >", 
  Outlines);

MenuButton Blur = new MenuButton(120, 60, 90, "Blur");
MenuButton MotionBlur = new MenuButton(120, 80, 90, "Motion Blur");
MenuButton MeanBlur = new MenuButton(120, 100, 90, "Mean Blur");
SubMenuSwitch Blurs = new SubMenuSwitch(30, 60, 90, "Blurs              >", 
  Outlines);

ActionHistoryButton[] AHButton = new ActionHistoryButton[10];

void setup()
{
  if (displayWidth > displayHeight) canvasSize = int(displayWidth / 2.4);
  else canvasSize = int(displayHeight / 2.4);
  surface.setSize(canvasSize, canvasSize);
  frameRate(60);
  font = createFont("Segoe UI", 48);
  textFont(font);
  textSize(12);
  imageMode(CENTER);
  for (int i = 0; i < 10; i++)
  {
    AHButton[i] = new ActionHistoryButton(i);
  }
}

void draw()
{
  background(185);
  if (imageStack.size() >= 1) image(imageStack.get(currentImageIndex), 
    centerX + xOffset, centerY + yOffset, newImageWidth * zoom, newImageHeight * zoom);
  noStroke();
  fill(175);
  rect(newImageWidth, 20, width, height);
  for (int i = 0; i < imageStack.size(); i++)
  {
    AHButton[i].drawItem();
  }
  fill(255);
  rect(0, 0, width, 20);
  File.drawMenuSwitch();
  if (File.active) 
  {
    Open.drawMenuButton();
    Save.drawMenuButton();
    SaveAs.drawMenuButton();
    Close.drawMenuButton();
    Revert.drawMenuButton();
    Quit.drawMenuButton();
  }
  Filters.drawMenuSwitch();
  if (Filters.active)
  {
    Invert.drawMenuButton();
    BlackAndWhite.drawMenuButton();
    Grayscale.drawMenuButton();
    Posterize.drawMenuButton();
    Pixelate.drawMenuButton();
    Mosaic.drawMenuButton();
    Sepia.drawMenuButton();
    ImageMirror.drawMenuButton();
    Sobels.drawSubMenuSwitch();
    if (Sobels.active) 
    {
      Emboss.drawMenuButton();
      TopSobel.drawMenuButton();
      BottomSobel.drawMenuButton();
      LeftSobel.drawMenuButton();
      RightSobel.drawMenuButton();
    }
    Edges.drawSubMenuSwitch();
    if (Edges.active)
    {
      EdgeEnchance.drawMenuButton();
      EdgeDetect.drawMenuButton();
      ExcessiveEdges.drawMenuButton();
      Sharpen.drawMenuButton();
      Outlines.drawMenuButton();
    }
    Blurs.drawSubMenuSwitch();
    if (Blurs.active)
    {
      Blur.drawMenuButton();
      MotionBlur.drawMenuButton();
      MeanBlur.drawMenuButton();
    }
  }
}

void mouseClicked()
{
  if (File.active)
  {
    if (Open.checkIfClicked()) selectInput("Choose a File", "loadFile");
    if (Save.checkIfClicked() && imageStack.size() >= 1) imageStack.get(
      currentImageIndex).save(outputName);
    if (SaveAs.checkIfClicked() && imageStack.size() >= 1) selectOutput(
      "Choose a location", "saveAs");
    if (Close.checkIfClicked()) imageStack.removeAll(imageStack);
    if (Revert.checkIfClicked()) revertToOriginal();
    if (Quit.checkIfClicked()) exit();
  }
  File.checkIfClicked();
  if (Filters.active && imageStack.size() >= 1)
  {
    if (Invert.checkIfClicked()) 
    {
      imageStackCheck();
      invert(imageStack.get(currentImageIndex));
    }
    if (BlackAndWhite.checkIfClicked()) 
    {
      imageStackCheck();
      blackAndWhite(imageStack.get(currentImageIndex));
    }
    if (Grayscale.checkIfClicked()) 
    {
      imageStackCheck();
      grayscale(imageStack.get(currentImageIndex));
    }
    if (Posterize.checkIfClicked()) 
    {
      String level = JOptionPane.showInputDialog("Choose level of posteriza" +
        "tion(Warning, value must be at least 2!): ");
      if (level != null && parseInt(level) >= 2) 
      {
        imageStackCheck();
        posterize(imageStack.get(currentImageIndex), parseInt(level));
      }
    }
    if (Pixelate.checkIfClicked()) 
    {
      String pixelSize = JOptionPane.showInputDialog("Choose pixel size: ");
      if (pixelSize != null && parseInt(pixelSize) > 0) 
      {
        imageStackCheck();
        pixelate(imageStack.get(currentImageIndex), parseInt(pixelSize));
      }
    }
    if (Mosaic.checkIfClicked())
    {
      String gridSize = JOptionPane.showInputDialog("Choose pixel length of grids: ");
      String lineWeight = JOptionPane.showInputDialog("Choose pixel weight of the " + 
        "lines(can be 0): ");
      if (gridSize != null && lineWeight != null && parseInt(gridSize) > 0 &&
        parseInt(lineWeight) >= 0) 
      {
        imageStackCheck();
        mosaic(imageStack.get(currentImageIndex), parseInt(gridSize), parseInt(
          lineWeight));
      }
    }
    if (Sepia.checkIfClicked()) 
    {
      imageStackCheck();
      sepia(imageStack.get(currentImageIndex));
    }
    if (ImageMirror.checkIfClicked()) 
    {
      imageStackCheck();
      imageMirror(imageStack.get(currentImageIndex));
    }
    if (Sobels.active)
    {
      if (Emboss.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("emboss", imageStack.get(currentImageIndex));
      }
      if (TopSobel.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("topSobel", imageStack.get(currentImageIndex));
      }
      if (BottomSobel.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("bottomSobel", imageStack.get(currentImageIndex));
      }
      if (LeftSobel.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("leftSobel", imageStack.get(currentImageIndex));
      }
      if (RightSobel.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("rightSobel", imageStack.get(currentImageIndex));
      }
    }
    if (Edges.active)
    {
      if (EdgeEnchance.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("edgeEnhance", imageStack.get(currentImageIndex));
      }
      if (EdgeDetect.checkIfClicked()) 
      {
        imageStackCheck();
        imageFilter("edgeDetect", imageStack.get(currentImageIndex));
      }
      if (ExcessiveEdges.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("excessiveEdges", imageStack.get(currentImageIndex));
      }
      if (Sharpen.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("sharpen", imageStack.get(currentImageIndex));
      }
      if (Outlines.checkIfClicked())
      {

        imageStackCheck();
        imageFilter("outlines", imageStack.get(currentImageIndex));
      }
    }
    if (Blurs.active)
    {
      if (Blur.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("blur", imageStack.get(currentImageIndex));
      }
      if (MotionBlur.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("motionBlur", imageStack.get(currentImageIndex));
      }
      if (MeanBlur.checkIfClicked())
      {
        imageStackCheck();
        imageFilter("meanBlur3by3", imageStack.get(currentImageIndex));
      }
    }
  }
  for (int i = 0; i < imageStack.size(); i++)
  {
    if (AHButton[i].clicked())
    {
      currentImageIndex = i;
    }
  }
  Filters.checkIfClicked();
}

void loadFile(File selection)
{
  if (selection != null) 
  {
    original = loadImage(selection.getAbsolutePath());
    currentImageIndex = 0;
    imageStack.removeAll(imageStack);
    imageStack.add(loadImage(selection.getAbsolutePath()));
    if (imageStack.get(currentImageIndex).width > 
      imageStack.get(currentImageIndex).height) 
    {
      newImageWidth = canvasSize;
      newImageHeight = round(canvasSize * imageStack.get(currentImageIndex).height /
        imageStack.get(currentImageIndex).width);
      surface.setSize(canvasSize + 200, newImageHeight + 20);
    } else 
    {
      newImageWidth = round(canvasSize * imageStack.get(currentImageIndex).width /
        imageStack.get(currentImageIndex).height);
      newImageHeight = canvasSize;
      surface.setSize(newImageWidth + 200, canvasSize + 20);
    }
    centerX = newImageWidth / 2;
    centerY = (newImageHeight / 2) + 20;
    xOffset = 0;
    yOffset = 0;
    zoom = 1;
    delay = 0;
    outputName = selection.getAbsolutePath();
  }
}

void saveAs(File selection)
{
  String saveName = selection.getAbsolutePath();
  if (saveName != null) imageStack.get(currentImageIndex).save(saveName);
}

void mouseDragged()
{
  mouseClicked();
  if (imageStack.size() >= 1 && delay > 1 && mouseY > 20 && mouseX < newImageWidth)
  {
    xOffset += mouseX - pmouseX;
    yOffset += mouseY - pmouseY;
  } else delay++;
}

void mouseWheel(MouseEvent event)
{
  if (mouseX < width - 200)
  {
    if (event.getCount() == 1) zoom -= 0.1;
    else zoom += 0.1;
    zoom = (zoom < 0.3) ? 0.3 : (zoom > 10) ? 10 : zoom;
    if (zoom < 1)
    {
      xOffset = 0;
      yOffset = 0;
    }
  } else
  {
    if (event.getCount() == 1) scrollOffset -= 50;
    else scrollOffset += 50;
    if (scrollOffset < -850) scrollOffset = -850;
    println(scrollOffset);
  }
}

void imageStackCheck()
{
  if (currentImageIndex < imageStack.size())
  {
    cleanUpArray(currentImageIndex);
  }
  if (currentImageIndex + 1 > 9) 
  {
    imageStack.remove(0);
  } else
  {
    currentImageIndex++;
  }
  imageStack.add(imageStack.get(currentImageIndex - 1).get());
}

void cleanUpArray(int location)
{
  for (int i = imageStack.size() - 1; i > location; i--)
  {
    imageStack.remove(i);
  }
  currentImageIndex = location;
}

void revertToOriginal()
{
  if (imageStack.size() >= 1)
  {
    imageStack.removeAll(imageStack);
    currentImageIndex = 0;
    imageStack.add(original);
  }
}