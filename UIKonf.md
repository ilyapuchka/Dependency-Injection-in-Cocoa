
![left 60%](Assets/me.jpg)

# Ilya Puchka
## iOS developer @HelloFresh
### @ilyapuchka
## Dependency Injection (DI) in Swift

^ Hi everyone. My name is Ilya. I'm working as iOS developer here in Berlin at company called HelloFresh.
And, of course, we have an iOS app. Since day one it was a pure Swift app.

---

### Functional<br>or<br>object oriented?

^ For many of us Swift opened up a world of functional programming. But it is still much more object oriented language than functional. 

^ And our main tools - Cocoa frameworks are object oriented. So probably we will still keep writing object oriented code. 

^ The problem with that is that it is actually hard to write well designed object oriented code.

---

## SOLID KISS DRY YAGNI RAP CQS DECORATOR FACADE ABSTRACT FACTORY STRATEGY ...

^ There are bunch of different design principles, like SOLID and others, and even more design patterns. Just the fact that there are so many different principles and patterns means, at least for me, that good object oriented design is hard, if ever possible.

---

# DI ![](Assets/8acc5e3fdaef21a70f196eb15f237d1f.png) SOLID

^ Dependency Injection which I'm going to talk about today is itself not a part of SOLID principles that I have just mentioned. But it strongly relates to all of them. 

---

## What is Dependency Injection?

^ Unfortunatelly the concept of Dependency Injection is surrounded with many misconceptions. 

---

^ Wikipedia gives us very complex definition.

^ In software engineering, dependency injection is a software design pattern that implements inversion of control for resolving dependencies.

> In software engineering, dependency injection is a software design pattern that implements inversion of control for resolving dependencies.
-- Wikipedia

---

^ In contrast some developers say that dependency injection is just passing in an instance variable.

> “Dependency injection is really just passing in an instance variable.
-- James Shore

---

### Voodo magic
### Slow frameworks
### Only for testing
### Overengineering

^ Others think that it is some kind of voodoo magic that requires to use complicated and slow frameworks, or that it is only relevant for testing and just makes code harder to understand.

^ I would say that all of these are misconceptions about Dependency Injection.

---

- What is Dependency Injection?
- How to do it?
- How not to do it?

^ Today I will try to make it more clear, as far as I can, and present what I've learned about Dependency Injection. I will try to show how we can do Dependency Injection. And more than that we will discuss how we should not do it.

---

# Why Dependency Injection?

^ To start let's see what problems Dependency Injection tries to solve in the first place.

---

## Abstractions everywhere

^ In programming we always have to deal with abstractions of different kinds and levels. They are just everywhere. Interfaces, methods, closures and even concrete types and variables names - they are all abstractions.

---

^ For a good code design it's very important to use proper abstractions because they make our code loosely coupled. 

^ That means that different componenets of our code can be replaced with alternative implementations without affecting other components.

## Loose Coupling

---

###[fit] test
###[fit] extend and reuse
###[fit] develop in paraller
###[fit] maintain

^ When our code is loosely coupled it becomes easier to test, easier to extend, easier to reuse, easier to develop in parallel.

^ That all makes it easier to maintain. 

^ Loosely coupled code is the main goal of Dependency Injection. It enables us to write loosely coupled code. And thus it makes testing, extending and reusing code much easier. 

---

## [fit] not just unit tests
## but
## [fit] loose coupling

^ Very often Dependency Injection is discussed only in context of Unit Testing. And indeed it improves testability a lot, especially in Swift.

^ But the real picture is much wider. If our final goal is not just unit testing some classes but loose coupling and making our code maintainable then we will need to make a bit more effort than just passing instance varibales.

---

## First step - 
## passing instance variables

^ Though it is true that in its essence Dependency Injection is about passing instance variables or better to say passing dependencies to their consumers. 

^ This is the first step and as each first step it is the most important one. But that is only one part of a story.

---

## Second step - ?
## Third step - ?

^ There are also a second and even a third step. And these steps make the difference between just passing variables and Dependency Injection.

---

^ So let's start with the first step.

