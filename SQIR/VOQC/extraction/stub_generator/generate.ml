

let generate dirname =
  let prefix = "money" in
  let path basename = Filename.concat dirname basename in
  let ml_fd = open_out (path "money_bindings.ml") in
  let c_fd = open_out (path "money.c") in
  let h_fd = open_out (path "money.h") in
  let stubs = (module Bindings.Stubs : Cstubs_inverted.BINDINGS) in
  begin
    (* Generate the ML module that links in the generated C. *)
    Cstubs_inverted.write_ml
      (Format.formatter_of_out_channel ml_fd) ~prefix stubs;

    (* Generate the C source file that exports OCaml functions. *)
    Format.fprintf (Format.formatter_of_out_channel c_fd)
      "#include \"money.h\"@\n#include <stddef.h>@\n#include <stdint.h>@\n#include <unistd.h>@\n#include <gmp.h>@\n%a"
      (Cstubs_inverted.write_c ~prefix) stubs;

    (* Generate the C header file that exports OCaml functions. *)
    Format.fprintf (Format.formatter_of_out_channel h_fd)
      "#include <stdint.h>@\n#include <stddef.h>@\n#include <unistd.h>@\n#include <gmp.h>@\n%a"
    (Cstubs_inverted.write_c_header ~prefix) stubs;

  end;
  close_out h_fd;
  close_out c_fd;
  close_out ml_fd

let () = generate (Sys.argv.(1))
