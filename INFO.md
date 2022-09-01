# Folder Structure:

- **constants**: values and settings used throught the application that won't change at runtime.

- **data_objects**: Forget OOP. These are DTOs without any behaviour.
    - **input**: objects built from data coming from API requests and other sources. Used to introduce type safety in the codebase. All their fields are `final`.

    - **output**: objects built by the user and are sent in API requests and other servers. Used to introduce type safety in the codebase. These objects should have an `empty` constructor with all fields nullable and set methods for using with `onChanged` events from the interface. Use `StatefulWidgets` to instantiate these objects for modifying, so they will be destroyed when leaving their screens. If more complex state is needed, or if the objects need to survive longer through the application, use `Riverpod` `ChangeNotifierProviders` instead.

    - **repository**: this is where `data_objects` are stored, created and modified. They are coupled with `FutureProviders` that cache the computations of their asynchronous calls. Autodispose these values as needed. These are provided through the application with the `Riverpod` library.

- **interface**: abstractions for external sources, such as the filesystem, databases, file picking dialogs, rest APIs, etc. Glorified "utility" classes for interfacing that can be mocked and swapped later.

- **pages**: Flutter `Widgets` that serve as pages for the application. Use subfolders to group widgets that are **strongly coupled** to the page. For pages that have `PageViews`, create a folder for that page + a folder for each `PageView` page inside of it.

- **widgets**: flutter `Widgets` that are reusable through multiple pages of the application. Widgets **MUST NOT** have dependencies on the objects from the other folders. Ideally, they shouldn't have dependencies on other widgets or libraries either.