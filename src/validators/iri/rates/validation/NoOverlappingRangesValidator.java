package iri.rates.validation;

import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.shapes.ListShape;
import software.amazon.smithy.model.shapes.MemberShape;
import software.amazon.smithy.model.shapes.Shape;
import software.amazon.smithy.model.shapes.StructureShape;
import software.amazon.smithy.model.traits.RequiredTrait;
import software.amazon.smithy.model.validation.AbstractValidator;
import software.amazon.smithy.model.validation.ValidationEvent;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * Validates that any list shape annotated with {@code @noOverlappingRanges} has a member
 * structure that exposes {@code premiumFrom} (required, numeric) and {@code premiumTo}
 * (optional, numeric) fields — the structural prerequisite for overlap detection.
 *
 * <p>Actual runtime overlap detection must be enforced by the server implementation.
 */
public final class NoOverlappingRangesValidator extends AbstractValidator {

    private static final Set<String> NUMERIC_TYPES = Set.of(
            "smithy.api#Byte",
            "smithy.api#Short",
            "smithy.api#Integer",
            "smithy.api#Long",
            "smithy.api#Float",
            "smithy.api#Double",
            "smithy.api#BigInteger",
            "smithy.api#BigDecimal"
    );

    @Override
    public List<ValidationEvent> validate(Model model) {
        List<ValidationEvent> events = new ArrayList<>();

        model.getShapesWithTrait(NoOverlappingRangesTrait.class).forEach(shape -> {
            if (!(shape instanceof ListShape)) {
                return;
            }

            ListShape list = (ListShape) shape;
            Shape memberTarget = model.expectShape(list.getMember().getTarget());

            if (!(memberTarget instanceof StructureShape)) {
                events.add(error(shape,
                        "@noOverlappingRanges may only be applied to a list whose member is a structure."));
                return;
            }

            StructureShape struct = (StructureShape) memberTarget;

            // premiumFrom must be present and numeric
            Optional<MemberShape> fromMember = struct.getMember("premiumFrom");
            if (fromMember.isEmpty()) {
                events.add(error(shape, String.format(
                        "@noOverlappingRanges requires member structure '%s' to have a 'premiumFrom' field.",
                        struct.getId())));
            } else {
                requireNumeric(model, shape, struct, fromMember.get(), "premiumFrom", events);
                requireRequired(shape, struct, fromMember.get(), "premiumFrom", events);
            }

            // premiumTo must be present and numeric (may be optional — that signals no upper bound)
            Optional<MemberShape> toMember = struct.getMember("premiumTo");
            if (toMember.isEmpty()) {
                events.add(error(shape, String.format(
                        "@noOverlappingRanges requires member structure '%s' to have a 'premiumTo' field.",
                        struct.getId())));
            } else {
                requireNumeric(model, shape, struct, toMember.get(), "premiumTo", events);
            }
        });

        return events;
    }

    private void requireNumeric(Model model, Shape annotated, StructureShape struct,
                                MemberShape member, String fieldName,
                                List<ValidationEvent> events) {
        String targetId = member.getTarget().toString();
        if (!NUMERIC_TYPES.contains(targetId)) {
            events.add(error(annotated, String.format(
                    "@noOverlappingRanges: field '%s.%s' must be a numeric type (found %s).",
                    struct.getId().getName(), fieldName, targetId)));
        }
    }

    private void requireRequired(Shape annotated, StructureShape struct,
                                 MemberShape member, String fieldName,
                                 List<ValidationEvent> events) {
        if (!member.hasTrait(RequiredTrait.class)) {
            events.add(warning(annotated, String.format(
                    "@noOverlappingRanges: field '%s.%s' should be @required so range " +
                    "boundaries are always present.",
                    struct.getId().getName(), fieldName)));
        }
    }
}
