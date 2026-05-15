package iri.rates.validation;

import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.SourceLocation;
import software.amazon.smithy.model.traits.AbstractTrait;
import software.amazon.smithy.model.traits.AbstractTraitBuilder;
import software.amazon.smithy.model.traits.TraitService;
import software.amazon.smithy.utils.ToSmithyBuilder;

public final class NoOverlappingRangesTrait extends AbstractTrait
        implements ToSmithyBuilder<NoOverlappingRangesTrait> {

    public static final ShapeId ID = ShapeId.from("iri.rates.traits#noOverlappingRanges");

    public NoOverlappingRangesTrait(SourceLocation sourceLocation) {
        super(ID, sourceLocation);
    }

    @Override
    protected Node createNode() {
        return Node.objectNode();
    }

    @Override
    public Builder toBuilder() {
        return new Builder().sourceLocation(getSourceLocation());
    }

    public static final class Builder
            extends AbstractTraitBuilder<NoOverlappingRangesTrait, Builder> {
        @Override
        public NoOverlappingRangesTrait build() {
            return new NoOverlappingRangesTrait(getSourceLocation());
        }
    }

    public static final class Provider implements TraitService {
        @Override
        public ShapeId getShapeId() {
            return ID;
        }

        @Override
        public NoOverlappingRangesTrait createTrait(ShapeId target, Node value) {
            return new Builder()
                    .sourceLocation(value.getSourceLocation())
                    .build();
        }
    }
}
