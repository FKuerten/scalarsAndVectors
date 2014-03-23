public Vector3<R> multiply(Scalar<S> otherMeasure) {
    return new Vector3<R>
        (this.x * otherMeasure.getValue()
        ,this.y * otherMeasure.getValue()
        ,this.z * otherMeasure.getValue()
        );
}
