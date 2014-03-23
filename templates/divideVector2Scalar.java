public Vector2<R> divide(Scalar<S> otherMeasure) {
    return new Vector2<R>
        (this.x / otherMeasure.getValue()
        ,this.y / otherMeasure.getValue()
        );
}
