### Establishing a new baseline

- Remove explicit versions of Spring dependencies

```execute
./mvnw dependency:tree | grep jdbc
```

We should see that we're pulling in version 2.4.14.  We want Spring Boot to manage this, so let's remove the explicit version from our pom to see if Spring Boot is currently trying to do this for us.  First, let's open the pom:

```editor:open-file
file: ~/exercises/pom.xml
```

and find the spring-data-jdbc version

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<version>2.4.14</version>"
```

remove this explicit version so we can see if Spring Boot is managing this for us:

```editor:replace-text-selection
file: ~/exercises/pom.xml
text: ""
```


and now do a dependency tree:

```execute
./mvnw dependency:tree | grep jdbc
```

and we can see that Spring Boot is pulling in a more recent version of this library.



- Remove explicit versions of non-Spring dependencies

Lets do the same thing, only for non-Spring libraries, in this case lombok.  We start with a dependency tree:

```execute
./mvnw dependency:tree | grep lombok
```

And we see we're pulling in version 1.18.22.  Is Spring already managing this for us?  Let's remove it and find out.

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<version>1.18.22</version>"
```

and remove it:

```editor:replace-text-selection
file: ~/exercises/pom.xml
text: ""
```

and see what our dependency tree tells us:

```execute
./mvnw dependency:tree | grep lombok
```

We can see that Spring Boot is now managing this version as well.

- Lastly, we want all good hygeine in our pom, which includes paramterizing our versions.  Let's find a third party library:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<version>5.5.13.3</version>"
```

And we want to replace that with a property:

```editor:replace-text-selection
file: ~/exercises/pom.xml
text: "<version>${itextpdf.version}</version>"
```

Of course we need to add this property to our pom.  Let's find the properties section:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<java.version>17</java.version>"
```

and add this property:

```editor:append-lines-after-match
file: ~/exercises/pom.xml
match: "<java.version>17</java.version>"
text: "<itextpdf.version>5.5.13.3</itextpdf.version>"
```

lastly, lets compile and test to validate no breaking changes:

- Compile the application

```execute
./mvnw compile
```

hrm, that was fast.  We need to force a clean compile here to get rid of all cached versions:

```execute
./mvnw clean compile
```

- Run the tests

```execute
./mvnw test
```

- Start the application

```execute
./mvnw spring-boot:run
```

- Test with sample data

Can sarah1 access card 99?

```execute-2
http localhost:8080/cashcards/99 --auth sarah1:abc123
```

Stop the application when satisfied (ctrl-c)

```execute
<ctrl+c>
```
