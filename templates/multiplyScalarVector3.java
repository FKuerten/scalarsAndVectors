public Vector3<R> multiply(Vector3<S> otherMeasure) {
    return new Vector3<R>
        (this.value * otherMeasure.getX()
        ,this.value * otherMeasure.getY()
        ,this.value * otherMeasure.getZ()
        );
}
