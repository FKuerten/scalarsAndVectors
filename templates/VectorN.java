package #PACKAGE_JAVA#;

import lombok.*;

@AllArgsConstructor
@Data
public class Vector#{N}<T> {

    // Members
    private double x;
#if (#{N}>=2):private double y;
#if (#{N}>=3):private double z;

    // Set/get operations
    public void assignXToX(Vector1<T> v) {
        this.x = v.x;
    }

    public void assignXToX(Vector2<T> v) {
        this.x = v.x;
    }

    public void assignYToX(Vector2<T> v) {
        this.x = v.y;
    }

    public void assignYToX(Vector3<T> v) {
        this.x = v.y;
    }

    public void assignZToX(Vector3<T> v) {
        this.x = v.z;
    }

#if (#{N}>=2) begin
    public void assignXToY(Vector1<T> v) {
        this.y = v.x;
    }

    public void assignXToY(Vector2<T> v) {
        this.y = v.x;
    }

    public void assignYToY(Vector2<T> v) {
        this.y = v.y;
    }

    public void assignYToY(Vector3<T> v) {
        this.y = v.y;
    }

    public void assignZToY(Vector3<T> v) {
        this.y = v.z;
    }
#end

#if (#{N}>=3) begin
    public void assignXToZ(Vector1<T> v) {
        this.z = v.x;
    }

    public void assignXToZ(Vector2<T> v) {
        this.z = v.x;
    }

    public void assignYToZ(Vector2<T> v) {
        this.z = v.y;
    }

    public void assignYToZ(Vector3<T> v) {
        this.z = v.y;
    }

    public void assignZToZ(Vector3<T> v) {
        this.z = v.z;
    }
#end

#if (#{N}>=2) begin
    public void assignXYToXY(Vector2<T> v) {
        this.x = v.x;
        this.y = v.y;
    }

    public void assignYXToXY(Vector2<T> v) {
        this.x = v.y;
        this.y = v.x;
    }

    public void assignXYToXY(Vector3<T> v) {
        this.x = v.x;
        this.y = v.y;
    }
    
    public void assignXZToXY(Vector3<T> v) {
        this.x = v.x;
        this.y = v.z;
    }

    public void assignYZToXY(Vector3<T> v) {
        this.x = v.y;
        this.y = v.z;
    }

    public void assignYXToXY(Vector3<T> v) {
        this.x = v.y;
        this.y = v.x;
    }

    public void assignZXToXY(Vector3<T> v) {
        this.x = v.z;
        this.y = v.y;
    }
    
    public void assignZYToXY(Vector3<T> v) {
        this.x = v.z;
        this.y = v.y;
    }
#end
    

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
