public Scalar<R> dotMultiply(Vector2<S> otherMeasure) {
    return new Scalar<R>
        (this.x * otherMeasure.getX()
        +this.y * otherMeasure.getY()
        );
}
