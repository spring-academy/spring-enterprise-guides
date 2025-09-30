---
title: 'Fundamentals - Spring Modulith Setup'
---

```terminal:execute-all
command: cd ~/exercises/10-fundamentals/initial
autostart: true
hidden: true
```

```editor:open-file
file: ~/exercises/10-fundamentals/initial/src/main/java/com/example/app/Application.java
autostart: true
hidden: true
```

🎯 Objectives

You’ll learn how to
- add the basic dependencies of Spring Modulith to your Spring Boot application.
- create an application module within the application.
- customize an application module’s metadata.

👣 Build setup

Open `pom.xml`.
```editor:open-file
file: ~/exercises/10-fundamentals/initial/pom.xml
```

Add the Spring Modulith BOM in the `<dependencyManagement />` section.
```editor:select-matching-text
file: ~/exercises/10-fundamentals/initial/pom.xml
text: "<dependencyManagement>"
before: 0
after: 4
```

```editor:replace-text-selection
file: ~/exercises/10-fundamentals/initial/pom.xml
text: |
    	<dependencyManagement>
    	    <dependencies>
    	      <dependency>
    	        <groupId>org.springframework.modulith</groupId>
    	        <artifactId>spring-modulith-bom</artifactId>
    	        <version>1.0.0</version>
    	        <type>pom</type>
    	        <scope>import</scope>
    	      </dependency>
    	    </dependencies>
        </dependencyManagement>
```

Add the `org.springframework:spring-modulith-starter-test` dependency in test scope to your `pom.xml`.

```editor:select-matching-text
file: ~/exercises/10-fundamentals/initial/pom.xml
text: "<!-- Spring Modulith -->"
before: 0
after: 0
```

```editor:replace-text-selection
file: ~/exercises/10-fundamentals/initial/pom.xml
text: |
    		<dependency>
              <groupId>org.springframework.modulith</groupId>
              <artifactId>spring-modulith-starter-test</artifactId>
              <scope>test</scope>
    		</dependency>
```

List the Spring Modulith dependencies in test scope.
> Note: This command might seem to "hang" for a few moments the first time it runs. It's just downloading the new Spring Modulith libraries but that informational output is being filtered out. Please be patient.

[//]: # (```terminal:execute)

[//]: # (command: ./mvnw -f ~/exercises/10-fundamentals/initial dependency:list -Dsort | grep -v Download | grep modulith )

[//]: # (```)

[//]: # ()
[//]: # (OR)
```terminal:execute
command: mvnw dependency:list -Dsort | grep -v Download | grep modulith 
```

The output should look like this.
```
[INFO] org.springframework.modulith:spring-modulith-api:jar:1.0.0:test -- module org.springframework.modulith.api [auto]
[INFO] org.springframework.modulith:spring-modulith-core:jar:1.0.0:test -- module org.springframework.modulith.core [auto]
[INFO] org.springframework.modulith:spring-modulith-docs:jar:1.0.0:test -- module org.springframework.modulith.docs [auto]
[INFO] org.springframework.modulith:spring-modulith-starter-test:jar:1.0.0:test -- module org.springframework.modulith.starter.test [auto]
[INFO] org.springframework.modulith:spring-modulith-test:jar:1.0.0:test -- module org.springframework.modulith.test [auto]
```