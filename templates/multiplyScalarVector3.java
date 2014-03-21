public ReturnType multiply(OtherType otherMeasure) {
    return new ReturnType
        (this.value * otherMeasure.getX()
        ,this.value * otherMeasure.getY()
        ,this.value * otherMeasure.getZ()
        );
}
