# Include Directory

Each processor needs to have a header file which contains all the relevant
memory locations for that processor. These are locations that would be found
in the processors memory map.

All files which needs access to memory locations for a processor should
`#include <processor.h>` which will include all of the header files for each
microprocessor in `include/`.

When adding a new processor you should make its file path in the format of
`<architecture>/<cpu>/<processor_name>.h` so for example the realview-pb-a8
processor, which is available to us with qemu-system-arm, would have the full
path of `include/arm/cortex-a8/realview-pb-a8.h` therefore it would appear in
processor.h as `#include <arm/cortex-a8/realview-pb-a8.h>`.

All `<processor_name>.h` files should be wrapped in an `ifdef` of their name.
If you are making the file `<processor_name>.h` everything in it should be
wrapped in and `#ifdef <processor_name>`. For example the realview-pb-a8
looks like this.

```
/* Some header talking about XYZ. */
#ifdef realview-pb-a8

... all the defines and macros

#endif
```
