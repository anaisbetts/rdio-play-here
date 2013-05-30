# Rdio Play Here

So. I've got a computer and a phone:

<div>
<img src="http://www.schultzeworks.com/wp-content/uploads/2009/12/407-philco-PC.png" width="300px"style="display:inline; "/>  

<img src="http://cdn2.sbnation.com/entry_photo_images/7697169/htc-one-sense5_large_verge_medium_landscape.jpg" width="300px" style="display:inline;" />
</div>

and since I subscribe to this:

<img src="https://si0.twimg.com/profile_images/2908373120/3ce516ef7b7bccd0520ce890855ab239.png" width="64px" />

I want to listen to the music on the **computer** with the good speakers but control it with the **phone** which doesn't (substitute "phone" with "laptop" at times).

## Doesn't Rdio already do this?

Yes! Rdio lets you remote control an **already playing** Rdio player. But that bold part is the catch: if I want to send music to my desktop computer attached to the nice speakers, I have to remote into it, hit Play, and only *then* can I control the tunes from my phone / laptop.

## Rdio Play Here: Send Rdio to any computer with an open Chrome Browser

Rdio Play Here is a combination of a Chrome Extension (so it works everywhere Automagically™) and a website. Here's a mockup of the website. Super simple: if you click that machine, it sends a message to the browser running on that machine to double-tap the Play button, which will make it the currently playing Rdio, and all of the other open Rdio instances (like on your phone) will become remote controls.

![](http://cl.ly/image/2g161N1g2D2Y/content#png)

## How does it Work??

The Chrome Extension runs a background page which connects via [Socket.io](http://socket.io) to the website and registers that the computer is online and sends it the *hostname* and the *Rdio user account name* (which it gets from injecting soem code into Rdio when the tab is open).

The site maintains the list of open connections and uses it to populate the list of running machines. When you click the machine, it sends a socket.io message to that Chrome background page, which opens a Rdio tab, then signals that tab to simulate clicking the Play button twice, which makes Rdio mark it as the active player.

## Isn't that insecure?

Kind of. There are two things an evil user can do, neither of which are very compelling:

1. Add fake computers to another user's list
1. Trick the server into asking the evil user to open the Rdio tab

Exploit 1 is pretty boring, and since the only thing we send down to client machines is a "Do it" command, the 2nd one isn't particularly interesting either. 

## Yo why don't you just use Airplay?

Because Airplay is terrible.
