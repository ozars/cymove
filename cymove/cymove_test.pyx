# cython: language_level=3

from libcpp.string cimport string
from libcpp.memory cimport unique_ptr, nullptr
from cymove cimport cymove as move

cdef extern from *:
    """
    #include <string>

    struct Test {
        int value;
        Test() = default;
        Test(int value) : value(value) {}
        Test(const Test& copy) : value(copy.value) {}
        Test(Test&& copy) : value(copy.value) { copy.value = 0; }
        Test& operator=(const Test& copy) { value = copy.value; return *this; }
        Test& operator=(Test&& copy) { value = copy.value; copy.value = 0; return *this; }
    };

    std::string f(Test& t) { return std::to_string(t.value) + " from f(Test&)"; }
    std::string f(Test&& t) { return std::to_string(t.value) + " from f(Test&&)"; }

    template <typename T, typename... Args>
    std::unique_ptr<T> make_unique(Args&&... args) {
        return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
    }
    """
    cdef cppclass Test:
        int value
        Test()
        Test(int value)
        Test(Test)
        Test operator=(Test)

    string f(Test)
    unique_ptr[T] make_unique[T](...)

import unittest

class TestMove(unittest.TestCase):
    def test_move_assignment(self):
        cdef Test t1, t2

        t1 = Test(1337)
        self.assertEqual(t1.value, 1337)

        t2 = t1
        self.assertEqual(t2.value, 1337)
        self.assertEqual(t1.value, 1337)

        t2 = move(t1)
        self.assertEqual(t2.value, 1337)
        self.assertEqual(t1.value, 0)

    def test_move_func_call(self):
        cdef Test t = Test(1338)
        self.assertEqual(1338, t.value)
        self.assertEqual(b"1338 from f(Test&)", f(t))
        self.assertEqual(b"1338 from f(Test&&)", f(move(t)))

    def test_unique_ptr(self):
        cdef unique_ptr[int] ptr1, ptr2
        cdef int* raw_ptr

        ptr1 = make_unique[int](42)
        raw_ptr = ptr1.get()
        ptr2 = move(ptr1)

        self.assertTrue(ptr2.get() == raw_ptr)
        self.assertTrue(ptr1 == nullptr)
