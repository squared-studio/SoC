`define COMPARE_ARRAYS(arr1, arr2, size, result) \
  begin \
    result = 1'b1; /* Assume equal */ \
    for (int i = 0; i < size; i++) begin \
      if (arr1[i] != arr2[i]) begin \
        result = 1'b0; /* Not equal */ \
        break; \
      end \
    end \
  end