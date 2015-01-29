# Session 106: WatchKit I Lab

In this lab session, you're going to add a details screen for one session. This screen will appear when you select a session from the table you created during the demo.

## Getting started

Open **Interface.storyboard**. Drag a new interface controller from the object library onto the canvas to start.

![New interface controller](assets/lab-blank.png)

Here's what the finished interface will look like:

![Starter elements](assets/lab-interface.png)

Add the elements you'll need: label, separator, image, and another label.

![Starter elements](assets/lab-elements.png)

It's a start!

Select the top label. It should span the entire width of the screen and the text should be centered. In the attributes inspector, set the label alignment to center. For its size, set the width to **Relative to Container** with a value of 1 and adjustment of 0. This means it will be 100% the width of the container.

Also, change the font style to Headline and set the number of lines to 0 so it will show the complete title.

What about that background color? There's no background color attribute for labels so you'll need to use a group, which does have a settable background. Add a group above the label, then drag the label inside the group. Change the group's background color to a nice dark green. The official RayWenderlich.com green is `#006D37` if you want to be precise!

![Starter elements](assets/lab-label.png)

The rest of the interface is much simpler. Select the image and give it a fixed size of 44x44. Change its horizontal position to **Center**.

The label at the end will show the full description, which can be a long block of text. Set its number of lines to 0 so it will show everything.

That's it for the layout! Next, you'll set up some code and then some outlets to get this interface to be dynamic.

## Interface subclass

Add a new file to the RWDevCon WatchKit Extension target. Make it a plain Swift file called **DetailInterfaceController** and add the following code to the file:

```swift
import WatchKit

class DetailInterfaceController: WKInterfaceController {

}
```

Like the first interface controller with the table, this one inherits from `WKInterfaceController`.

Head back to the storyboard and select the new interface controller. In the identity inspector, set the class to **DetailInterfaceController** and in the attributes inspector, set the identifier to **DetailInterfaceController**.

Setting the class links the interface controller you see in the storyboard to the class you created in the extension. Setting the identifier lets you refer to this controller later on so you can display it when the user selects a table row.

Open the assistant editor and create outlets for the labels and image:

* Top label: **titleLabel**
* Image: **iconImage**
* Bottom label: **descriptionLabel**

That's it for the detail screen. Now you just need to instantiate it and fill in the details!

## Table segues

`WKInterfaceController` has a method you can override if you need to watch for table row selection. This is built right in – you don't need to set a delegate or connect an action or anything!

Open **InterfaceController.swift** and add the following method to the class:

```swift
override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
  let session = sessions[rowIndex]

  presentControllerWithName("DetailInterfaceController", context: session)
}
```

Notice the method arguments include the table itself, in case you have more than one table on screen. You'll get the table and the row index that was tapped.

The first thing you do is get the session details from the `sessions` array.

Next, you're calling `presentControllerWithName()` to show a new interface controller modally. The first argument is the identifier of the controller you set in the storyboard. The second parameter is of type `AnyObject?` so it can be almost anything you like – an array, a dictionary, your own custom object, or `nil`.

If you've used segues in iOS, you know what a pain it can be to pass data across view controllers. Here in WatchKit, the `context` makes that super easy. In this case, you're just passing in the session data.

Passing the session data across is half of the job, but what about receiving the data on the other end?

## Context data

Check out `awakeWithContext()` and you'll notice there's a `context` parameter passed in. That's your opportunity to decode the context data and then set up your interface.

Open **DetailInterfaceController.swift** and add the following method to the class:

```swift
override func awakeWithContext(context: AnyObject?) {
  super.awakeWithContext(context)

  if let session = context as? Session {
    titleLabel.setText(session.title)
    descriptionLabel.setText(session.sessionDescription)
    iconImage.setHidden(true)
  }
}
```

Since the context could be anything, you need to do some optional binding to be safe; that way, you can be certain that you have a `Session` instance.

Then it's easy: just set the title and description based on the session properties. Sessions don't have images, so you can call `setHidden()` on the image so it won't show up. Don't worry – you'll use that image very soon for something else!

Build and run the watch app, and select a session.

![Segue](assets/lab-segue.png)

Success!

## Page count and context

You're calling `presentControllerWithName()` to show another interface modally, but presenting a *page-based interface* modally is almost as easy! The next goal is to show the session details on the first page as you already have it, but to show additional pages for each presenter with their photo and bio.

Most conference sessions have one presenter, but some special entries like Lunch and the registration time don't have a presenter attached. The keynote even has two presenters on record! So you'll need to deal with a variable number here.

Open **InterfaceController.swift** and remove the code from `table(_:didSelectRowAtIndex:)` and start fresh with the following lines:

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

Next, you just call `presentControllerWithNames(_:contexts:)`, which takes an array of controller identifiers and an array of contexts. The idea here is each controller will be displayed in its own page.

You already set up the array of controllers to be one or many "DetailInterfaceController" instances. For the contexts, you just combine the session details with each presenter details. Each page gets its own context information.

Build and run the WatchKit app again, and select the registration session. It should have just one page:

![](assets/lab-page1.png)

Next, select the keynote session; you should see three pages available:

![](assets/lab-page2.png)

Swipe over to the second page and you'll see there's still no information there!

![](assets/lab-page3.png)

You're passing the context data correctly, but the detail controller doesn't know what to do with information about presenters...yet.

## Decoding the context

Open **DetailInterfaceController.swift** and find `awakeWithContext()`. You'll see there's some optional binding to work with `Session` objects, but presenters are `Person` objects.

*Note: If you like, you can open **Person.swift** in the main app project in the Core Data group to see the list of properties available.*

Add the following to the end of `awakeWithContext()`:

```swift
if let person = context as? Person {
  titleLabel.setText(person.fullName)
  descriptionLabel.setText(person.bio)
  if let avatar = UIImage(named: person.identifier) {
    iconImage.setImage(avatar)
  } else {
    iconImage.setHidden(true)
  }
}
```

First, you're making sure only `Person` objects make it through. The title and details label are easy – just set the title to the person's full name, and the details to their bio.

Each speaker has their avatar photo bundled in the asset catalog. If there is a matching UIImage for the person, then you can just display it in the interface. If something went wrong and there is no match, then you just hide the image so it doesn't take up any space.

Build and run the app again, and browse around the sessions! You should see speaker bios and photos on page 2 and beyond. Remember, the Keynote has two speakers so check that out to make sure all three pages are rendered properly!

![](assets/lab-person.png)

Congratulations, you've added a second interface controller and also gotten a multi-page layout working! Notice how the detail controller is flexible enough to show two kinds of data. That works well here, but you can have many different kinds of interface controller in that array so the set of pages is your other apps can be as customized as you like.
