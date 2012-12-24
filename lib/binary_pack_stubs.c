#include <stdio.h>
#include <string.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>

#include <caml/fail.h>
#include <caml/callback.h>

int ml_calc_offset(value endian,int len, int pos) {
  if (Int_val(len) < pos || Int_val(pos) < 0) {
    caml_raise_with_string(*caml_named_value("Binary_pack_invalid_offset"),
                           "can not calculate a offset of byte");
  } else {
    switch (Int_val(endian)) {
      case 0:                           /* little endian */
        return len - Int_val(pos) - 1;
      case 1:
        return Int_val(pos);
      default:
        caml_failwith("can not recognize endianness");
    }
  }
}

CAMLprim value unpack_float_c_layout(value endian, value buffer,
                                     value pos) {
  CAMLparam3(endian, buffer, pos);
  float v = 0.0f;

  int len = caml_string_length(buffer);
  if (len >= Int_val(pos) + 3) {
    caml_failwith("buffer size not enough");
  }

  unsigned char converted_buffer[4];

  const char* buf = String_val(buffer);
  converted_buffer[0] = buf[pos + ml_calc_offset(endian, 4, 0)];
  converted_buffer[1] = buf[pos + ml_calc_offset(endian, 4, 1)];
  converted_buffer[2] = buf[pos + ml_calc_offset(endian, 4, 2)];
  converted_buffer[3] = buf[pos + ml_calc_offset(endian, 4, 3)];
  memcpy(&v, converted_buffer, sizeof(float));

  CAMLreturn(caml_copy_double(v));
}

CAMLprim value pack_float_c_layout(value endian, value buffer,
                                   value pos, value f) {
  CAMLparam4(endian, buffer, pos, f);
  float v = Double_val(f);
  unsigned char buf[4];
  memcpy(buf, &v, sizeof(float));
  Store_field(buffer, pos + ml_calc_offset(endian, 4, 0), Val_int(buf[0]));
  Store_field(buffer, pos + ml_calc_offset(endian, 4, 1), Val_int(buf[1]));
  Store_field(buffer, pos + ml_calc_offset(endian, 4, 2), Val_int(buf[2]));
  Store_field(buffer, pos + ml_calc_offset(endian, 4, 3), Val_int(buf[3]));

  CAMLreturn(Val_unit);
}