^ There are few patterns how we can pass dependencies to their consumers. Constructor, property, method injection and ambient context.

## Patterns
##<br>
### Custructor Injection
### Property Injection
### Method Injection
### Ambient context

^ Let's see how they look like using examples from Cocoa frameworks.

---

# Constructor injection

^ Here is an example of constructor injection from CoreData:

```swift
class NSPersistentStore : NSObject {

	init(persistentStoreCoordinator root: NSPersistentStoreCoordinator?, 
		configurationName name: String?, 
		URL url: NSURL, 
		options: [NSObject: AnyObject]?)
		
	var persistentStoreCoordinator: NSPersistentStoreCoordinator? { get }
	
}
```

^ Here the instance of persistent store coordinator is passed in constructor of `NSPersistentStore` along with some other parameters. Then reference to coordinator is stored and can not be changed in runtime. 

^ So with constructor injection we pass dependencies as cunstructor arguments and store them in readonly properties.

---

## Easy to implement
## Immutability

^ Though there are not so many examples of constructor injection in Cocoa frameworks, it is the prefered way to inject dependencies. Because it's the easiest one to implement, it ensures that dependencies will be always present and that they will not change at runtime what makes it much safer.

^ But there are cases when constructor injection is not possible or does not fit well. In these cases we should use property injection.

---

# Property injection

^ This pattern is all over the place in any iOS application. For example delegate pattern is often implemented using property injection. 

```swift
extension UIViewController {

    weak public var transitioningDelegate: 
    		UIViewControllerTransitioningDelegate?
    		
}
```

^ Here for example view controller exposes writable property for transitioning delegate that we can change at any moment if we want to override the dafault behavior.

^ With property injection consumer gets its dependency through writable property that also has some default value.

^ When should we use this pattern?

---

## Local default
## Foreign default

^ Property injection should be used when there is a good local default for dependency. "Local" means that it is defined in the same framework or library. `nil` is also a perfect local default, it just makes dependency optional. 

^ When implementation comes from a separate framework it is foreign. Then we should not use it as a default value. And we should not use property injection for such dependency. Instead we should use constructor injection.

^ Imagine that default implementation of transitioning delegate is defined not in UIKit, but in some other framework. Then we will always need to link to this framework even if we never use this API. UIKit becomes tightly coupled with that framework. And it drags along this unneded dependency. The same can happen with our own code and that will make it harder to reuse.

---

## Optionals
## Not immutable
## Thread safety

^ Comparing with constructor injection property injection is maybe easier to understand and it makes our API to look more flexible. But at the same time it can be harder to implement and can make our code more fragile. 

^ First of all we need to have some default implementation in place or handle optional value in a proper way which can lead to cluttering code with unwrapping optionals. 

^ Secondly, we can not define our property as immutable. So if we don't want to allow to change it once it was set we will need to ensure that at runtime instead of compile time.

^ Also we may need to synchronise access to it to prevent threading issues.

^ For these reasons if we can use constructor injection we should prefer it over property injection. 

---

# Method injection

^ Next pattern, method injection, is as simple as passing argument to a method. For example here is NSCoding protocol:

```swift
public protocol NSCoding {

    public func encodeWithCoder(aCoder: NSCoder)
    
}
```

^ Each time the method is called different instance and even implementation of `NSCoder` can be passed as an argument.

^ Method injection is usually used when dependency can vary with each method call or when dependency is temporal and it is not required to keep reference to it outside of a method scope. 

---

# Ambient context

```swift
public class NSURLCache : NSObject {

	public class func setSharedURLCache(cache: NSURLCache)
	
	public class func sharedURLCache() -> NSURLCache
	
}
```

^ The last pattern - ambient context - is hard to find in Cocoa. Probably NSURLCache is the most close example. 

^ Ambient context is implemented using some static method or static writable property with some default value. Here for example we can set any subclass of NSURLCache as a shared instance and then access it with static getter. And this is its main difference from singleton which is not writable.

---

^ This pattern may be used only for truly universal dependencies that represent some cross-cutting concerns such as logging, analytics, accessing time and dates.

