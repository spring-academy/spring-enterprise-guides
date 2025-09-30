### Upgrade to Spring Boot 3.1

- Update Spring Boot version to the latest 3.1.x version, e.g. 3.1.9

As before, find the Spring Boot version in the pom:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<version>3.0.13</version>"
```

replace this version:

```editor:replace-text-selection
file: ~/exercises/pom.xml
text: "<version>3.1.9</version>"
```

- Compile and test

```execute
./mvnw clean compile
```

Any deprecation warnings?  We should take care of those!

Let's find our configuration bean:

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: "http.authorizeHttpRequests()"
after: 6
```

And replace it with a lambda for our AuthCustomizer:

```editor:replace-text-selection
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: |
        http
                .authorizeHttpRequests((authCustomizer) -> authCustomizer
                        .requestMatchers(new AntPathRequestMatcher("/cashcards/**")).hasRole("CARD-OWNER")
                        .requestMatchers(new AntPathRequestMatcher("/h2-console/**")).permitAll())
                .csrf(AbstractHttpConfigurer::disable)
                .httpBasic(withDefaults());
        return http.build();
```

Note that we also removed the `and()` as well as adding a parameter to the `csrf()` .

You may need to add an import:

```editor:insert-lines-before-line
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
line: 13
text: |
    import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
```

compile and test the app:

```execute
./mvnw clean compile
```

```execute
./mvnw test
```

- Let's run the app and see if there any properties that need to be migrated:

```execute
./mvnw spring-boot:run
```

Looks like there is!  Let's stop the app and modify this property:

```execute
<ctrl+c>
```

```editor:open-file
file: ~/exercises/src/main/resources/application.yml
line: 1
```

```editor:select-matching-text
file: ~/exercises/src/main/resources/application.yml
text: "cache-max-size-buffering: 100"
```

```editor:replace-text-selection
file: ~/exercises/src/main/resources/application.yml
text: "state-store-cache-max-size: 100"
```

and run again:

```execute
./mvnw spring-boot:run
```

and try some test data:

Can sarah1 access card 99?

```execute-2
http localhost:8080/cashcards/99 --auth sarah1:abc123
```

Can kumar2 see all cards?

```execute-2
http localhost:8080/cashcards --auth kumar2:xyz789
```

Is hank-owns-no-cards prevented form seeing any cards?

```execute-2
http localhost:8080/cashcards --auth hank-owns-no-cards:qrs456
```

Stop the application when satisfied (ctrl-c)

```execute
<ctrl+c>
```

### Notes

If there are errors when making mods to this security config class, the known end state can be found in the /hints folder under lesson6-security.txt
