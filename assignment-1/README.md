## Where are structs, mappings, and arrays stored?

### Structs

Structs can be stored in two places depending on how they are declared:

- **Storage**: When declared at the contract level or referenced using `storage`, they are saved permanently on the blockchain.
- **Memory**: When created inside a function using `memory`, they exist only during execution and disappear afterward.

### Arrays

Arrays behave similarly to structs:

- **Storage arrays** persist on-chain and keep their values between transactions.
- **Memory arrays** are temporary and used for calculations or short-term operations inside functions.

### Mappings

Mappings are always stored in **storage**. They are permanent and tied directly to the contract’s state. Solidity does not allow mappings to exist in memory because they rely on a hashing mechanism to determine where values live in storage.

---

## Why don’t you need to specify memory or storage with mappings?

Mappings can only exist in storage by design. Unlike arrays and structs, they do not store data sequentially or as a full copy. Instead, they calculate the storage location of each value using a hash of the key and a base slot.

Because of this:

- Mappings cannot be created in memory.
- Mappings cannot be passed around as temporary copies.
- Solidity automatically treats them as storage references.

So there is no need to write `memory` or `storage` for mappings, they are always storage-based.

---

## How do they behave when executed or called?

### Mappings

Mappings behave like permanent lookup tables:

- Accessing a key returns its value.
- If a key has never been set, Solidity returns a default value (for example, `0` for `uint`).
- Updates to mappings directly modify contract storage.

### Structs

Struct behavior depends on how they are referenced:

- **Storage reference**: Changes persist and update the contract’s state.
- **Memory copy**: Changes are temporary and do not affect stored data.

### Arrays

Arrays can also act as either storage or memory:

- **Storage arrays** keep their values after execution.
- **Memory arrays** are temporary and vanish once the function finishes.

In short:

- Storage = permanent and shared state.
- Memory = temporary working data used during execution.
