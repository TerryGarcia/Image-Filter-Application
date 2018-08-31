//This is the base for the basic image filter types.
//This method takes 2 parameters, the first one being which filter you wish to apply
//and the second one being the PImage to have the filter be applied on.
//For matrices of the basic filters, please look at the matrices file which also
//contains which filters you can use with this method.
void imageFilter(String TYPE, PImage image)
{
  PImage temp = image.get();   

  float[][] kernel = determineKernel(TYPE);
  int kernelSize = kernel.length;
  int kernelOffset = kernelSize / 2;
  image.loadPixels();
  for (int x = 0; x < image.width; x++)
  {
    for (int y = 0; y < image.height; y++)
    {
      color newColor = applyFilter(x, y, kernel, kernelSize, 
        kernelOffset, temp);
      image.pixels[x + y * image.width] = newColor;
    }
  }
  image.updatePixels();
}

color applyFilter(int x, int y, float matrix[][], int matrixSize, 
  int matrixOffset, PImage image)
{
  float rTotal = 0;
  float gTotal = 0;
  float bTotal = 0;

  for (int i = 0; i < matrixSize; i++)
  {
    for (int j = 0; j < matrixSize; j++)
    {
      int xPos = x + i - matrixOffset;
      int yPos = y + j - matrixOffset;
      if (xPos < 0) xPos = image.width - xPos;
      if (yPos < 0) yPos = image.height - yPos;
      if (xPos >= image.width) xPos = (-1 * image.width) + xPos;
      if (yPos >= image.height) yPos = (-1 * image.height) + yPos;
      int location = xPos + yPos * image.width;
      rTotal += (image.pixels[location] >> 16 & 0xFF) * matrix[i][j];
      gTotal += (image.pixels[location] >> 8 & 0xFF) * matrix[i][j];
      bTotal += (image.pixels[location] & 0xFF) * matrix[i][j];
    }
  }
  return color(rTotal, gTotal, bTotal);
}

void invert(PImage image)
{
  image.loadPixels();
  for (int i = 0; i < image.width * image.height; i++)
  {
    int rVal = image.pixels[i] >> 16 & 0xFF;
    int gVal = image.pixels[i] >> 8 & 0xFF;
    int bVal = image.pixels[i] & 0xFF;     
    image.pixels[i] = color(255 - rVal, 255 - gVal, 255 - bVal);
  }
  image.updatePixels();
}

void blackAndWhite(PImage image)
{
  image.loadPixels();
  for (int i = 0; i < image.pixels.length; i++)
  {
    //Will average the 3 color channels then determine white or black at pixel
    //location depending if closer to white or black.
    int avg = ((image.pixels[i] >> 16 & 0xFF) + (image.pixels[i] >> 8 & 0xFF) +
      (image.pixels[i] & 0xFF)) / 3;
    image.pixels[i] = (avg >= 256 / 2) ? color(255) : color(0);
  }
  image.updatePixels();
}

void grayscale(PImage image)
{
  image.loadPixels();
  for (int i = 0; i < image.pixels.length; i++)
  {
    image.pixels[i] = color(((image.pixels[i] >> 16 & 0xFF) + 
      (image.pixels[i] >> 8 & 0xFF) + (image.pixels[i] & 0xFF)) / 3);
  }
  image.updatePixels();
}

void posterize(PImage image, int value)
{
  image.loadPixels();
  int numberOfAreas = 256 / value;
  int numberOfValues = 255 / (value - 1);
  for (int i = 0; i < image.pixels.length; i++)
  {
    color currCol = image.pixels[i];
    int currRed = currCol >> 16 & 0xFF;
    int currGreen = currCol >> 8 & 0xFF;
    int currBlue = currCol & 0xFF;
    int redArea = numberOfValues *  int(currRed / numberOfAreas);
    int greenArea = numberOfValues *  int(currGreen / numberOfAreas);
    int blueArea = numberOfValues *  int(currBlue / numberOfAreas);
    image.pixels[i] = color(redArea, greenArea, blueArea);
  }
  image.updatePixels();
}

