### Upgrade to Spring Boot 3.2

- Update Spring Boot version to the latest 3.2.x version, e.g. 3.2.3

As before, find the Spring Boot version in the pom:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<version>3.1.9</version>"
```

replace this version:

```editor:replace-text-selection
file: ~/exercises/pom.xml
text: "<version>3.2.3</version>"
```

- Compile and test

```execute
./mvnw clean compile
```

```execute
./mvnw test
```

Any deprecation warnings?  Any properties that need to be migrated?  Should we remove the property migrator dependency?


Some Observations:

- There are no major changes that affect THIS application code
- You could explore using Java 21
- You could explore using Java Virtual Threads


