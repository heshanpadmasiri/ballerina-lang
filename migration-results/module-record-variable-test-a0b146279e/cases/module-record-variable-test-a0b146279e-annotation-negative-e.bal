// deprecated annotation is not allowed on a module-level binding pattern
# # Deprecated
# This record is deprecated.
@deprecated // @error
record {int a;} {a: myA} = {a: 5};
