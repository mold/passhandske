class PasswordManager {
  int[] a = new int[] {
    500, 505, 500, 500, 550, 550, 550, 500, 500, 550, 550, 550, 500, 500, 500
  };
  int[] b = new int[] {
    500, 550, 550, 500, 500, 550, 550, 550, 500
  };
  int[] c = new int[] {
    500, 500, 500, 500, 500, 560, 555, 560, 570, 510, 500, 550, 550, 550, 500
  };
  int[] d = new int[] {
    500, 600, 600, 590, 590, 560, 600, 600, 590, 570, 510, 500, 550, 550, 600, 500
  };
  int[] e = new int[] {
    500, 500, 500, 500, 550, 550, 545, 500, 500, 550, 550, 550, 500, 500, 500
  };

  float threshold = 0.3;

  int x; 
  int y;

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


  /**
   * save password
   */
  void setPassword(float[][] sensorData) {
  }

  /**
   * compare specified password with the saved one
   */
  void verifyPassword(float[][] sensorData) {
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