void pixelate(PImage image, int sizeOfPixels)
{
  image.loadPixels();
  for (int x = 0; x < image.width; x += sizeOfPixels)
  {
    for (int y = 0; y < image.height; y += sizeOfPixels)
    {
      int red = 0;
      int green = 0;
      int blue = 0;
      int dist = 0;
      for (int xPos = x; xPos < x + sizeOfPixels && xPos < image.width; xPos++)
      {
        for (int yPos = y; yPos < y + sizeOfPixels && yPos < image.height; yPos++)
        {
          red += image.pixels[xPos + yPos * image.width] >> 16 & 0xFF;
          green += image.pixels[xPos + yPos * image.width] >> 8 & 0xFF;
          blue += image.pixels[xPos + yPos * image.width] & 0xFF;
          dist++;
        }
      }
      red /= dist;
      green /= dist;
      blue /= dist;
      for (int xPos = x; xPos < x + sizeOfPixels && xPos < image.width; xPos++)
      {
        for (int yPos = y; yPos < y + sizeOfPixels && yPos < image.height; yPos++)
        {
          image.pixels[xPos + yPos * image.width] = color(red, green, blue);
        }
      }
    }
  }
  image.updatePixels();
}

void mosaic(PImage image, int sizeOfPixels, int gridLinesSize)
{
  image.loadPixels();
  for (int x = 0; x < image.width; x += sizeOfPixels)
  {
    for (int y = 0; y < image.height; y += sizeOfPixels)
    {
      int red = image.pixels[x + y * image.width] >> 16 & 0xFF;
      int green = image.pixels[x + y * image.width] >> 8 & 0xFF;
      int blue = image.pixels[x + y * image.width] & 0xFF;
      for (int xPos = x; xPos < x + sizeOfPixels && xPos < image.width; xPos++)
      {
        for (int yPos = y; yPos < y + sizeOfPixels && yPos < image.height; yPos++)
        {
          image.pixels[xPos + yPos * image.width] = color(red, green, blue);
        }
      }
    }
  }
  for (int x = 0; x < image.width; x++)
  {
    for (int y = 0; y < image.height; y++)
    {
      if (x % sizeOfPixels == 0)
      {
        int start = x - (gridLinesSize / 2);
        for (int xCol = start; xCol < start + gridLinesSize; xCol++)
        {
          if (0 <= xCol && xCol < image.width) image.pixels[xCol + y * 
            image.width] = color(0);
        }
      }
      if (y % sizeOfPixels == 0)
      {
        int start = y - (gridLinesSize / 2);
        for (int yCol = start; yCol < start + gridLinesSize; yCol++)
        {
          if (0 <= yCol && yCol < image.height) image.pixels[x + yCol * 
            image.width] = color(0);
        }
      }
    }
  }
  image.updatePixels();
}


void sepia(PImage image)
{
  image.loadPixels();
  for (int i = 0; i < image.pixels.length; i++)
  {
    int red = image.pixels[i] >> 16 & 0xFF;
    int green = image.pixels[i] >> 8 & 0xFF;
    int blue = image.pixels[i] & 0xFF;
    int newRed = int((0.393 * red) + (green * .769) + (blue * .189));
    int newGreen = int((0.349 * red) + (green * .686) + (blue * .168));
    int newBlue = int((0.272 * red) + (green * .534) + (blue * .131));
    image.pixels[i] = color(newRed, newGreen, newBlue);
  }
  image.updatePixels();
}

void bucketFill(PImage image, color colorFill, int xPos, int yPos, 
  int xCorner, int yCorner)
{
  image.loadPixels();
  for (int x = xPos; x < xCorner; x++)
  {
    for (int y = yPos; y < yCorner; y++)
    {
      image.pixels[x + y * image.width] = colorFill;
    }
  }
  image.updatePixels();
}

void imageMirror(PImage image)
{
  image.loadPixels();
  for (int y = 0; y < image.height; y++)
  {
    for (int x = 0; x < ceil(image.width / 2); x++)
    {
      int loc = (image.width - 1 - x) + y * image.width;
      image.pixels[loc] = image.pixels[x + y * image.width];
    }
  }
  image.updatePixels();
}

/*
list of sources:
 
 LEARNING PROCESSING 2ND EDITION book
 http://lodev.org/cgtutor/filtering.html
 http://setosa.io/ev/image-kernels/
 Computerphile on youtube.
 http://www.techrepublic.com/blog/how-do-i/how-do-i-convert-images-to-grayscale-and-sepia-tone-using-c/
 http://www.cs.umb.edu/~jreyes/csit114-fall-2007/project4/filters.html
 https://docs.gimp.org/en/plug-in-convmatrix.html
 http://docs.oracle.com/javase/tutorial/uiswing/components/dialog.html
 http://www.pixiv.net/member_illust.php?mode=medium&illust_id=54170208
 */