# Cross-cutting concerns

- logging
- analytics
- time/date
- etc.

---

^ Ambient context has its own advantages. It makes dependency always accessible and does not pollute API. But most of the time it does not justify its disadvantages. It makes dependency implicit and it represents a global mutable state which is maybe not what you want. So first we should consider using other DI patterns and use ambient context as a last resort.

### Pros:

- does not pollute API
- dependency always available

### Cons:

- implicit dependency
- global mutable state

---

# Separation of concerns

- what concrete implementations to use
- configure dependencies
- manage dependencies' lifetime

^ As you may notice all these patterns are very simple and they share one common principle - separation of concerns.

^ We remove several responsibilities from the consumer of dependency: what concrete implementation to use, how to configure it and how to manage its lifetime.

^ This lets us easily substitute dependency in different context or in tests, change its lifetime strategy, for instance use shared or separate instances, or to change the way how the dependency is constructed. All without changing its consumers. 

^ That makes consumers decoupled with their dependencies, making them easier to reuse, extend, develop and test.

---

## Where dependencies are created?

^ The obvious side effect of these patterns is that now every user of our code needs to provide its dependecies. But how do they get them? 

^ If they create them directly then they become tightly coupled with those dependencies. So we just move the problem to another place.

---

## Composition root

^ That problem brings us to much less discussed DI pattern called Composition Root. 

^ Composition Root is a place where components from different layers of the application are wired together. The main point of having composition root is to separate configuration logic from the rest of our code, do it in a well defined place in a common manner. Having a piece of code which single responsibility is to configure other components. 

^ Creating dependencies and injecting them in constructors or properties should be done only in the Composition Root.

---
![inline](Assets/export-1.png)

^ Ideally there should be one Composition Root in the application and it should be close to application entry point. Like on this diagram.

^ But it does not have to be implemented with a single method or a class. It can contain as many classes and methods as needed until they stay together at the same layer of components.

---

## VIPER example

^ Here is for example implementation of Composition Root from VIPER example application:

```swift
class AppDependencies {
    init() {
        configureDependencies()
    }
    
	func configureDependencies() {
	    // Root Level Classes
	    let coreDataStore = CoreDataStore()
	    let clock = DeviceClock()
	    let rootWireframe = RootWireframe()
	    
	    // List Module Classes
	    let listPresenter = ListPresenter()
	    let listDataManager = ListDataManager()
	    let listInteractor = ListInteractor(dataManager: listDataManager, clock: clock)
		...    
	    listInteractor.output = listPresenter
	    listPresenter.listInteractor = listInteractor
	    listPresenter.listWireframe = listWireframe
	    listWireframe.addWireframe = addWireframe
	    ...
	}
}
``` 

^ Here we have some root classes, root wireframe that only manages window root view controller and some separate components for some list of todo items, like presenter, interactor, wireframe. Then we just wire them all together. And it is all implemented in one class.

---

## VIPER example

^ And the only place where we use this class is the app delegate:

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let appDependencies = AppDependencies()

    func application(
    	application: UIApplication, 
    	didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        appDependencies.installRootViewControllerIntoWindow(window!)
        
        return true
    }
}
```

^ Here we first create dependencies class which will configure all of the components and wire them together. Then we just call a method that sets root view controller in a window. 

^ So the entire objects graph will be created here with a single call and the only objects which will be created later in runtime are view controllers and views.

---

^ Unfortunately Composition Root is usually not discussed in articles or talks about DI. But it is probably one of the most important parts of Dependency Injection. 

^ Getting all classes with dependencies moved to Composition Root is the biggest challenge of properly implementing DI. Especially in a large code base.

> The biggest challenge of properly implementing DI is getting all classes with dependencies moved to Composition Root
> -- Mark Seeman

^ If we manage to do that we have already come a long way.

---

# Anti-patterns

^ But as it often happens while we are trying to properly implement some patterns we can easily end up with anti-patterns.

^ So, now let's move on to the dark side and see what are the common DI anti-patterns.

---

## Control freak

^ The first one is control freak. That is simply when we don't use DI at all. When consumer of dependency controls how and when the dependency is created. It happens every time when consumer gets a dependency directly or indirectly using constructor anywhere outside Composition Root. For example in its own constructor or just when it needs it.

```swift
class RecipesService {

