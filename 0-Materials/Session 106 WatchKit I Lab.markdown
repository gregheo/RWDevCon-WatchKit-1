# Session 106: WatchKit I Lab

In this lab session, you're going to expand on the existing detail display when you select a session from the table. Rather than display a single details page, you'll show multiple pages: one for the session details + a page for each presenter.

## Getting started

Open **ScheduleInterfaceController.swift** and look at your current implementation of `table(_:didSelectRowAtIndex:)`. You're calling `presentControllerWithName()` to show another interface modally, but presenting a *page-based interface* modally is almost as easy!

To start, replace the call to `presentControllerWithName()` with the following:

```swift
presentControllerWithNames(
  ["DetailInterfaceController",
   "DetailInterfaceController",
   "DetailInterfaceController"],
  contexts: [session, "", ""])
```

Here, you're asking for *three* separate detail controller instances, grouped together into a set of pages. You can also pass different context information to each controller.

Build and run the WatchKit app and tap on a table row. You'll see the session details along with a page control showing three pages.

![Three pages](assets/lab-3pages.png)

You can swipe to the other pages, but they're empty other than the filler text. But now that you have an idea of how to get mulitple pages in the Watch interface, it's time to get some useful data in there!

## Page count and context

Most conference sessions have one presenter, but some special entries like Lunch and the registration time don't have a presenter attached. The keynote even has two presenters on record! So you'll need to deal with a variable number here.

Remove the code from `table(_:didSelectRowAtIndex:)` and start fresh with the following lines:

```swift
let session = sessions[rowIndex]
let presenters = session.presenters.array
```

This will get the session details and an array of presenters. That means `presenters` could have zero, one, or many more items in the array.

Next, add the following code:

```swift
let controllerNames = Array<String>(count: presenters.count + 1,
  repeatedValue: "DetailInterfaceController")
presentControllerWithNames(controllerNames, contexts: [session] + presenters)
```

You're using a special array constructor to create an array with the string "DetailInterfaceController" repeated. Repeated how many times? The number of presenters plus one – that will cover one page for each presenter (if any) and one page for the session details.

Next, you just call `presentControllerWithNames(_:contexts:)` with the controller names in the array. For the contexts, you just combine the session details with each presenter details. Each page gets its own context information.

Build and run the WatchKit app again, and select the registration session. It should have just one page:

TK screenshot

Next, select a regular session; you should see two pages available:

TK screenshot

However, there's still no information on the second page! You're passing the context data correctly, but the detail controller doesn't know what to do with information about presenters...yet.

## Decoding the context

Open **DetailInterfaceController.swift** and find `awakeWithContext()`. You'll see there's some optional binding to work with `Session` objects, but presenters are `Person` objects.

Note: If you like, you can open **Person.swift** in the main app project to see the list of properties available.

Add the following to the end of `awakeWithContext()`:

```swift
if let person = context as? Person {
  titleLabel.setText(person.fullName)
  detailsLabel.setText(person.bio)
  if let avatar = UIImage(named: person.identifier) {
    image.setImage(avatar)
  } else {
    image.setHidden(true)
  }
}
```

First, you're making sure only `Person` objects make it through. The title and details label are easy – just set the title to the person's full name, and the details to their bio.

Each speaker has their avatar photo bundled in the asset catalog. If there is a matching UIImage for the person, then you can just display it in the interface. If something went wrong and there is no match, then you just hide the image so it doesn't take up any space.

Build and run the app again, and browse around the sessions! You should see speaker bios and photos on page 2 and beyond. Remember, the Keynote has two speakers so check that out to make sure all three pages are rendered properly!

## Where to go from here?
If you've finished early, why not take a peek at the challenge?

Or, if you want *one more thing* to look at here – how about using the navigation stack style interface vs presenting controllers modally?

If you're coming from iOS, you know about `pushViewController` and `UINavigationController` vs `presentViewController`. WatchKit has something similar – you've been using modal presentation so far, since that's the one that works with multiple pages.

Open **ScheduleInterfaceController.swift** and find `table(_:didSelectRowAtIndex:)`. Comment out the call to `presentControllerWithNames` and replace it with the following:

```swift
pushControllerWithName("DetailInterfaceController", context: session)
```

That's very similar to the code you got working in the demo. Build and run, and see if you can spot the difference – in functionality, looks, animation, etc.

When you're done, put the code back to how it was – you'll need the page-based interface in the upcoming challenge!
