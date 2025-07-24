VIPER Design Pattern in Swift for iOS Application Development.

What is Viper?
Viper is a design pattern that implements the ‘separation of concern’ paradigm. Mostly like MVP or MVC, it follows a modular approach. One feature, one module. For each module, VIPER has five different classes with distinct roles. No class goes beyond its sole purpose. These classes are following.

View: Class that has all the code to show the app interface to the user and get their responses. Upon receiving a response View alerts the Presenter.
Presenter: Nucleus of a module. It gets user response from the View and works accordingly. The only class to communicate with all the other components. Calls the router for wire-framing, Interactor to fetch data (network calls or local data calls), view to update the UI.
Interactor: Has the business logic of an app. e.g if business logic depends on making network calls then it is Interactor’s responsibility to do so.
Router: Does the wire-framing. Listens from the presenter about which screen to present and executes that.
Entity: Contains plain model classes used by the Interactor.
