# Prerequisites

1. The SOURCEME in the toplevel folder in the RISCV library must be sourced first.
2. If running any TB which executes bare-metal SW, one MUST have run
   ```make build-tools``` first in the lib/riscv/picorv/core folder,
   and use the default install locations in /opt.
3. Gtkwave must also be installed, and be available in your path, if one is to
   inspect the resulting wavedumps.

Most of the TBs here are merely minor modifications to the original FreeAHB
and PicoRV testbenches, adapted slightly to suit our purpose.

# Making testbenches
Run ```make help``` to see available targets and a description.
