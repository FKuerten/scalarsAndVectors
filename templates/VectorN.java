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

    public Vector#{N}<T> negated() {
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

    public UnitlessVector#{N} normalized() {
        final double length = Math.sqrt
            (this.x*this.x
#if (#{N}>=2): +this.y * this.y
#if (#{N}>=3): +this.z * this.z
            );
        return new UnitlessVector#{N}
            (this.x / length
#if (#{N}>=2): ,this.y / length
#if (#{N}>=3): ,this.z / length
            );
    }

#if (#{N}==1) begin
    public Vector2<T> withDirectionOf(UnitlessVector2 direction) {
        final double dl = Math.sqrt
            (direction.x * direction.x
            +direction.y * direction.y
            );
        return new Vector2<T>
            (this.x * direction.x / dl
            ,this.x * direction.y / dl
            );
    }

    public Vector3<T> withDirectionOf(UnitlessVector3 direction) {
        final double dl = Math.sqrt
            (direction.x * direction.x
            +direction.y * direction.y
            +direction.z * direction.z
            );
        return new Vector3<T>
            (this.x * direction.x / dl
            ,this.x * direction.y / dl
            ,this.x * direction.z / dl
            );
    }
#end


    // BEGIN_OPERATIONS

    // END_OPERATIONS

}
