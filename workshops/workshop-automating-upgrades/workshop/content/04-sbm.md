Now that we have seen the workings of Open Rewrite, we can try the experimental Spring Boot Migrator tool.

First, we should install it by executing the following command in a Terminal:

```execute
curl -L https://github.com/spring-projects-experimental/spring-boot-migrator/releases/download/0.15.0/spring-boot-migrator.jar > spring-boot-migrator.jar
```

After the download, let's start it and scan our current directory for potential recipes to run:

```execute
java -jar ./spring-boot-migrator.jar
```

wait for the migrator prompt then lets scan our directory:

```execute
 scan .
```

We got an error message!

This is because the default for the SBM tool is to automatically commit the changes locally, and it cannot commit changes if it is not working from a clean repo.

Before we can clean up the repo we have to add a couple `git` settings.  let's stop the application and set them:

```execute
exit
```

let's set the email

```execute
git config --global user.email "me@here.com"
```

and the username

```execute
git config --global user.name "tom"
```

Note that we will not be pushing these changes.

Now, let's add our files:

```execute
git add .
```

and commit our changes:

```execute
git commit -m "or recipes"
```

### Please do not push these changes to the remote repository

Let's try the SBM tool again:

```execute
java -jar ./spring-boot-migrator.jar
```

and once the prompt is available scan the directory:

```execute
scan .
```

The migrator tool will scan the repo for applicable recipes and present a list:

```
scanning '.'

Checked preconditions for '/home/eduk8s/exercises'
[ok] Found pom.xml.
[ok] 'sbm.gitSupportEnabled' is 'true', changes will be committed to branch [automation-upgrade] after each recipe.
[ok] Required Java version (17) was found.
[ok] Found required source dir 'src/main/java'.


Maven        100% │██████████████████████████████████│ 2/2 (0:00:02 / 0:00:00)

Applicable recipes:

  1) cn-spring-cloud-config-server
     -> Externalize properties to Spring Cloud Config Server
  2) boot-2.7-3.0-dependency-version-update
     -> Bump spring-boot-starter-parent from 2.7.x to 3.0.0
  3) boot-2.7-3.0-upgrade-report
     -> Create a report for Spring Boot Upgrade from 2.7.x to 3.0.0-M3
  4) sbu30-report
     -> Create a report for Spring Boot Upgrade from 2.7.x to 3.0.x
  5) sbu30-upgrade-dependencies
     -> Spring boot 3.0 Upgrade - Upgrade dependencies
  6) sbu30-set-java-version
     -> Spring boot 3.0 Upgrade - Set java version property in build file
  7) sbu30-add-milestone-repositories
     -> Spring boot 3.0 Upgrade - Add milestone repository for dependencies and plugins
  8) sbu30-remove-construtor-binding
     -> Spring boot 3.0 Upgrade - Remove redundant @ConstructorBinding annotations
  9) sbu30-225-logging-date-format
     -> Spring boot 3.0 Upgrade - Logging Date Format
  10) sbu30-upgrade-spring-cloud-dependency
     -> Upgrade Spring Cloud Dependencies
  11) sbu30-upgrade-boot-version
     -> Spring boot 3.0 Upgrade - Upgrade Spring Boot version
  12) sbu30-paging-and-sorting-repository
     -> Spring boot 3.0 Upgrade - Add CrudRepository interface extension additionally to PagingAndSortingRepository
```

Let's start by applying the second recipe, which will update the Spring Boot version in our `pom.xml`:

```execute
apply 2
```

You will notice that the recipe is applied and a new list of recipes is available which can be applied in sequence.

Before experimenting with this, let's exit the shell 

```execute
exit
```

and look at our git status:

```execute
git status
```

Again, we can see that SBM manages the git commits after each recipe, as opposed to the Open Rewrite model where the developer must manage these.
