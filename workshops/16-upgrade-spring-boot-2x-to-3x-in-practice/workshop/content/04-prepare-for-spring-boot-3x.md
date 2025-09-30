### Prepare for Spring Boot 3.0

- Update Spring Security version to the latest 5.8.x version, e.g. 5.8.9

We did talk about letting Spring Boot manage dependency versions, but in some cases, especially when preparing for upcoming changes, its acceptable to use a _more recent_ version of a dependency.  With Spring, this can be managed with properties.

We're going to upgrade the version of the security libraries to get ready for the Spring Boot upgrades.  First, we find the properties section in our pom:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<itextpdf.version>5.5.13.3</itextpdf.version>"
```

And add a spring-security.version property:

```editor:append-lines-after-match
file: ~/exercises/pom.xml
match: "<itextpdf.version>5.5.13.3</itextpdf.version>"
text: "<spring-security.version>5.8.9</spring-security.version>"
```

- Update the deprecated code in `SecurityConfig`

The SecurityConfig class is how we secure our application.  Now that we are using a more recent version of the security libraries, we need to remove deprecated signatures in this class.  We will do this in several steps.

Let's open the file:

```editor:open-file
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
line: 1
```

First, find the class level annotations:

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: "@EnableWebSecurity"
```

And make it a configuration class so that all beans are loaded into the Spring context:

```editor:append-lines-after-match
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
match: "@EnableWebSecurity"
text: "@Configuration"
```

You may need to add this import (CMD-. on a Mac)

Next, we no longer need to extend the WebSecurityConfigurerAdapter class:

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: "extends WebSecurityConfigurerAdapter"
```

remove this extension:

```editor:replace-text-selection
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: ""
```

Next, the configure() method needs to return a SecurityFilterChain Bean:

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: "protected void configure(HttpSecurity http) throws Exception"
before: 1
```

replace this text:

```editor:replace-text-selection
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: |
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception
```

This current configuration is written in lambda style, we'll use the builder pattern more explicitly.  Along the way, we'll use requestMatchers and clean up the return signature:

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: "authorizeRequests((authz) ->"
before: 1
after: 6
```

replacing it with:

```editor:replace-text-selection
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: |
        http.authorizeHttpRequests()
                .requestMatchers(new AntPathRequestMatcher("/cashcards/**")).hasRole("CARD-OWNER")
                .requestMatchers(new AntPathRequestMatcher("/h2-console/**")).permitAll()
                .and()
                .csrf().disable()
                .httpBasic(withDefaults());
        return http.build();
```

Lastly, we need to replace the PasswordEncoder:

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: "return new Pbkdf2PasswordEncoder();"
```

replace it with a static factory method:

```editor:replace-text-selection
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: return Pbkdf2PasswordEncoder.defaultsForSpringSecurity_v5_8();
```

Note that you may have some import cleanups.  Let's take care of these.  First, find the old WebSecurityConfigurerAdapter:

```editor:select-matching-text
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: "WebSecurityConfigurerAdapter"
before: 0
after: 0
```

and remove it:

```editor:replace-text-selection
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
text: ""
```
next, add the imports for the new classes:

```editor:insert-lines-before-line
file: ~/exercises/src/main/java/example/cashcard/SecurityConfig.java
line: 13
text: |
    import org.springframework.security.web.SecurityFilterChain;
    import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
    import org.springframework.context.annotation.Configuration;
```

lastly, lets compile and test to validate no breaking changes:

- Compile the application

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


### Notes

If there are errors when making mods to this security config class, the known end state can be found in the /hints folder under lesson4-security.txt

