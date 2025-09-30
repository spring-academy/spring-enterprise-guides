### Collecting a first baseline

- Compile the application

```execute
./mvnw compile
```

- Run _all_ the tests

```execute
./mvnw test
```

Looks like we're skipping a test?  That doesn't seem right, let's clean that up.  Let's go to the test class:

```editor:open-file
file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
```

And see if we can locate a Disabled annotation:

```editor:select-matching-text
file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
text: "@Disabled"
```

We can!  Let's remove that annotation:

```editor:replace-text-selection
file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
text: ""
```

and re-run the tests:

```execute
./mvnw test
```

Hrm, now the test is failing!  Looks like we need to change that expected value:

```editor:select-matching-text
file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
text: "assertThat(amount).isEqualTo(12.45);"
```

Let's set it to the correct expectation (this can be verified by examining data.sql)

```editor:replace-text-selection
file: ~/exercises/src/test/java/example/cashcard/CashCardApplicationTests.java
text: "assertThat(amount).isEqualTo(123.45);"
```

and re-run the tests:

```execute
./mvnw test
```

Things are looking better!

- Start the application

```execute
./mvnw spring-boot:run
```

- Test with sample data

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

### end state

Stop the application when satisfied (ctrl-c)

```execute
<ctrl+c>
```


#### Notes

Credentials for the application are:  
 sarah1/abc123  
 hank-owns-no-cards/qrs456  
 kumar2/xyz789