    let repository: RecipesRepository
    
    init() {
        self.repository = CoreDataRecipesRepository()
    }
}

```

---

## ~~`init()`~~

^ But does that mean that we are not allowed to use constructors at all? Of course not. It depends on what kind of dependency we construct. 

---

## Stable 
## Volatile

^ There are two kinds of them - stable and volatile. When it comes to stable dependencies we should not worry about constructing them directly inside their consumer. But we should avoid doing that for volatile dependencies.

---

## Volatile dependencies

^ What is a volatile dependency? Any dependency that requires some specific environment setup, like database or network access. Dependencies that implement nondeterministic behavior are volatile, for example if they use random numbers, depend on time or implement cryptography. When we expect dependency to be replaced or it is simply not ready yet because it is developed in parallel - it is also volatile.

- dependency requires environment configuration (data base, networking, file system)
- nondeterministic behavior (dates, cryptography)
- expected to be replaced
- dependency is still in development

---

## Volatile dependencies disable loose coupling

^ The symptom of volatile dependencies is that they disable some of loose coupling benefits. If dependency does not let us test, extend, reuse or develop our code in parallel - it should be considered as volatile. Otherwise it is a stable dependency.

^ So first of all we need to understand if the dependency is volatile or stable and inject it with Dependency Injection patterns when it is volatile.

---

# Bastard injection

^ The next anti-pattern is called Bastard injection. That happens when we have constructor that lets us provide dependencies for tests and another constructor with default implementations used in production. 

^ In Swift we can do that easily with default arguments like in the following example.

```swift
class RecipesService {

    let repository: RecipesRepository
    
    init(repository: RecipesRepository = CoreDataRecipesRepository()) {
        self.repository = repository
    }
}

```
---

## Foreign default

^ From one point this pattern improves testability. The problem of this anti-pattern is in using as a default a foreign default - defined in other module. That makes our code testable, but tightly coupled with another module.

^ If default implementation is local the impact of this anti-pattern is much smaller. Maybe it will be better to refactor it to property injection instead. 

^ But when default implementation is foreign we should use constructor injection and do not provide default value for this argument. Instead we should provide it in the Composition Root. This way we don't loose any flexibility but avoid tight coupling with another module.

---

# Service locator

^ The last anti-pattern I will talk about is a Service Locator.

^ Service Locator is a common name for some service that we can query for different objects that were previously registered in it. 

^ It is the most tricky anti-pattern because it can make us feel that everything is absolutely fine. Many developers do not even consider it as an anti-pattern at all. But Service Locator is in fact opposite to Dependency injection.

^ Let's look at an example:

```swift
let locator = ServiceLocator.sharedInstance

locator.register( { CoreDataRecipesRepository() }, 
				 	forType: RecipesRepository.self)

class RecipesService {

    let repository: RecipesRepository
    
	init() {
		let locator = ServiceLocator.sharedInstance
		self.repository = locator.resolve(RecipesRepository.self)
    }
}

