module map;
class Map(alias f) {
    private real _x;
    enum bool empty = false;

    this(real x) {
        _x = x;
    }

    @property real front() const {
        return _x;
    }

    void popFront() {
        _x = f(_x);
    }

    @property bool isAtFixedPoint() const {
        return _x == f(_x);
    }
}
