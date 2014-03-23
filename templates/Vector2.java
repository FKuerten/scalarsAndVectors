package #PACKAGE_JAVA#;

import lombok.Data;

@Data
public class Vector2<T> {

    private final double x, y;

    public Vector1<T> length() {
        return new Vector1<T>(Math.sqrt(this.x * this.x + this.y * this.y));
    }

    // BEGIN_OPERATIONS

    // END_OPERATIONS

}
