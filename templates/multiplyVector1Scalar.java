public Vector1<R> multiply(Scalar<S> otherMeasure) {
    return new Vector1<R>
        (this.x * otherMeasure.getValue()
        );
}
