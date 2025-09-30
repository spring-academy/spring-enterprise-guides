This guide provides a sampling of how [Spring Boot](https://github.com/spring-projects/spring-boot) helps you accelerate
application development. As you read more Spring Getting Started guides, you will see more
use cases for Spring Boot. This guide is meant to give you a quick taste of Spring Boot.

In order to create your own Spring Boot-based project, normally you would visit
[Spring Initializr](https://start.spring.io/), fill in your project details, pick your
options, and download a bundled up project as a zip file. In this lab,
we've provided Spring Initializer in the tab to the right.

## What You Will build

You will build a simple web application with Spring Boot and add some useful services to
it.

## How to complete this guide

Like most Spring Getting Started guides, you will start from scratch and complete each step. By the end of the guide, you end up with working code.

If you want to verify your work, you can look at the completed codebase:

1. Download or clone the git repository at https://github.com/spring-guides/gs-spring-boot

2. cd into `gs-spring-boot/initial`

## Learn What You Can Do with Spring Boot

Spring Boot offers a fast way to build applications. It looks at your classpath and at the
beans you have configured, makes reasonable assumptions about what you are missing, and
adds those items. With Spring Boot, you can focus more on business features and less on
infrastructure.

The following examples show what Spring Boot can do for you:

- Is Spring MVC on the classpath? There are several specific beans you almost always need,
  and Spring Boot adds them automatically. A Spring MVC application also needs a servlet
  container, so Spring Boot automatically configures embedded Tomcat.
- Is Jetty on the classpath? If so, you probably do NOT want Tomcat but instead want
  embedded Jetty. Spring Boot handles that for you.
- Is Thymeleaf on the classpath? If so, there are a few beans that must always be added to
  your application context. Spring Boot adds them for you.

These are just a few examples of the automatic configuration Spring Boot provides. At the
same time, Spring Boot does not get in your way. For example, if Thymeleaf is on your
path, Spring Boot automatically adds a `SpringTemplateEngine` to your application context.
But if you define your own `SpringTemplateEngine` with your own settings, Spring Boot does
not add one. This leaves you in control with little effort on your part.

NOTE: Spring Boot does not generate code or make edits to your files. Instead, when you
start your application, Spring Boot dynamically wires up beans and settings and applies
them to your application context.

## Starting with Spring Initializr

To manually initialize the project:

1. Select the _Spring Initializr_ tab to the right.
   This service pulls in all the dependencies you need for an application and does most of the setup for you.
1. In the _Project Metadata_ section, set the value of the _Artifact_ field to `springboot`.
1. Choose either Gradle or Maven and the language you want to use. This guide assumes that you chose Java.
1. Click _Dependencies_ and select _Spring Web_.
1. Click the _Create_ button.

You will see that the resulting project is downloaded as a ZIP file, and then unzipped in the _Terminal_ tab, to the right, into the `springboot` directory.

## Create a Simple Web Application

Now you can create a web controller for a simple web application. Using the _Editor_ tab to the right,
create a new file `springboot/src/main/java/com/example/springboot/HelloController.java` containing the following content:

```java
package com.example.springboot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

	@GetMapping("/")
	public String index() {
		return "Greetings from Spring Boot!";
	}

}
```

The class is flagged as a `@RestController`, meaning it is ready for use by Spring MVC to
handle web requests. `@GetMapping` maps `/` to the `index()` method. When invoked from
a browser or by using curl on the command line, the method returns pure text. That is
because `@RestController` combines `@Controller` and `@ResponseBody`, two annotations that
results in web requests returning data rather than a view.

## Create an Application class

The Spring Initializr creates a simple application class for you. However, in this case,
it is too simple. You need to modify the application class to match the following listing.
Update the `src/main/java/com/example/springboot/SpringbootApplication.java` file to contain the following content:

```java
package com.example.springboot;

import java.util.Arrays;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class SpringbootApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringbootApplication.class, args);
	}

	@Bean
	public CommandLineRunner commandLineRunner(ApplicationContext ctx) {
		return args -> {

			System.out.println("Let's inspect the beans provided by Spring Boot:");

			String[] beanNames = ctx.getBeanDefinitionNames();
			Arrays.sort(beanNames);
			for (String beanName : beanNames) {
				System.out.println(beanName);
			}

		};
	}

}
```

`@SpringBootApplication` is a convenience annotation that adds all of the following:

- `@Configuration`: Tags the class as a source of bean definitions for the application
  context.
- `@EnableAutoConfiguration`: Tells Spring Boot to start adding beans based on classpath
  settings, other beans, and various property settings. For example, if `spring-webmvc` is
  on the classpath, this annotation flags the application as a web application and activates
  key behaviors, such as setting up a `DispatcherServlet`.
- `@ComponentScan`: Tells Spring to look for other components, configurations, and
  services in the `com/example` package, letting it find the controllers.

The `main()` method uses Spring Boot's `SpringApplication.run()` method to launch an
application. Did you notice that there was not a single line of XML? There is no `web.xml`
file, either. This web application is 100% pure Java and you did not have to deal with
configuring any plumbing or infrastructure.

There is also a `CommandLineRunner` method marked as a `@Bean`, and this runs on start up.
It retrieves all the beans that were created by your application or that were
automatically added by Spring Boot. It sorts them and prints them out.

## Run the Application

To run the application, use the _Editor_:

. Find the `SpringbootApplication.java` file
. Right-click and select the _Run Java_ option in the context menu.

You should see output similar to the following:

```no-highlight
Let's inspect the beans provided by Spring Boot:
applicationAvailability
applicationTaskExecutor
basicErrorController
beanNameHandlerMapping
beanNameViewResolver
characterEncodingFilter
commandLineRunner
conventionErrorViewResolver
defaultServletHandlerMapping
defaultViewResolver
dispatcherServlet
dispatcherServletRegistration
error
errorAttributes
errorPageCustomizer
errorPageRegistrarBeanPostProcessor
flashMapManager
forceAutoProxyCreatorToUseClassProxying
formContentFilter
handlerExceptionResolver
handlerFunctionAdapter
helloController
httpRequestHandlerAdapter
jacksonObjectMapper
jacksonObjectMapperBuilder
jsonComponentModule
jsonMixinModule
jsonMixinModuleEntries
lifecycleProcessor
localeCharsetMappingsCustomizer
localeResolver
mappingJackson2HttpMessageConverter
messageConverters
multipartConfigElement
multipartResolver
mvcContentNegotiationManager
mvcConversionService
mvcHandlerMappingIntrospector
mvcPathMatcher
mvcPatternParser
mvcResourceUrlProvider
mvcUriComponentsContributor
mvcUrlPathHelper
mvcValidator
mvcViewResolver
org.springframework.aop.config.internalAutoProxyCreator
org.springframework.boot.autoconfigure.AutoConfigurationPackages
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration$ClassProxyingConfiguration
org.springframework.boot.autoconfigure.availability.ApplicationAvailabilityAutoConfiguration
org.springframework.boot.autoconfigure.context.ConfigurationPropertiesAutoConfiguration
org.springframework.boot.autoconfigure.context.LifecycleAutoConfiguration
org.springframework.boot.autoconfigure.context.PropertyPlaceholderAutoConfiguration
org.springframework.boot.autoconfigure.http.HttpMessageConvertersAutoConfiguration
org.springframework.boot.autoconfigure.http.HttpMessageConvertersAutoConfiguration$StringHttpMessageConverterConfiguration
org.springframework.boot.autoconfigure.http.JacksonHttpMessageConvertersConfiguration
org.springframework.boot.autoconfigure.http.JacksonHttpMessageConvertersConfiguration$MappingJackson2HttpMessageConverterConfiguration
org.springframework.boot.autoconfigure.info.ProjectInfoAutoConfiguration
org.springframework.boot.autoconfigure.internalCachingMetadataReaderFactory
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration$Jackson2ObjectMapperBuilderCustomizerConfiguration
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration$JacksonMixinConfiguration
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration$JacksonObjectMapperBuilderConfiguration
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration$JacksonObjectMapperConfiguration
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration$ParameterNamesModuleConfiguration
org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration
org.springframework.boot.autoconfigure.ssl.SslAutoConfiguration
org.springframework.boot.autoconfigure.task.TaskExecutionAutoConfiguration
org.springframework.boot.autoconfigure.task.TaskSchedulingAutoConfiguration
org.springframework.boot.autoconfigure.web.client.RestTemplateAutoConfiguration
org.springframework.boot.autoconfigure.web.embedded.EmbeddedWebServerFactoryCustomizerAutoConfiguration
org.springframework.boot.autoconfigure.web.embedded.EmbeddedWebServerFactoryCustomizerAutoConfiguration$TomcatWebServerFactoryCustomizerConfiguration
org.springframework.boot.autoconfigure.web.servlet.DispatcherServletAutoConfiguration
org.springframework.boot.autoconfigure.web.servlet.DispatcherServletAutoConfiguration$DispatcherServletConfiguration
org.springframework.boot.autoconfigure.web.servlet.DispatcherServletAutoConfiguration$DispatcherServletRegistrationConfiguration
org.springframework.boot.autoconfigure.web.servlet.HttpEncodingAutoConfiguration
org.springframework.boot.autoconfigure.web.servlet.MultipartAutoConfiguration
org.springframework.boot.autoconfigure.web.servlet.ServletWebServerFactoryAutoConfiguration
org.springframework.boot.autoconfigure.web.servlet.ServletWebServerFactoryConfiguration$EmbeddedTomcat
org.springframework.boot.autoconfigure.web.servlet.WebMvcAutoConfiguration
org.springframework.boot.autoconfigure.web.servlet.WebMvcAutoConfiguration$EnableWebMvcConfiguration
org.springframework.boot.autoconfigure.web.servlet.WebMvcAutoConfiguration$WebMvcAutoConfigurationAdapter
org.springframework.boot.autoconfigure.web.servlet.error.ErrorMvcAutoConfiguration
org.springframework.boot.autoconfigure.web.servlet.error.ErrorMvcAutoConfiguration$DefaultErrorViewResolverConfiguration
org.springframework.boot.autoconfigure.web.servlet.error.ErrorMvcAutoConfiguration$WhitelabelErrorViewConfiguration
org.springframework.boot.autoconfigure.websocket.servlet.WebSocketServletAutoConfiguration
org.springframework.boot.autoconfigure.websocket.servlet.WebSocketServletAutoConfiguration$TomcatWebSocketConfiguration
...
tomcatServletWebServerFactory
tomcatServletWebServerFactoryCustomizer
tomcatWebServerFactoryCustomizer
viewControllerHandlerMapping
viewNameTranslator
viewResolver
webServerFactoryCustomizerBeanPostProcessor
websocketServletWebServerCustomizer
welcomePageHandlerMapping
welcomePageNotAcceptableHandlerMapping
```

You can clearly see `org.springframework.boot.autoconfigure` beans. There is also a `tomcatServletWebServerFactory`.

Now run the service with curl (in the _Terminal_ window), by running the following
command (shown with its output):

```bash
[~] $ curl localhost:8080
Greetings from Spring Boot!
```

## Add Unit Tests

You will want to add a test for the endpoint you added, and Spring Test provides some
machinery for that.

If you use Gradle, you should see the following dependency in your `build.gradle` file:

```groovy
testImplementation 'org.springframework.boot:spring-boot-starter-test'
```

If you use Maven, make sure the following dependency is in your `pom.xml` file:

```xml
<dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-test</artifactId>
      <scope>test</scope>
</dependency>
```

Now write a simple unit test that mocks the servlet request and response through your
endpoint. Create a file called
`springboot/src/test/java/com/example/springboot/HelloControllerTest.java`) with the following contents:

```java
package com.example.springboot;

import static org.hamcrest.Matchers.equalTo;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

@SpringBootTest
@AutoConfigureMockMvc
public class HelloControllerTest {

	@Autowired
	private MockMvc mvc;

	@Test
	public void getHello() throws Exception {
		mvc.perform(MockMvcRequestBuilders.get("/").accept(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content().string(equalTo("Greetings from Spring Boot!")));
	}
}
```

`MockMvc` comes from Spring Test and lets you, through a set of convenient builder
classes, send HTTP requests into the `DispatcherServlet` and make assertions about the
result. Note the use of `@AutoConfigureMockMvc` and `@SpringBootTest` to inject a
`MockMvc` instance. Having used `@SpringBootTest`, we are asking for the whole application
context to be created. An alternative would be to ask Spring Boot to create only the web
layers of the context by using `@WebMvcTest`. In either case, Spring Boot automatically
tries to locate the main application class of your application, but you can override it or
narrow it down if you want to build something different.

As well as mocking the HTTP request cycle, you can also use Spring Boot to write a simple
full-stack integration test. For example, instead of (or as well as) the mock test shown
earlier, we could create the following test (from
`src/test/java/com/example/springboot/HelloControllerIT.java`):

```java
package com.example.springboot;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class HelloControllerIT {
    @Autowired
    private TestRestTemplate template;

    @Test
    public void getHello() throws Exception {
        ResponseEntity<String> response = template.getForEntity("/", String.class);
        assertThat(response.getBody()).isEqualTo("Greetings from Spring Boot!");
    }
}
```

The embedded server starts on a random port because of
`webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT`, and the actual port is
configured automatically in the base URL for the `TestRestTemplate`.

## Add Production-grade Services

If you are building a web site for your business, you probably need to add some management
services. Spring Boot provides several such services (such as health, audits, beans, and
more) with its
[actuator module](https://docs.spring.io/spring-boot/docs/3.1.1/reference/htmlsingle/#production-ready).

If you use Gradle, add the following dependency to your `build.gradle` file:

```groovy
implementation 'org.springframework.boot:spring-boot-starter-actuator'
```

If you use Maven, add the following dependency to your `pom.xml` file:

```xml
<dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

Then restart the application. This time, let's use the command line.
First, stop the application using the Stop button (the red square) in the dialog towards the top of the Editor:

![Editor Start Stop Dialog](images/editor-start-stop-dialog.png)

Now, in the _uppermost Terminal_, make sure your are inthe ~/springboot directory, run the application as follows:

```bash
[~] $ cd springboot
[~/springboot] $ ./gradlew bootRun
```

You should see that a new set of RESTful end points have been added to the application.
These are management services provided by Spring Boot. The following listing shows typical
output:

```no-highlight
org.springframework.boot.actuate.autoconfigure.availability.AvailabilityHealthContributorAutoConfiguration
org.springframework.boot.actuate.autoconfigure.availability.AvailabilityProbesAutoConfiguration
org.springframework.boot.actuate.autoconfigure.endpoint.EndpointAutoConfiguration
org.springframework.boot.actuate.autoconfigure.endpoint.jackson.JacksonEndpointAutoConfiguration
org.springframework.boot.actuate.autoconfigure.endpoint.web.ServletEndpointManagementContextConfiguration
org.springframework.boot.actuate.autoconfigure.endpoint.web.ServletEndpointManagementContextConfiguration$WebMvcServletEndpointManagementContextConfiguration
org.springframework.boot.actuate.autoconfigure.endpoint.web.WebEndpointAutoConfiguration
org.springframework.boot.actuate.autoconfigure.endpoint.web.WebEndpointAutoConfiguration$WebEndpointServletConfiguration
org.springframework.boot.actuate.autoconfigure.endpoint.web.servlet.WebMvcEndpointManagementContextConfiguration
org.springframework.boot.actuate.autoconfigure.health.HealthContributorAutoConfiguration
org.springframework.boot.actuate.autoconfigure.health.HealthEndpointAutoConfiguration
org.springframework.boot.actuate.autoconfigure.health.HealthEndpointConfiguration
org.springframework.boot.actuate.autoconfigure.health.HealthEndpointWebExtensionConfiguration
org.springframework.boot.actuate.autoconfigure.health.HealthEndpointWebExtensionConfiguration$MvcAdditionalHealthEndpointPathsConfiguration
org.springframework.boot.actuate.autoconfigure.info.InfoContributorAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.CompositeMeterRegistryAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.JvmMetricsAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.LogbackMetricsAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.MetricsAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.SystemMetricsAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.export.simple.SimpleMetricsExportAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.integration.IntegrationMetricsAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.startup.StartupTimeMetricsListenerAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.task.TaskExecutorMetricsAutoConfiguration
org.springframework.boot.actuate.autoconfigure.metrics.web.tomcat.TomcatMetricsAutoConfiguration
org.springframework.boot.actuate.autoconfigure.observation.ObservationAutoConfiguration
org.springframework.boot.actuate.autoconfigure.observation.ObservationAutoConfiguration$MeterObservationHandlerConfiguration
org.springframework.boot.actuate.autoconfigure.observation.ObservationAutoConfiguration$MeterObservationHandlerConfiguration$OnlyMetricsMeterObservationHandlerConfiguration
org.springframework.boot.actuate.autoconfigure.observation.ObservationAutoConfiguration$OnlyMetricsConfiguration
org.springframework.boot.actuate.autoconfigure.observation.web.client.HttpClientObservationsAutoConfiguration
org.springframework.boot.actuate.autoconfigure.observation.web.client.HttpClientObservationsAutoConfiguration$MeterFilterConfiguration
org.springframework.boot.actuate.autoconfigure.observation.web.client.RestTemplateObservationConfiguration
org.springframework.boot.actuate.autoconfigure.observation.web.servlet.WebMvcObservationAutoConfiguration
org.springframework.boot.actuate.autoconfigure.observation.web.servlet.WebMvcObservationAutoConfiguration$MeterFilterConfiguration
org.springframework.boot.actuate.autoconfigure.system.DiskSpaceHealthContributorAutoConfiguration
org.springframework.boot.actuate.autoconfigure.web.server.ManagementContextAutoConfiguration
org.springframework.boot.actuate.autoconfigure.web.server.ManagementContextAutoConfiguration$SameManagementContextConfiguration
org.springframework.boot.actuate.autoconfigure.web.server.ManagementContextAutoConfiguration$SameManagementContextConfiguration$EnableSameManagementContextConfiguration
org.springframework.boot.actuate.autoconfigure.web.servlet.ServletManagementContextAutoConfiguration
```

The actuator exposes the following:

- `https://localhost:8080/actuator/health`
- `https://localhost:8080/actuator`

NOTE: There is also an `/actuator/shutdown` endpoint, but, by default, it is visible only
through JMX. To [enable it as an HTTP endpoint](https://docs.spring.io/spring-boot/docs/3.1.1/reference/htmlsingle/#production-ready-endpoints-enabling-endpoints), add
`management.endpoint.shutdown.enabled=true` to your `application.properties` file
and expose it with `management.endpoints.web.exposure.include=health,info,shutdown`.
However, you probably should not enable the shutdown endpoint for a publicly available
application.

You can check the health of the application by running the following command in the _lower Terminal_:

```bash
[~] $ curl https://localhost:8080/actuator/health
{"status":"UP","groups":["liveness","readiness"]}
```

You can try also to invoke shutdown through curl, to see what happens when you have not
added the necessary line (shown in the preceding note) to `application.properties`:

```bash
[~] $ curl -X POST localhost:8080/actuator/shutdown
{"timestamp":"2023-06-30T20:24:25.564+00:00","status":404,"error":"Not Found","path":"/actuator/shutdown"}
```

Because we did not enable it, the requested endpoint is not available (because the endpoint does not
exist).

For more details about each of these REST endpoints and how you can tune their settings
with an `application.properties` file (in `src/main/resources`), see the
the [documentation about the endpoints](https://docs.spring.io/spring-boot/docs/3.1.1/reference/htmlsingle/#production-ready-endpoints).

## View Spring Boot's Starters

You have seen some of
[Spring Boot's "`starters`"](https://docs.spring.io/spring-boot/docs/3.1.1/reference/htmlsingle/#using-boot-starter).
You can see them all
[here in source code](https://github.com/spring-projects/spring-boot/tree/main/spring-boot-project/spring-boot-starters).

## JAR Support

The last example showed how Spring Boot lets you wire beans that you may not be aware you
need. It also showed how to turn on convenient management services.

However, Spring Boot does more than that. It supports not only traditional WAR file
deployments but also lets you put together executable JARs, thanks to Spring Boot's loader
module. The various guides demonstrate this dual support through the
`spring-boot-gradle-plugin` and `spring-boot-maven-plugin`.

## Summary

Congratulations! You built a simple web application with Spring Boot and learned how it
can ramp up your development pace. You also turned on some handy production services.
This is only a small sampling of what Spring Boot can do. See
[Spring Boot's online docs](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle)
for much more information.

## See Also

The following guides may also be helpful:

- [Securing a Web Application](https://spring.io/guides/gs/securing-web/)
- [Serving Web Content with Spring MVC](https://spring.io/guides/gs/serving-web-content/)

Want to write a new guide or contribute to an existing one? Check out our [contribution guidelines](https://github.com/spring-guides/getting-started-guides/wiki).

IMPORTANT: All guides are released with an ASLv2 license for the code, and an [Attribution, NoDerivatives creative commons license](https://creativecommons.org/licenses/by-nd/3.0/) for the writing.
