### Upgrade to Spring Boot 3.0

- Update Spring Boot version to the latest 3.0.x version, e.g. 3.0.13

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<version>2.7.18</version>"
```

replace this version:

```editor:replace-text-selection
file: ~/exercises/pom.xml
text: "<version>3.0.13</version>"
```


- Compile and test

```execute
./mvnw clean compile
```

```execute
./mvnw test
```

- Why is it failing?
  - What's using `javax.servlet.Filter`

The only thing that might be interested in the servlet filter chain is security.  Are we explicitly calling out a version of Spring Security that we shouldn't?

Let's validate what version of Spring Security we're using:

```execute
./mvnw dependency:tree | grep security
```

is it the one we're calling out with a property?

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<spring-security.version>5.8.9</spring-security.version>"
```

Let's remove this and find out:

```editor:replace-text-selection
file: ~/exercises/pom.xml
text: ""
```

what does a dependency tree tell us?

```execute
./mvnw dependency:tree | grep security
```

We're now on version 6 of Spring Security.  Let's compile and test again:

```execute
./mvnw clean compile
```

Did the compilation fail?  If so, check your imports on the SecurityConfig class and remove any old ones.

```execute
./mvnw test
```

- Add Spring Boot Migrator to help with deprecated application properties

Sometimes property names will change as Spring does major version upgrades.  There is a utility that will help us out with this.  Simply add the following dependency to the pom file


```editor:insert-lines-before-line
file: ~/exercises/pom.xml
line: 50
text: "<dependency>
  <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-properties-migrator</artifactId>
    <scope>runtime</scope>
</dependency>"
```


and run the application.  

```execute
./mvnw spring-boot:run
```

Do any properties need to be modified?


Let's stop the app before moving on.

```execute
<ctrl+c>
```