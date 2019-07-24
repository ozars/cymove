# distutils: language = c++

cdef extern from * namespace "cymove":
    """
    #include <type_traits>
    #include <utility>

    namespace cymove {

    template <typename T>
    inline typename std::remove_reference<T>::type&& cymove(T& t) {
        return std::move(t);
    }

    template <typename T>
    inline typename std::remove_reference<T>::type&& cymove(T&& t) {
        return std::move(t);
    }

    }  // namespace cymove
    """
    cdef T cymove[T](T)
