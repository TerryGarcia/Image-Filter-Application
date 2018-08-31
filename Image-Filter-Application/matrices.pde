float[][] determineKernel(String TYPE)
{
  float[][] emboss = {
    {-1, -1, -1, -1, 0}, 
    {-1, -1, -1, 0, 1}, 
    {-1, -1, 0, 1, 1}, 
    {-1, 0, 1, 1, 1}, 
    {0, 1, 1, 1, 1}
  };

  float[][] topSobel = {
    { 1, 2, 1}, 
    { 0, 0, 0}, 
    { -1, -2, -1}
  };

  float[][] bottomSobel = {
    {-1, -2, -1}, 
    {0, 0, 0}, 
    {1, 2, 1}
  };

  float[][] leftSobel = {
    { 1, 0, -1}, 
    { 2, 0, -2}, 
    { 1, 0, -1}
  };

  float[][] rightSobel = {
    { -1, 0, 1}, 
    { -2, 0, 2}, 
    { -1, 0, 1}
  };

  float[][] edgeEnhance = { 
    {0, 0, 0}, 
    {-1, 1, 0}, 
    {0, 0, 0} 
  };

  float[][] edgeDetect = { 
    {0, 1, 0}, 
    {1, -4, 1}, 
    {0, 1, 0} 
  };

  float[][] excessiveEdges = { 
    {1, 1, 1}, 
    {1, -7, 1}, 
    {1, 1, 1} 
  };

  float[][] blur = { 
    {0.0625, 0.125, 0.0625}, 
    {0.125, 0.25, 0.125}, 
    {0.0625, 0.125, 0.0625} 
  };

  float[][] motionBlur =
    {
    {.111, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, .111, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, .111, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, .111, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, .111, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, .111, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, .111, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, .111, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, .111}
  };

  float[][] meanBlur3by3 = {
    {.111, .111, .111}, 
    {.111, .111, .111}, 
    {.111, .111, .111}
  };

  float[][] sharpen = { 
    {-1, -1, -1}, 
    {-1, 9, -1}, 
    {-1, -1, -1} 
  };

  float[][] outlines = { 
    {-1, -1, -1}, 
    {-1, 8, -1}, 
    {-1, -1, -1} 
  };

  switch (TYPE) {
  case "emboss":
    return emboss;
  case "topSobel":
    return topSobel;
  case "bottomSobel":
    return bottomSobel;
  case "leftSobel":
    return leftSobel;
  case "rightSobel":
    return rightSobel;
  case "edgeEnhance":
    return edgeEnhance;
  case "edgeDetect":
    return edgeDetect;
  case "excessiveEdges":
    return excessiveEdges;
  case "sharpen":
    return sharpen;
  case "outlines":
    return outlines;
  case "motionBlur":
    return motionBlur;
  case "meanBlur3by3":
    return meanBlur3by3;
  default:
    return blur;
  }
}