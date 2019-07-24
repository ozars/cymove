# cymove
[![Build Status](https://travis-ci.org/ozars/cymove.svg?branch=master)](https://travis-ci.org/ozars/cymove) [![Build status](https://ci.appveyor.com/api/projects/status/j604r7xh12vp0hiu/branch/master?svg=true)](https://ci.appveyor.com/project/ozars/cymove/branch/master)

cymove is a header (pxd) only wrapper around C++11 `std::move` function. It
allows using move semantics from cython code.

## Installation

```
pip install cymove
```

## Example Usage

example.pyx:
```cython
# distutils: language = c++

from libcpp.memory cimport make_shared, shared_ptr, nullptr
from cymove cimport cymove as move

cdef shared_ptr[int] ptr1, ptr2
cdef int* raw_ptr

ptr1 = make_shared[int](5)
raw_ptr = ptr1.get()
ptr2 = move(ptr1)

assert ptr2.get() == raw_ptr
assert ptr1 == nullptr

print("OK!")
```

Compile & run:

```console
$ cythonize -3 -i example.pyx
$ python3 -c "import example"
OK!
```
