package #PACKAGE_JAVA#;

import lombok.*;

@AllArgsConstructor
@Data
public class Vector#{N}<T> {

    // Members
    double x;
#if (#{N}>=2):double y;
#if (#{N}>=3):double z;

    // assign operations
#include target/assign.java


    public Vector#{N}<T> add(Vector#{N}<T> other) {
        return new Vector#{N}<T>
            (this.x + other.x
#if (#{N}>=2):   ,this.y + other.y
#if (#{N}>=3):   ,this.z + other.z
        );
    }

    public void addTo(Vector#{N}<T> other) {
        this.x += other.x;
#if (#{N}>=2): this.y += other.y;
#if (#{N}>=3): this.z += other.z;
    }

    public Vector#{N}<T> subtract(Vector#{N}<T> other) {
        return new Vector#{N}<T>
            (this.x - other.x
#if (#{N}>=2):   ,this.y - other.y
#if (#{N}>=3):   ,this.z - other.z
        );
    }

    public void subtractFrom(Vector#{N}<T> other) {
        this.x -= other.x;
#if (#{N}>=2): this.y -= other.y;
#if (#{N}>=3): this.z -= other.z;
    }

    public Vector#{N}<T> multiply(double value) {
        return new Vector#{N}<T>
            (this.x * value
#if (#{N}>=2):   ,this.y * value
#if (#{N}>=3):   ,this.z * value
        );
    }

    public Vector#{N}<T> divide(double value) {
        return new Vector#{N}<T>
            (this.x / value
#if (#{N}>=2):   ,this.y / value
#if (#{N}>=3):   ,this.z / value
        );
    }

    public Vector#{N}<T> negate() {
        return new Vector#{N}<T>
            (-this.x
#if (#{N}>=2):   ,-this.y
#if (#{N}>=3):   ,-this.z
        );
    }

#if (#{N}>=2) begin
    public Vector1<T> length() {
        return new Vector1<T>
            (Math.sqrt
                (this.x * this.x
                +this.y * this.y
#if (#{N}>=3):  +this.z * this.z
                )
            );
    }
#end


    // BEGIN_OPERATIONS

    // END_OPERATIONS

}
