plugins {
    java
    id("software.amazon.smithy") version "0.10.0"
}

repositories {
    mavenCentral()
}

val smithyVersion = "1.50.0"

sourceSets {
    main {
        java {
            srcDir("validators")
        }
        resources {
            srcDir("resources")
        }
    }
}

dependencies {
    // Smithy core — needed to compile the validator and trait provider
    implementation("software.amazon.smithy:smithy-model:$smithyVersion")
    implementation("software.amazon.smithy:smithy-validation-model:$smithyVersion")

    // Enables @restJson1 and HTTP binding traits
    implementation("software.amazon.smithy:smithy-aws-traits:$smithyVersion")

    // Enables OAS export via smithy-build.json projection
    implementation("software.amazon.smithy:smithy-openapi:$smithyVersion")
    implementation("software.amazon.smithy:smithy-aws-apigateway-openapi:$smithyVersion")
}
