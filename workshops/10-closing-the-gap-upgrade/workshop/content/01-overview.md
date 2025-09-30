Remeber the SCAR and PAUTR principles!

### Collecting a first baseline

- Compile the application
- Run _all_ the tests
- Start the application

<details>
  <summary>Hints</summary>

Helpful commands include:

`./mvnw compile`  
 `./mvnw test`  
 `./mvnw spring-boot:run`

</details>

### Modifications of dependencies

- Change Spring boot version to 2.7.14
- Remove explicit versions of Spring dependencies
- Remove explicit versions of non-Spring dependencies

<details>
  <summary>Hints</summary>

The Spring Boot version and all explicit dependencies can be found in the pom.xml file

Use `./mvnw dependency:tree` to verify the dependency version management

</details>

### Getting the code to compile

- Fix the compile errors

<details>
  <summary>Hints</summary>

Use the compile logs to find the compilation failure. Remove the deprecated methods.

</details>

### Updating Spring Security

- Update Spring Security version to 5.8.5
- Get the code to compile

<details>
  <summary>Hints</summary>

The Spring Security version needs to be set as a property in the pom.xml file

The SecrityConfig class has many changes that are required to remove the deprecated calls, including:

- Making the class a @Configuration class
- No longer extending the WebSecurityConfigureAdapter
- Replacing the `configure` method with a `SecurityFilterChain` Bean
- Changing the method signature from http.authorizeRequests
- Changing the PasswordEncoder class

</details>

### Getting the tests to run

- update test dependencies
- Run the tests

<details>
  <summary>Hints</summary>

use `./mvnw test` to run the tests and `./mvnw dependency:tree` to validate dependency tracing

</details>

### Deprecated Properties

- add Spring Boot Properties Migrator
- Modify the properties

<details>
  <summary>Hints</summary>

The Spring Boot Properties Migrator is in the pom.xml. Don't forget to remove it after properties have been migrated!

use `./mvnw spring-boot:run` to run the application

</details>

### Runtime validation

- Run the application

<details>
  <summary>Hints</summary>

use `./mvnw spring-boot:run` to run the application

</details>

#### notes

credentials for the application are:  
 sarah1/abc123  
 hank-owns-no-cards/qrs456  
 kumar2/xyz789