```

^ In this example we have some service that we can access using static property. Then for the type of our dependency we register a factory that produces some concrete instance. 

^ Then we ask this service for our dependency when we need it instead of using constructor or property injection.

---

^ It seems like Service Locator provides all the benefits of Dependency Injection. It improves extensibility and testability because we can register another implementation of dependency without changing its consumer. It separates configuration from usage and also enables parallel development. 

Pros:

- Extensibility
- Testability
- Parallel development
- Separation of concerns

---

Cons:

- Implicit dependencies
- Hidden complexity
- Tight coupling
- Not reusable
- Less maintainable

^ But it has few major drawbacks. It makes dependencies implicit instead of explicit what hides real class complexity. To be able to use this class we now need to know its internal details. 

^ We don't see its dependencies and will find out about them only at runtime or by inspecting its implementation or documentation. 

^ Also with service locator our code becomes tightly coupled with it. That completely breaks reusability and makes code less maintainable. 

^ For these reasons I tend to think that Service Locator is an anti-pattern.

^ Instead of using it we should define dependencies explicitly, use DI patterns to inject them and use Composition Root to wire them together.

---

- DI enables loose coupling
- 4 patterns, prefer constructor injection
- Use local defaults, not foreign
- Inject volatile dependencies, not stable
- Avoid anti-patterns

^ So lets sum up what we have discussed by that point. We discussed that Dependency Injection is used to enable loose coupling what makes our code easier to maintain. 

^ We discussed different DI patterns among which constructor injection should be a preferred choice. 

^ We discussed what are local and foreign dependencies and what are stable and volatile dependencies. 

^ Also we discussed what are common DI anti-patterns that we should avoid.

---

## Explicit dependencies
## Composition root

^ At this point using DI patterns we've made our dependencies explicit and moved all the configurations in the Composition Root which is already a huge step forward to our goal - loose coupling.

---

## Second step - abstractions

^ But our code is not yet loosely coupled. The next big step for that is to model dependencies with abstractions. For that we will need to remember one of the SOLID principles.

--- 

## Dependency Inversion Principle (DIP)

^ Dependency Inversion Principle. It says that high-level code should not depend on lower-level code, they both should depend on abstractions and abstractions should not depend on details.

---

^ The point is that the class and its dependency should be on the same level of abstraction. If we have some service it should not depend on concrete API repository or data base repository because they belong to lower level layer. 

^ For example we should not depend on API repository implemented with Alamofire or data base repository implemented with CoreData or Realm. Because this will make our code tightly coupled with specific implementation.

![inline 100%](Assets/export-5.png) 

## :thumbsdown:

---

^ Instead we should depend on a higher level abstraction. Both service and repository should depend on that abstraction. So the direction of dependency between higher and lower levels is inverted.

![inline 100%](Assets/export-6.png)

## :thumbsup:

---

^ And we should follow this principle to have loosely coupled code. 

^ Dependency Injection is not just patterns that we discussed before. It requires both patterns and Dependency Inversion Principle to be applied at the same time. 

^ Without that we will not get all the benefits of loose coupling.

##[fit] DI = DI patterns + DIP

---

^ It is commonly said that loose coupling is achieved by programming against interfaces and not to implementations.

> Program to an interface, not an implementation
> -- Design Patterns: Elements of Reusable Object-Oriented Software

---

## Program to an ~~interface~~ abstraction

^ But Dependency Inversion Principle says that it is not about interfaces, but about abstractions. Loose coupling does not mean interfaces or protocols everywhere. Because not always interfaces are good and reusable abstractions.

---

^ Interface (or a protocol) is just a language construct that we can use to model abstraction. It is a way how our code communicates with it. 

^ But it does not make any guarantee for a good and reusable abstraction which is a key to loose coupling.

^ Base class can be sometimes as good abstractions as a protocol. But of course most of the time we probably will use protocols to model abstractions. 

^ But be careful with introducing protocols everywhere. It can be unneeded level of indirection. And in Swift protocols might bite sometimes.

## Interfaces are not abstractions [^1]

![inline](Assets/image_5.png)

[^1]: [http://blog.ploeh.dk/2010/12/02/Interfacesarenotabstractions/](http://blog.ploeh.dk/2010/12/02/Interfacesarenotabstractions/)

---

##[fit] DI = DI patterns + DIP

^ So Dependency Injection and Loose Coupling is achieved not just with Dependency Injection Patterns but also with Dependency Inversion Principle and modeling dependencies with abstractions. 

^ But there is also one more step that we can make using another design principle.

---

## Third step -
## Inversion of Control

^ This principle is called Inversion of Control. It is often seen as a defining characteristic of frameworks. 

^ When we use libraries the flow is "normal" and we call library from our code. But in case of frameworks it is inverted - framework calls our code using different callback methods. 

^ And we can apply this principle for managing dependencies using special frameworks.

---

## DI Containers
![](Assets/containers.jpg)

^ Usually these frameworks are called Dependency Injection Containers.

^ There are bunch of different containers available. Maybe even too many of them already. Just go to CocoaPods and search for "dependency injection". You will find a lot of different frameworks but you will notice that only few of them succeeded and became relatively popular.

---

## Typhoon
## Dip

^ Let's shortly look at two of them - one that comes from Objective-C world and one from Swift. Typhoon and Dip. 

---

## Typhoon

[http://typhoonframework.org](http://typhoonframework.org)

![](Assets/typhoon.jpg)

^ First one, Typhoon, is probably the most popular DI container among Cocoa developers.

<br>

- a lot of features
- good docs
- well maintained
- continuously improved

^ It has relatively simple and well documented API with lots of powerful features. It is well maintained and supported and still continues to improve.

---

^ In terms of API Typhoon building blocks are objects called assemblies. Here is an example of such assembly interface. It looks like a simple factory.

```swift
public class APIClientAssembly: TyphoonAssembly {
    
