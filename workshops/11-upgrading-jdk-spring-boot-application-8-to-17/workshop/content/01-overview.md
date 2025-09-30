### Discussion of Changes

In order to upgrade a Spring Boot application to Spring boot 3.0, JDK 17 is the minimum version of JDK used. Therefore, legacy applications on the Spring Boot upgrade path will often also have to upgrade the supporting JDK to a minimum version of 17.

Most of the significant deprecations between these JDK versions are related to features that are rarely found in Spring Boot applications (such as applets and swing). Other major deprecations are related to Java Enterprise Edition (JEE) features that made little sense in the Java Standard Edition baseline. These are mostly concerning XML processing and Web Services.

There are also many run-time deprecations and removals, many of which are around JVM start tags concerning Garbage Collection algorithms and logging. These are rarely used in a Spring Boot context but are important to check before going to production.

The entire list of deprecations between 8 and 17 can be found [here](https://docs.oracle.com/en/java/javase/20/migrate/removed-tools-and-components.html).

Before beginning an upgrade, become familiar with all of these changes and deprecations, and assess them against the application portfolio. By being aware of where potential changes lie, the process of upgrades will proceed at a faster, more efficient pace.

### Setting Up Our Shell

Before we can begin our process, we need to have a shell that allows for easy switching between JDK 8 and JDK 17. For this, we want to use the [recommended installation method](https://docs.spring.io/spring-boot/docs/current/reference/html/native-image.html#native-image.developing-your-first-application.native-build-tools.prerequisites) for Linux and MacOS: Using [SDKMAN!](https://sdkman.io)

The installation is simple and quick! Open up the Terminal tab and run the following command:

```dashboard:open-dashboard
name: Terminal
```

```shell
[~/exercises] $ curl -s "https://get.sdkman.io" | bash
```

Because of the way Linux shells work, in order for the installed `sdk` executable to be visible, you'll need to alter the shell environment to make it visible, or create a new shell. We'll follow the instructions from [SDKMAN!](https://sdkman.io/) to alter the shell environment:

```shell
[~/exercises] source "/home/eduk8s/.sdkman/bin/sdkman-init.sh"
```

Now we'll use SDKMAN! to install our JDK distributions. Since those are Java distributions, we'll ask SDKMAN! what choices it has in the `java` application:
There are many, but we recommend the Temurin versions:

```shell
[~/exercises] $ sdk list java | grep tem
 Temurin       |     | 20.0.2       | tem     |            | 20.0.2-tem
               |     | 20.0.1       | tem     |            | 20.0.1-tem
               |     | 17.0.8       | tem     |            | 17.0.8-tem
               |     | 17.0.8.1     | tem     |            | 17.0.8.1-tem
               |     | 17.0.7       | tem     |            | 17.0.7-tem
               |     | 11.0.20      | tem     |            | 11.0.20-tem
               |     | 11.0.20.1    | tem     |            | 11.0.20.1-tem
               |     | 11.0.19      | tem     |            | 11.0.19-tem
               |     | 8.0.382      | tem     |            | 8.0.382-tem
               |     | 8.0.372      | tem     |            | 8.0.372-tem
```

Let's get the latest version of 8 first:

```shell
[~/exercises] sdk install java 8.0.382-tem
```

Next, let's get the latest version of 17:

```shell
[~/exercises] sdk install java 17.0.8-tem
```

Finally, verify that they are both installed:

```shell
[~/exercises] $ sdk list java | grep tem
 Temurin       |     | 20.0.2       | tem     |            | 20.0.2-tem
               |     | 20.0.1       | tem     |            | 20.0.1-tem
               | >>> | 17.0.8       | tem     | installed  | 17.0.8-tem
               |     | 17.0.8.1     | tem     |            | 17.0.8.1-tem
               |     | 17.0.7       | tem     |            | 17.0.7-tem
               |     | 11.0.20      | tem     |            | 11.0.20-tem
               |     | 11.0.20.1    | tem     |            | 11.0.20.1-tem
               |     | 11.0.19      | tem     |            | 11.0.19-tem
               |     | 8.0.382      | tem     | installed  | 8.0.382-tem
               |     | 8.0.372      | tem     |            | 8.0.372-tem
```

We can see that JDK 17 and JDK 8 are both installed.

### Collecting A First Baseline

As our current code base is set up for JDK 8, we need to verify that the code compiles and runs under that JDK. In order to do that, we set the current version of Java for the shell:

```shell
[~/exercises] $ sdk use java 8.0.382-tem

Using java version 8.0.382-tem in this shell.
```

Then, verify this by checking the java version:

```shell
[~/exercises] $ java -version
openjdk version "1.8.0_382"
OpenJDK Runtime Environment (Temurin)(build 1.8.0_382-b05)
OpenJDK 64-Bit Server VM (Temurin)(build 25.382-b05, mixed mode)
```

**Note:** you may have to source the shell script again after installing the java version to get the `sdk use` command to work correctly. Be sure to verify the correct version is being used!

Now we need to compile the code:

```shell
[~/exercises] $ ./mvnw compile
```

This compile should complete with no errors.

For further verifications, we should run the suite of unit tests:

```shell
[~/exercises] $ ./mvnw test
```

The tests should all pass with no tests skipped.

Lastly, we should verify that the application starts:

```shell
[~/exercises] $ ./mvnw spring-boot:run
```

We now know that the application codebase is in a state where we can being making the necessary changes to JDK 17.

**_NOTE:_** The running application can be stopped with a `CTRL-C`.

### Change the JDK to 17

The first step is to modify the JDK version in the pom.

In the Editor, open `~/exercises/pom.xml` and change the value of the `java.version` property to 17:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "java.version"
```

```xml
<properties>
	<java.version>17</java.version>
  ...
</properties>
```

And back in the console, let's try to compile and see what happens. Let's also clean all remaining JDK artifacts along the way:

```shell

[~/exercises] $ ./mvnw clean compile
...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.906 s
[INFO] Finished at: 2023-09-13T08:44:53-06:00
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.10.1:compile (default-compile) on project family-cash-cards: Fatal error compiling: invalid target release: 17 -> [Help 1]
[ERROR]
```

We got an error! What the console is telling us is that we're trying to build a Java17 application (as defined in pom.xml) with JDK8 (as defined by sdkman in our shell). We need to be using the same JDK to compile the code as what is defined in the pom:

```shell
[~/exercises] $ sdk use java 17.0.8-tem
```

Now that we're set to use the correct JDK, let's try to compile again, with also cleaning up any remaining JDK artifacts:

```shell
[~/exercises] $ ./mvnw clean compile
...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.438 s
[INFO] Finished at: 2023-09-13T08:48:52-06:00
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.10.1:compile (default-compile) on project family-cash-cards: Fatal error compiling: java.lang.IllegalAccessError: class lombok.javac.apt.LombokProcessor (in unnamed module @0xf5ce0bb) cannot access class com.sun.tools.javac.processing.JavacProcessingEnvironment (in module jdk.compiler) because module jdk.compiler does not export com.sun.tools.javac.processing to unnamed module @0xf5ce0bb -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException
```

Now we're getting some class errors, which require a different kind of troubleshooting

### Class Errors

For the most part, classes compiled under a JDK will still work in a later JDK version. That means that any dependency jar does not normally need to be upgraded to one compiled under the desired target JDK. In our example, that means that all of our spring dependencies will not need to be updated just because we updated the JDK. Lombok is an exception to this because lombok does compile-time activities: It auto-generates getters/setters, includes loggers, and other things. This compile-time activity is JDK-dependent, and we will need to update our version of the lombok jar.

There are two approaches to this: Our current lombok version is explicitly specified by our pom:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "org.projectlombok"
```

```xml
<dependency>
	<groupId>org.projectlombok</groupId>
	<artifactId>lombok</artifactId>
	<version>1.18.10</version>
</dependency>
```

We can either update the explicit version in the pom to a more recent version, or we can let spring manage the version for us. The strong recommendation is that spring should be managing the versions of dependencies for the applications, as this provides better dependency hygeine. It is a rare case when we would need to override the verison of a jar that Spring specifies.

Given this, we can verify that Spring manages this version by simply commenting out the version in the pom:

```xml
<dependency>
	<groupId>org.projectlombok</groupId>
	<artifactId>lombok</artifactId>
	<!--<version>1.18.10</version> -->
</dependency>
```

Then, generate a dependency tree to see if Spring is handling this version for us:

```dashboard:open-dashboard
name: Terminal
```

```shell
[~/exercises] $ ./mvnw dependency:tree | grep lombok
[INFO] +- org.projectlombok:lombok:jar:1.18.28:compile
```

We see that indeed Spring is managing this for us, and has brought in a more current version of the jar. Let's try another compile:

```shell
[~/exercises] $ ./mvnw clean compile
...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.562 s
[INFO] Finished at: 2023-09-13T08:59:33-06:00
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.10.1:compile (default-compile) on project family-cash-cards: Compilation failure
[ERROR] /Users/tcollings/dev/spring-academy/course-spring-boot-2-5-upgrade-code/src/main/java/example/cashcard/CashCardApplication.java:[13,22] package javax.xml.bind does not exist
[ERROR]
[ERROR] -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoFailureException
```

Now we're seeing a completely different kind of error: a `javax.xml.bind` package cannot be found. Recalling the deprecated packages from above, we know that this package is no longer included in the SDK by default. We will now need to explicitly include this package in our pom.xml:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<dependencies>"
```

```xml
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.1</version>
</dependency>
```

With this, the application should successfully compile again:

```dashboard:open-dashboard
name: Terminal
```

```shell
[~/exercises] $ ./mvnw clean compile
...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.750 s
[INFO] Finished at: 2023-09-13T09:28:32-06:00
[INFO] ------------------------------------------------------------------------
```

As a final check, we can start the application and verify that the `javax.xml.bind` code in the application class is executing as expected:

```shell
[~/exercises] $ ./mvnw spring-boot:run
...
[INFO] Attaching agents: []
09:30:10.257 [main] INFO example.cashcard.MyApplicationStartingEvent - My parent is Ok!
09:30:10.272 [main] INFO example.cashcard.MyApplicationStartingEvent - application start time is 2023-09-13-06:00
09:30:10.272 [main] INFO example.cashcard.MyApplicationListener - MyApplicationStartingEvent fired!

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::               (v2.7.14)
 ...
```

Remember, you can stop the running application with a `CTRL-C`.

### Runtime Considerations

Just as with our compile-time JDK, our run-time JDK also needs to match the expected version specified in the pom. As a short experiment, let's revert the JDK back to JDK8:

```shell
[~/exercises] $ sdk use java 8.0.382-tem
```

Next, run the application:

```shell
[~/exercises] $ ./mvnw spring-boot:run
...
Error: A JNI error has occurred, please check your installation and try again
Exception in thread "main" java.lang.UnsupportedClassVersionError: example/cashcard/CashCardApplication has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 52.0
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
...
```

Runtime errors of this type indicate a JDK mismatch: in this example, we compiled an application using JDK 17 but tried to run it with JDK 8. Java will let us know that this is not a supported configuration and exit the application accordingly.

<<<<<<< Updated upstream
For your applications, the upgrade is not complete until it is running in production. For this, JDK will have to be installed on the virtual machines supporting the application, or the container will have to include JDK 17. This can be a non-trivial effort for the platform team, so working with that team to plan the effort is essential.

### Concluding Remarks

=======
Other runtime errors may include some of the garbage collection and logging JVM start arguments mentioned above. As these are no longer supported, your team will have to change the way garbage collection or logging is configured. Again, these are rare cases but need to be identified and remedied.

For your applications, the upgrade is not complete until it is running in production. For this, JDK will have to be installed on the virtual machines supporting the application, or the container will have to include JDK 17. This can be a non-trivial effort for the platform team, so working with that team to plan the effort is essential.

### Concluding remarks

This guide is just a sampling of the tasks required to upgrade the JDK of a Spring Application from JDK 8 to JDK 17. Some of the deprecations may require refactoring and others may require whole scale re-implementation of the features. This guide should provide exposure to the tools used to identify the types of errors usually found in these upgrade efforts.

> > > > > > > Stashed changes

This guide is just a sampling of the tasks required to upgrade the JDK of a Spring Application from JDK 8 to JDK 17. Some of the deprecations may require refactoring and others may require whole scale re-implementation of the features. This guide should provide exposure to the tools used to identify the types of errors usually found in these upgrade efforts.
