# Guppy language support

| Feature | Full Support | Support with Caveats | Unsupported | Caveats                           |
|---------|------------|----------------------|--|-----------------------------------|
| Arrays  |            | ✅                    |  | Comptime only                     |
| Tuples  |            |  ✅                    |  | Unpacking with * only at comptime |
| Structs | ✅           |                      |  | Cannot contain arrays             |


Arrays
  - Only supported within comptime guppy

Tuples
  - Unpacking with * only supported at comptime (creates array)

Structs
  - Cannot contain arrays
