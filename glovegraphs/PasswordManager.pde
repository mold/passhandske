class PasswordManager {

  float threshold = 0.3;

  public int x = 0; 
  public int y = 0;
  public int width = 400;
  public int height = 200;
  
  public float[][] savedPassword;
  public float[][] inputPassword;
  public float[][] errorVectors;

  PasswordManager () {
    
  }

  float[] normalizeVector (int[] vector) {
    float[] normalized = new float[vector.length];
    float minValue = min(vector);
    float maxValue = max(vector);
    float range = maxValue - minValue;
    for (int i = 0; i < vector.length; i++) {
      normalized[i] = (vector[i] - minValue) / range;
    }
    return normalized;
  }

  float[] cutVector (float[] vector, float threshold) {
    float[] v = new float[vector.length];
    //    
    //    v_start = 1; %in C++ use 0
    //    v_end= length(vector); %in C++ use length(a)-1
    //    
    //    i = v_start;
    //    cont=true;
    //    while (cont)
    //        if (abs(vector(i+1)- vector(i)) < slack)
    //            i = i + 1;
    //        else
    //            cont=false;
    //            v_start = i + 1;
    //        end
    //    
    //    end
    //    
    //    i = v_end;
    //    cont=true;
    //    while (cont)
    //        if (abs(vector(i-1)- vector(i)) < slack)
    //            i = i - 1;
    //        else
    //            cont=false;
    //            v_end = i - 1;
    //        end
    //    
    //    end
    //    
    //    new_vector = vector(v_start:v_end);

    return v;
  }

/*function [error] = compare_vector(v1, v2)

size = length(v1);
error=0;

new_v2 = resize_vector(v2,size);

for i = 1 : size
    error = error + (v1(i)-new_v2(i))^2;
end
   
error=sqrt(error)/size;

end*/

  float[] resizeVector (float[] vector, int targetSize) {
    float[] newVector = new float[targetSize];
    float step = (float) vector.length / targetSize;
    int prevIndex = 0;
    int newIndex = 0;
    float average;
    
    if (vector.length >= targetSize) {
      // compress the vector
      for (int i = 0; i < targetSize; i++) {
        newIndex = ceil(i * step);
        if (newIndex - prevIndex > 0) {
          average = 0;
          for (int j = prevIndex; j <= newIndex; j++) {
            average += vector[j];
          }
          average /= newIndex - prevIndex + 1;
          newVector[i] = average;
        } else {
          newVector[i] = vector[i];
        }
        prevIndex = newIndex + 1;
      }
    } else {
      // expand the vector
      for (int i = 0; i < vector.length; i++) {
        /*newIndex = prevIndex;
        while (newIndex == i) {
          newIndex = ;
        }
        if (newIndex - prevIndex > 0) {
          average = 0;
          
          average /= newIndex - prevIndex + 1;
          newVector[i] = average;
        } else {
          newVector[i] = vector[i];
        }
        prevIndex = newIndex + 1;
      }*/
    }
    
    return newVector;
  }
/*
function [new_vector] = resize_vector(vector, size)

if (length(vector)>size)
    %compress the vector:
    new_index=round(linspace(1,length(vector),size));
    new_vector=zeros(1,size);
    for i = 1 : size
    new_vector(i)=vector(new_index(i));
    end
else
    %expand the vector:
    new_index=round(linspace(1,length(vector),size));
    new_vector=zeros(1,size);
    for i = 1 : size
    new_vector(i)=vector(new_index(i));
    end
end

end
*/

  /**
   * save password
   */
  void savePassword(int[][] sensorData) {
    savedPassword = new float[sensorData.length][sensorData[0].length];
    
    for (int i = 0; i < savedPassword.length; i++) {
      savedPassword[i] = normalizeVector(sensorData[i]);
    }
  }

  /**
   * compare specified password with the saved one
   */
  void verifyPassword(int[][] sensorData) {
    float[][] error = new float[sensorData.length][sensorData[0].length];
    
    for (int i = 0; i < error.length; i++) {
      error[i] = normalizeVector(sensorData[i]);
      
    }
    
    
  }

  /**
   * Draws
   */
  void display() {
  }
}


//a_cut=cut_vector(normalize_vector(a),slack)
//b_cut=cut_vector(normalize_vector(b),slack)
//c_cut=cut_vector(normalize_vector(c),slack)
//d_cut=cut_vector(normalize_vector(d),slack)
//e_cut=cut_vector(normalize_vector(e),slack)
//
//b_resize=resize_vector(b_cut,length(a_cut))
//c_resize=resize_vector(c_cut,length(a_cut))
//d_resize=resize_vector(d_cut,length(a_cut))
//e_resize=resize_vector(e_cut,length(a_cut))
//
//error_b = compare_vector(a_cut, b_cut)
//error_c = compare_vector(a_cut, c_cut)
//error_d = compare_vector(a_cut, d_cut)
//error_e = compare_vector(a_cut, e_cut)