    public dynamic func apiClient() -> AnyObject { 
	    ... 
    }
    
    public dynamic func session() -> AnyObject { 
	    ... 
    }
    
    public dynamic func logger() -> AnyObject { 
	    ... 
    }
    
}
```

---

^ But in implementation instead of returning a concrete instance of some type like from factory method we return a `TyphoonDefinition` that describes how that instance should be created when it is requested. What initializer should be used and with what parameters, what properties should be injected. Here we define that `APIClient` will be created with `init(session:)` constructor and that it's session argument will be provided by the same assembly. Also we define that when  logger property will be injected with a logger instance also provided by the same assembly.

```swift
public dynamic func apiClient() -> AnyObject {
    return TyphoonDefinition.withClass(APIClientImp.self) { definition in
        
        definition.useInitializer(#selector(APIClientImp.init(session:))) {
            initializer in
            
            initializer.injectParameterWith(self.session())
        }
        
        definition.injectProperty("logger", with: self.logger())
    }
}
```
---

^ We can also define different scopes or lifetime strategies for components. For example with Singleton scope Typhoon will create only one instance of logger.

```swift
public dynamic func session() -> AnyObject {
    return TyphoonDefinition.withClass(NSURLSession.self) { definition in
        definition.useInitializer(#selector(NSURLSession.sharedSession))
    }
}
    
public dynamic func logger() -> AnyObject {
    return TyphoonDefinition.withClass(ConsoleLogger.self) { definition in
        definition.scope = .Singleton
    }
}

```
---

^ To get an instance of some type from assembly we first activate it and then just call its interface method. When activated assembly methods will return not `TyphoonDefinition`s but instances, created based on the rules that we provided.

```swift
let assembly = APIClientAssembly().activate()

let apiClient = assembly.apiClient() as! APIClient
```

---

## Typhoon + Swift 🤔

^ To make this work Typhoon uses Objective-C runtime a lot. And in Swift applications using Objective-C runtime looks just not right.

^ We still can use Typhoon in Swift as well as in Objective-C. But there are some problems we will face with:

- Requires to subclass NSObject and define protocols with `@objc`
- Methods called during injection should be `dynamic`
- requires type casting
- not all features work in Swift
- too wordy API for Swift

^ So I personally would not use Typhoon in its current state in a pure Swift code base. Especially when there are already few native solutions.

---

## Dip

[https://github.com/AliSoftware/Dip](https://github.com/AliSoftware/Dip)

^ And Dip is one of them. It works only in Swift and it does not require Objective-C runtime at all. In fact it even does not have any references to Foundation, so we can use it on any platform where we can use Swift. It is also type-safe and implementation is not that complicated comparing with Typhoon. 

<br>

- pure Swift api
- cross-platform
- type-safe
- small code base

^ In terms of API it takes approach that is more traditional for DI containers on other platforms and follows "register-resolve" pattern.

---

## Register

^ Here is the same example that we used for Typhoon. First we register `APIClientImp` as implementation of `APIClient` protocol. Container will also resolve contsructor argument and when instance is created will set its `logger` property which will be resolved as a singleton instance.

```swift
let container = DependencyContainer()

container.register { 
	try APIClientImp(session: container.resolve()) as APIClient 
}
.resolveDependencies { container, client in
	client.logger = try container.resolve()
}

container.register { NSURLSession.sharedSession() as NetworkSession }
container.register(.Singleton) { ConsoleLogger() as Logger }

```
---

## Resolve

^ Then when we need to get the instance of APIClient we simply call `resolve` method of the container:

```swift
let apiClient = try! container.resolve() as APIClient
```

^ You may notice that the API is almost the same as we saw in Service Locator. But it is not about API, it is about how we use it. If you don't want to use container as a Service Locator remember that you should call it only in the Composition Root.

---

## Auto-wiring

^ Dip also provides some cool features like auto-wiring.

^ For example we can define logger property to be automatically injected. Container will first create the instance of `APIClient` and then will use its mirror to find `logger` property and inject the real instance in it.

```swift
class APIClientImp: APIClient {

	private let _logger = Injected<Logger>()
	
	var logger: Logger? { return _logger.value }
	
}
```

---

## Auto-wiring

^ Then when we register `APIClient` using its constructor instead of calling `resolve` to get a `NetworkSession` argument we just say that we want to use a first argument passed to the factory closure. Then container will infer its type and resolve it for us.

```swift
class APIClientImp: APIClient {
	init(session: NetworkSession) { ... }
}

container.register { 
	APIClientImp(session: $0) as APIClient 
}
```

^ And that can simplify configuration a lot.

---

^ If we compare base features of Typhoon and Dip we will notice that they share most of them. It may seem surprising that almost the same features are possible in Swift even though it does not have powerful runtime features like in Objective-C. But generics and type inference are in fact enough for that.

											Typhoon 	Dip 
											
	Constructor, property, method injection    ✔︎ 		 ✔︎
	Lifecycle management    				   ✔︎ 		 ✔︎
	Circular dependencies					   ✔︎ 		 ✔︎
	Runtime arguments						   ✔︎ 		 ✔︎
	Named definitions						   ✔︎ 		 ✔︎
	Storyboards integration					   ✔︎ 		 ✔︎
	-----------------------------------------------------------

	Auto-wiring								   ✔︎ 		 ✔︎
	Thread safety							   ✘		  ✔︎
	Interception							   ✔︎ 		 ✘
	Infrastructure							   ✔︎ 		 ✘
---

# Why should I bother?

^ You may ask why do I need to use Typhoon or Dip or any other DI container when I can do the same by my own. There are few reasons I can suggest:

^ They provide easy integration with storyboards, they mange components lifecycle for you, they can simplify some configurations and Typhoon also provides easy interception using NSProxy.

- easy integration with storyboards
- manage components lifecycle
- can simplify configurations
- allow interception (in Typhoon using NSProxy)
- provides additional features

---

## DI ≠ DI Container

^ But remember that DI containers are optional and Dependency Injection is not the same as using DI container. 

^ In a new project we may start with it if we want, but in a legacy code base we should first refactor it using Dependency Injection Patterns, Composition Root and Dependency Inversion Principle and then see if DI container is needed or not. 

^ If you have complex configurations and you find yourself implementing something like DI container to simplify them or you need some additional features that it provides then probably you will benefit from using already existing implementation. But if you are ok with your own factories - its great and keep using them. Don't use DI container just for the sake of using it.

---

^ In the end I want to mention some useful resources where you can find more about DI and some related topics.

# Links

- ["Dependency Injection in .Net" Mark Seeman](https://www.manning.com/books/dependency-injection-in-dot-net)
- [Mark Seeman's blog](http://blog.ploeh.dk/tags/#Dependency%20Injection-ref)
- [objc.io Issue 15: Testing. Dependency Injection, by Jon Reid](https://www.objc.io/issues/15-testing/dependency-injection/)
- ["DIP in the wild"](http://martinfowler.com/articles/dipInTheWild.html)
- [Non-DI code == spaghetti code?](http://www.loosecouplings.com/2011/02/non-di-code-spaghetti-code.html)

---

# Thank you!

