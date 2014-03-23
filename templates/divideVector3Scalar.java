public Vector3<R> divide(Scalar<S> otherMeasure) {
    return new Vector3<R>
        (this.x / otherMeasure.getValue()
        ,this.y / otherMeasure.getValue()
        ,this.z / otherMeasure.getValue()
        );
}
