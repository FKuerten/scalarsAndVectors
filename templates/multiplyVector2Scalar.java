public Vector2<R> multiply(Scalar<S> otherMeasure) {
    return new Vector2<R>
        (this.x * otherMeasure.getValue()
        ,this.y * otherMeasure.getValue()
        );
}
