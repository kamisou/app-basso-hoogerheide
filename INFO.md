# Folder Structure:

- **constants**: values used throught the application that won't change at runtime

- **controllers**: As in MVC. They **MUST NOT** have any state. Every user input action that doesn't depend on a `BuildContext` should be put in here. These controllers are provided through the application with the `Riverpod` library.

- **data_objects**:
    - **input**: objects built from data coming from API requests and other sources. Used to introduce type safety in the codebase. All their fields **MUST BE** `final`.

    - **output**: objects built by the user and are sent in API requests and other servers. Used to introduce type safety in the codebase. These objects **MUST HAVE** an `empty` constructor with all fields nullable and set methods for using with `onChanged` events from the interface.

- **repository**: this is where `data_objects` are stored. They are coupled with `FutureProviders` that cache the computations of its asynchronous calls. Autodispose these values as needed. These are provided through the application with the `Riverpod` library.

- **interface**: abstractions for external sources, such as the filesystem, file picking dialogs, rest APIs, etc.

- **pages**: Flutter `Widgets` that serve as pages for the application. Use subfolders to group widgets that are **strongly coupled** to the page. For pages that have `PageViews`, create a folder for that page + a folder for each `PageView` page inside of it.

- **widgets**: flutter `Widgets` that are reusable through multiple pages of the application. Widgets **MUST NOT** have dependencies on the objects from the other folders. Ideally, they shouldn't have dependencies on other widgets or libraries either.