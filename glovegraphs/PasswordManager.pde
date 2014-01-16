class PasswordManager {

  final float NOISE_THRESHOLD = 0.01;
  final float ERROR_THRESHOLD = 0.1;
  final float ERROR_THRESHOLD_TILT = 0.2;

  public int x = 0; 
  public int y = 0;
  public int width = 400;
  public int height = 200;

  public float[][] savedPassword;
  public float[][] inputPassword;

  public float[] errors;
  public float error;

  public boolean correct = false;

  PasswordManager () {
  }

  float[] normalizeVector (int[] vector) {
    float[] normalized = new float[vector.length];
    float minValue = min(vector);
    float maxValue = max(vector);
    float range = maxValue - minValue;
    if (range > 0) {
      for (int i = 0; i < vector.length; i++) {
        normalized[i] = (vector[i] - minValue) / range;
      }
    }
    return normalized;
  }

  /**
   * Extracts and returns the specified part of the input vector.
   */
  float[] cutVector (float[] vector, int left, int right) {
    float[] v = new float[right - left + 1];

    for (int i = 0; i < v.length; i++) {
      v[i] = vector[left + i];
    }

    return v;
  }

  /**
   * Returns the left and right indices of the input vector
   * indicating where the end point noise data ends and starts
   * on the vector.
   */
  int[] getNoiseLimits (float[] vector) {
    int left = 0;
    int right = vector.length - 1;

    while (left < right &&
      abs(vector[left+1] - vector[left]) < NOISE_THRESHOLD)
      left++;
    while (left < right &&
      abs(vector[right-1] - vector[right]) < NOISE_THRESHOLD)
      right--;

    return new int[] {
      left, right
    };
  }

  /**
   * Trim the password from end point noise.
   */
  float[][] trimPassword (float[][] password) {
    float[][] matrix;
    int[] limits;
    int left = password[0].length;
    int right = 0;

    // find the limits where the password starts and ends
    for (int i = 0; i < password.length; i++) {
      limits = getNoiseLimits(password[0]);
      if (limits[0] < left)
        left = limits[0];
      if (limits[1] > right)
        right = limits[1];
    }

    // trim all the vectors
    float[][] trimmed = new float[password.length][right - left + 1];
    for (int i = 0; i < trimmed.length; i++) {
      trimmed[i] = cutVector(password[i], left, right);
    }
    return trimmed;
  }

  /**
   * Calculates the squared difference between the vectors v1 and v2.
   */
  float compareVectors (float[] v1, float[] v2) {
    if (v1.length != v2.length)
      return -1;

    float error = 0;
    for (int i = 0; i < v1.length; i++) {
      //error += ((v1[i] == v2[i]) ? 0: pow(v1[i] - v2[i], 2));
      error += ((abs(v1[i] - v2[i]) < 0.2) ? 0: 1);
    }

    return error / v1.length;
  }

  /**
   * Returns a new vector of size targetSize with values
   * from the input vector.
   */
  float[] resizeVector (float[] vector, int targetSize) {
    float[] newVector = new float[targetSize];
    int prevIndex = 0;
    int newIndex = 0;
    float average;
    float step;
    float dy;

    if (vector.length >= targetSize) {
      // compress the vector
      step = (float) vector.length / targetSize;
      for (int i = 0; i < targetSize; i++) {
        newIndex = ceil(i * step);
        if (newIndex - prevIndex > 0) {
          // calculate the average value
          average = 0;
          for (int j = prevIndex; j <= newIndex; j++) {
            average += vector[j];
          }
          average /= newIndex - prevIndex + 1;
          newVector[i] = average;
        } 
        else {
          newVector[i] = vector[i];
        }
        prevIndex = newIndex + 1;
      }
    } 
    else {
      // expand the vector
      step = (float) (vector.length - 1) / targetSize;
      for (int i = 0; i < vector.length - 1; i++) {
        // get the range which should interpolate between index i and i+1
        while (floor (newIndex * step) == i)
          newIndex++;
        newIndex--;
        // interpolate between index i and i+1
        dy = (vector[i+1] - vector[i]) / (newIndex - prevIndex);
        for (int j = prevIndex; j <= newIndex; j++)
          newVector[j] = vector[i] + (j - prevIndex) * dy;
        // update the indices
        prevIndex = newIndex;
        newIndex++;
      }
    }

    return newVector;
  }

  /**
   * save password
   */
  void savePassword(float[][] sensorData) {
    savedPassword = trimPassword(sensorData);
    println(savedPassword);
  }

  /**
   * compare specified password with the saved one
   */
  boolean verifyPassword(float[][] sensorData) {
    errors = new float[savedPassword.length];
    float averageError = 0;

    inputPassword = trimPassword(sensorData);

    for (int i = 0; i < errors.length; i++) {
      inputPassword[i] = resizeVector(inputPassword[i], savedPassword[i].length);
      errors[i] = compareVectors(savedPassword[i], inputPassword[i]);
      averageError += errors[i];
    }
    averageError /= errors.length;

    println("Error: "+averageError);
    println(errors);

    if (inputPassword.length != savedPassword.length) {
      println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    }

    error = averageError;

    correct=true;
    for (int i = 0; i < errors.length-1; i++) {
      // check errors for all except tilt
      if (errors[i] > ERROR_THRESHOLD)
        correct=false;
    }
    // special pleading for tilt sensor
    if (errors[errors.length-1] > ERROR_THRESHOLD_TILT)
      correct = false;

    //correct = averageError < ERROR_THRESHOLD;

    return correct;
  }

  /*void matchVectorExtremes (float[] v1, float[] v2) {
   float min1 = min(v1);
   float max1 = max(v1);
   float min2 = min(v2);
   float max2 = max(v2);
   float min = (min1 < min2)? min1 : min2;
   float max = (max1 > max2)? max1 : max2;
   float range = max - min;
   
   for (int i = 0; i < v1.length; i++) {
   v1[i] = vector[i] - min1
   }
   }*/

  /**
   * Draws
   */
  void display() {
    ErrorContainer errorC = new ErrorContainer(
    10, // x position
    40, // y position
    700, // width of graph container (pixels)
    savedPassword, // saved password
    inputPassword, // input password
    errors // errors for each sensor
    );
    errorC.display();
  }
}

