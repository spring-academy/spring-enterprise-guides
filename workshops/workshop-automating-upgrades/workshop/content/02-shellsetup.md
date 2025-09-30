Before we can start the upgrade of the JDK from 8 to 17, we have to have both JDKs available in our shell. For this purpose we will use SDKMAN!, a tool for managing versions of many runtimes, including java.

The installation is simple and quick! Open up the Terminal tab and run the following command:

```execute
curl -s "https://get.sdkman.io" | bash
```

Because of the way Linux shells work, in order for the installed `sdk` executable to be visible, you'll need to alter the shell environment to make it visible, or create a new shell. We'll follow the instructions from [SDKMAN!](https://sdkman.io/) to alter the shell environment:

```execute
source "/home/eduk8s/.sdkman/bin/sdkman-init.sh"
```

Now we'll use SDKMAN! to install our JDK distributions. Since those are Java distributions, we'll ask SDKMAN! what choices it has in the `java` application.

There are many, but we recommend the Temurin versions:

```execute
sdk list java | grep tem
```

Let's get the latest version of 8 first:

```execute
sdk install java 8.0.392-tem
```

Next, let's get the latest version of 17:

```execute
sdk install java 17.0.9-tem
```

Finally, verify that they are both installed:

```execute
sdk list java | grep tem
```

We can see that JDK 17 and JDK 8 are both installed.

**Note:** you may have to source the shell script again after installing the java version to get the `sdk use` command to work correctly. Be sure to verify the correct version is being used!

```execute
source "/home/eduk8s/.sdkman/bin/sdkman-init.sh"
```

As our current code base is set up for JDK 8, we need to verify that the code compiles and runs under that JDK. In order to do that, we set the current version of Java for the shell:

```execute
sdk use java 8.0.392-tem
```

Then, verify this by checking the java version:

```execute
java -version
```


