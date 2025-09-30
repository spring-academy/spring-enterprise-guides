Now we begin using Open Rewrite to make the necessary code modifications to upgrade the JDK to 17. 

First let's open the pom:

```editor:open-file
file: ~/exercises/pom.xml
```

Now add the following code as a plugin to the `pom.xml` file.  Locate the last plugin in the plugins section:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "</plugin>"
```

and add a new one:

```editor:insert-lines-before-line
file: ~/exercises/pom.xml
line: 88
text: "<plugin>
<groupId>org.openrewrite.maven</groupId>
<artifactId>rewrite-maven-plugin</artifactId>
<version>5.22.0</version>
<configuration>
  <activeRecipes>
    <recipe>org.openrewrite.java.migrate.JavaVersion17</recipe>
  </activeRecipes>
</configuration>
<dependencies>
  <dependency>
    <groupId>org.openrewrite.recipe</groupId>
    <artifactId>rewrite-migrate-java</artifactId>
    <version>2.8.0</version>
  </dependency>
</dependencies>
</plugin>"
```


This is a very simple recipe that will change the JDK version in the `pom.xml` file from 1.8 to 17. In order to execute this, type the following in the Terminal:

```execute
./mvnw rewrite:run
```

You should see quite a bit of downloads and execution before a successful complete. After this is done, use the git compare tool in the editor to verify the change of the `java.version` property from 1.8 to 17.

A very simple recipe indeed! In fact, the trouble of running this recipe in isolation is probably more effort than just changing the `java.version` property manually. Open Rewrite recognizes this, and allows for the combination of many recipes under an umbrella recipe. This means that many recipes can be run as a part of the same execution.

To try this, we must first change the JDK in our shell to 17 to properly execute a maven command:

```execute
sdk use java 17.0.9-tem
```

Confirm this change with a `java -version` command.

```execute
java -version
```

You may have also noticed how clumsy it was to execute this recipe, by modifying the pom.xml file.  Doing this on a recipe-by-recipe basis would be very time consuing and could potentially lead to poor hygeine in the pom.  A preferred way is to use the command line parameters.

We'd like to execute the javax to jakarta recipe, which will account for all the javax changes.  First, find the old plugin from the pom:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<recipe>org.openrewrite.java.migrate.JavaVersion17</recipe>"
before: 0
after: 0
```

and remove it:

```editor:replace-text-selection
file: ~/exercises/pom.xml
text: ""
```

Now, let's run our javax to jakarta recipe from the command line:

```execute
./mvnw -U org.openrewrite.maven:rewrite-maven-plugin:run -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:RELEASE -Drewrite.activeRecipes=org.openrewrite.java.migrate.jakarta.JavaxMigrationToJakarta
```

Again, we should see a successful execution of rules.

Examine the git changes in the editor to see what's been changed: the `pom.xml` (changing the `javax` dependency to `jakarta`) and in the `CashCardApplication` class (changing the `import`).

Let's try to compile!

```execute
./mvnw clean compile
```

Did it succeed? Why not?

Unfortunately the Open Rewrite recipes are not always complete.

In this case, our `jakarta` recipe was expecting a managed version of the `jakarta.xml.bind-api` dependency to already exist in the pom.  In our case, it was not.

We can fix this by explicitly setting the version.  Let's find the dependency:

```editor:select-matching-text
file: ~/exercises/pom.xml
text: "<artifactId>jakarta.xml.bind-api</artifactId>"
```

and add the version:

```editor:insert-lines-before-line
file: ~/exercises/pom.xml
line: 71
text: "<version>3.0.0</version>"
```

Now, a compile should succeed.

```execute
./mvnw clean compile
```

This is worth calling out about using open source recipes: Before applying them at large scale a team should run experiments to determine how the recipe behaves against a representative code base.
