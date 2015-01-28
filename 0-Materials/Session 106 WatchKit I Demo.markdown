# Session 106: WatchKit I Demo

In this demo, we'll set up the basics of the WatchKit app extension for the RWDevCon app.

If you fall behind during the live demo, you can catch up with the steps here. Otherwise, there's a completed demo project you can load up after the demo so you can get right into the lab.

## Getting started

**Very very important**: Remember to open the project in Xcode 6.2 beta 4! Right-click the project file, select Open With, and make sure you select the correct version of Xcode.

Feel free to run the app in the simulator to check it out. It's very close to the same app that you can download from the App Store, with some networking things removed.

## Watch app target setup

With the project open in Xcode, navigate to **File \ New \ Target**. Select **iOS \ Apple Watch \ WatchKit App** and click **Next**.

Make sure the language is set to **Swift** and that both **Include Notification Scene** and **Include Glance Screen** are *unchecked*.

![](assets/demo-target.png)

Click **Finish** to continue. If you get an option to activate the scheme, click **Activate**.

## Shared files

There are some shared source files and assets that the Watch app will use. In the RWDevCon group, there are two subgroups **Shared** and **Core Data**.

![Shared files](assets/demo-shared.png)

Select each file in those groups and add them to the **RWDevCon WatchKit Extension** target.

For **shared.xcassets** only, add that file to the **RWDevCon WatchKit App** target too.

## Basic interface

Open **Interface.storyboard** in the **RWDevCon WatchKit App** group.

Add an image and a label to the interface. Set the image to `RW_Logo` with a fixed width and height of 30x30.

Change the label's text to "RWDevCon".

To get the image and text to be side by side, add a group to the interface. Drag the image and label inside the group and set both of their horizontal positions to **Center**. Set the label's vertical position to **Center** too, since the text is shorter than the image.

Next, add a table underneath the image+label group. You'll get a table row with a group included.

## Table row

Add two labels inside the table row group. Change the table row group's layout to **Vertical** so the labels are stacked on top of each other.

![Stacked labels](assets/demo-labels.png)

You'll notice the labels are cut off inside the group. Change the group's height to **Size to Fit Content** so the labels will always fit.

The top label will show the date and time of the session. Set its default text to "Date/Time" and the font to **Subhead**.

The bottom label will show the session title. Set its default text to "Session Title" and the font to **Headline**. Since the session titles can be long, set the number of lines to 0.

## Table row class

Add a new file to the RWDevCon WatchKit Extension group. Make it a **Swift File** called **ScheduleRow**.

Open ScheduleRow.swift and add the following code to the file:

```swift
import WatchKit

class ScheduleRow: NSObject {

}
```

Back in the storyboard, open the assistant editor. Connect an outlet from the table to `InterfaceController` called `scheduleTable`.

Select the table row and open the identity inspector. Set the class to **ScheduleRow**. In the attributes inspector, set the identifier to **ScheduleRow**.

Select one of the labels in the table row and then open **ScheduleRow.swift** in the assistant. Connect the first label to an outlet `timeLabel` and the second label to an outlet `titleLabel`.

## Displaying table data

Open **InterfaceController.swift** and add the following properties to the class:

```swift
lazy var coreDataStack = CoreDataStack()
var sessions = [Session]()
```

Next, add the following helper method to the class:

```swift
func showAllSessions() {
  sessions = Session.allSessionsInContext(coreDataStack.context)

  scheduleTable.setNumberOfRows(sessions.count, withRowType: "ScheduleRow")

  for (index, session) in enumerate(sessions) {
    if let row = scheduleTable.rowControllerAtIndex(index) as? ScheduleRow {
      row.timeLabel.setText(session.startDateTimeShortString)
      row.titleLabel.setText(session.title)
    }
  }
}
```

Finally, call this helper method at the end of awakeFromContext():

```swift
showAllSessions()
```

Build and run, and you should see a nice list of sessions!

![Final build and run](assets/demo-final.png)
