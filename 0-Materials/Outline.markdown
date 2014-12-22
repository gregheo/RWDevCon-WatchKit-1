# Outline

The overall plan is to start with a "lite" version of the RWDevCon app.

There will be a WatchKit target already set up, but no interface elements.
During the demo, students will set up two interface controllers with common
elements such as groups, text labels, images, and tables.

The lab is mostly code to introduce a variable page-based interface to the
app. There's also a conditional show/hide of interface elements to demonstrate
how to do that at runtime.

The challenge will pull it all together as the student will update the
interface for the table row to add an image and then add the code to support
the new field.

## Basic outline for the demo

* Set up first interface controller with logo, label, table
* Set up table row – two labels
* Code: table row subclass
* Code: insert table data

* Set up second interface controller as a generic details screen
* Code: second WKInterfaceController subclass
* Code: Segue from table row select and pass context
* Code: Accept context in the second controller

## Outline for the lab

* Pages – add more instances of the details controller for each presenter
* Code: create as many pages as needed (note sessions can have 0-many presenters)
* Code: pass in a Person object as the context
* Code: update details to process the Person object

## Outline for the challenge

Overall goal is to add an image identifying the track to the table row. There are three big steps:

1. Update the interface for the row to add an image. This means a nested group.
2. Link the new image element to an outlet in the row subclass.
3. Update the row data code to load the appropriate image or hide the image element altogether.
