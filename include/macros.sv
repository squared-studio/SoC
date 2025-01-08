`define COMPARE_ARRAYS(arr1, arr2, result) \
  always_comb begin \
    result = 1'b1; /* Assume equal */ \
    foreach (arr1[i]) begin \
      if (arr1[i] != arr2[i]) begin \
        result = 1'b0; /* Not equal */ \
        break; \
      end \
    end \
  end

`define EQUAL_CONT(arr1, arr2) \
  foreach (arr1[i]) begin \
    arr1[i] = arr2[i]; \
  end

`define EQUAL_PROC(arr1, arr2) \
foreach (arr1[i]) begin \
  arr1[i] <= arr2[i]; \
end

`define SET_LOW_CONT(arr) \
foreach (arr[i]) begin \
  arr[i] = '0; \
end

`define SET_LOW_PROC(arr) \
foreach (arr[i]) begin \
  arr[i] <= '0; \
end

// function automatic bit compare_arrays(input * arr1, input * arr2);
//   foreach (arr1[i])
//     if (arr1[i] != arr2[i])
//       return 0;
//   return 1;
// endfunction


