# Session 106: WatchKit I Challenge

You've learned the interface basics in the demo, and looked at page-based interfaces and contexts with code in the lab. Now it's time to pull it all together!

Right now, the table rows are a little bare with just the session time and title.

![The current project. Wall of text!](./assets/challenge-starter.png)

Your challenge is to update the table row interface to include an icon for the track. You'll find images called Beginner, Intermediate, and Advanced already in the **people.xcassets** asset catalog (in the RWDevCon group) and you can access a session's track with the `session.track.name` property.

The goal is to have the table row look like this:

![Table with icons in the rows](./assets/challenge-table-icons.png)

[Jump ahead to the hints](#hint-1-interface) if you need some help along the way.

## Bonus: Session details image
If you're a smartypants and need an extra task, how about getting the image to show up on the session details page too?

![Track icon on the session details screen](./assets/challenge-session-icon.png)

## Hint 1: Interface

Open **Interface.storyboard** to get started with the WatchKit app interface.

Remember, the table row starts with a group and you add your interface there. Right now, the group is set to vertical layout:

![Vertical layout, two labels](./assets/challenge-layout1.png)

The simplest way to accomplish this would be a layout like this:

![Layout with nested groups](./assets/challenge-layout2.png)

The outer group (in blue) should be set to horizontal layout, and will contain an image and a nested inner group. The inner group (in red) should be set to vertical layout, and will contain the two labels.

## Hint 2: Layout and size

The image will probably be very large by default. Remember what you did to set up the RW logo above the table? Try setting your table row image to a fixed width and height, maybe 30x30.

Also, you should set the inner group's sizing mode to **Size to Fit Content** for best results.

## Hint 3: Outlets

You'll want to set an image to the table row image from code, which means: outlet!

Open the assistant editor and make sure **ScheduleRow.swift** is showing. Control-drag from the image to the class. You might find it easier to control-drag from the document outline rather than directly from the interface.

## Hint 4: Table row code

In the for loop in `showAllSessions()`, you'll need to add some code to set the image outlet in addition to the time and title labels.

Here's one possible implementation. You may need to change the property `image` to whatever you named your outlet.

```swift
if let trackImage = UIImage(named: session.track.name) {
  row.image.setImage(trackImage)
} else {
  row.image.setHidden(true)
}
```
