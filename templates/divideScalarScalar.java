public Scalar<R> divide(Scalar<S> otherMeasure) {
    return new Scalar<R>(this.value / otherMeasure.getValue());
}
