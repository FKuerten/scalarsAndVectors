public Scalar<R> dotMultiply(Vector3<S> otherMeasure) {
    return new Scalar<R>
        (this.x * otherMeasure.getX()
        +this.y * otherMeasure.getY()
        +this.z * otherMeasure.getX()
        );
}
