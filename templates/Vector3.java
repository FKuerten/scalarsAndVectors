import lombok.Data;

@Data
public class Vector3<T> {

    private final double x, y, z;

    public Scalar<T> length() {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
    }

    // BEGIN_OPERATIONS

    // END_OPERATIONS

}
