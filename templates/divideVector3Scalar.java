public ReturnType divide(OtherType otherMeasure) {
    return new ReturnType
        (this.x / otherMeasure.getValue()
        ,this.y / otherMeasure.getValue()
        ,this.z / otherMeasure.getValue()
        );
}
