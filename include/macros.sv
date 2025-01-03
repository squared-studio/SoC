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

`define EQUAL_CONT(arr1, arr2, size) \
for (int i = 0; i < size; i++) begin \
  arr1[i] = arr2[i]; \
end

`define EQUAL_PROC(arr1, arr2, size) \
for (int i = 0; i < size; i++) begin \
  arr1[i] <= arr2[i]; \
end