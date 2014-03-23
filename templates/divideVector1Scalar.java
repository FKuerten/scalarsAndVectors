public Vector1<R> divide(Scalar<S> otherMeasure) {
    return new Vector1<R>
        (this.x / otherMeasure.getValue()
        );
}
