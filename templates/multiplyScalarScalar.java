public Scalar<R> multiply(Scalar<S> otherMeasure) {
    return new Scalar<R>(this.value * otherMeasure.getValue());
}
