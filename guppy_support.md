# Guppy language support

| Data Types                  | Full Support | Partial Support | Unsupported | Caveats                                             |
|-----------------------------|------------|-----------------|--|-----------------------------------------------------|
| Arrays                      |            | ✅               |  | Comptime only                                       |
| Tuples                      |            | ✅               |  | Unpacking with * returns array, so only at comptime |
| Structs                     | ✅           |                 |  | Cannot contain arrays                               |

| Features                            | Support? | Remarks |
|-------------------------------------|----------|---|
| if elif else constructs             | ✅        |   |
| function overloading                | ✅        |   |
| measure_array/discard_array         | ❌        | Use non-comptime arrays internally |
| First class/ Higher order functions | ❌        | |
| Recursive functions                 | ❌        | |

Arrays
  - Only supported within comptime guppy

Tuples
  - Unpacking with * only supported at comptime (creates array)

Structs
  - Cannot contain arrays
