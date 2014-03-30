package #PACKAGE_JAVA#;

import lombok.*;

@AllArgsConstructor
@Data
public class Scalar<T> implements Comparable<Scalar<T>> {

    private double value;

    public Scalar<T> add(Scalar<T> other) {
        return new Scalar<T>
            (this.value + other.value
            );
    }

    public void addTo(Scalar<T> other) {
        this.value += other.value;
    }

    public Scalar<T> subtract(Scalar<T> other) {
        return new Scalar<T>
            (this.value - other.value
            );
    }

    public void subtractFrom(Scalar<T> other) {
        this.value -= other.value;
    }

    // BEGIN_OPERATIONS

    // END_OPERATIONS

    public int compareTo(Scalar<T> other) {
        if (this.value > other.value) {
            return 1;
        } else if (this.value < other.value) {
            return -1;
        } else {
            return 0;
        }
    }

}
