public Vector2<R> multiply(Vector2<S> otherMeasure) {
    return new Vector2<R>
        (this.value * otherMeasure.getX()
        ,this.value * otherMeasure.getY()
        );
}
