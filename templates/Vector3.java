package #PACKAGE_JAVA#;

import lombok.Data;

@Data
public class Vector3<T> {

    private final double x, y, z;

    public Vector1<T> length() {
        return new Vector1<T>(Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z));
    }

    // BEGIN_OPERATIONS

    // END_OPERATIONS

}
