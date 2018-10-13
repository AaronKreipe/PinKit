<pre><code>
    ____    _           _  __  _   _   
   |  _ \  (_)  _ __   | |/ / (_) | |_ 
   | |_) | | | | '_ \  | ' /  | | | __|
   |  __/  | | | | | | | . \  | | | |_ 
   |_|     |_| |_| |_| |_|\_\ |_|  \__|
</pre></code>
PinKit is a super lightweight wrapper around vanilla auto layout for iOS that makes laying out constraints just like doing any other normal math.  If you aren't a fan of overriding operators or learning new ones, then this isn't for you, but if you want to be able to write:

<pre><code>
[myView.topAnchor |=| otherView.topAnchor + 10,\
myView.leadingAnchor |=| otherView.leadingAnchor + 8,\
myView.width |=| otherView.width/2 + 15,\
myView.height |>=| otherView.height * 0.3].activate()
</pre></code>
then this is for you!

 # Q & A
 Q: Do we really need another AutoLayout framework?\
 A: No!  This isn't one either!  It's just an easier way to use what Apple gives us.\
 \
 Q: It's not working!\
 A: Make sure you are setting `translatesAutoresizingMaskIntoConstraints` to `false` on the view you are trying to constrain.  Also try calling `setNeedsLayout()` and`layoutIfNeeded()` on the containing view.\
 \
 Q: It's crashing!\
 A: Your constraints are probably conflicting somehow.  Look for messages in the console.\
 \
 Q: OK, this is much easier for adding constraints, but how do I remove them?\
 A: use `UIView.removeConstraints()` just like you used to, or remove a whole array of constraints with `.deactivate()`.\
 \
 Q: What versions of Swift does PinKit work with?\
 A: It has been tested in Swift 4.1.2, and Swift 4.2, and may work in others.\
\
 Q: What do I have to do when apple renames all of the `.constraint*SystemSpacing*()` functions in Swift 4.2?\
 A: Nothing.🎉  I used conditional compilation flags to support both.\
 \
 Q: Where are all of the blank XCTest files?\
 A: This was built and tested in an iPad playground.  Well there wasn't much to test really, it's all just a bunch of syntactic sugar.\
 \
 Q: Are you crazy?\
 A: Maybe a little🤷‍♂️\
 \
 Q: Do you do this for a living?\
 A: Hopefully I will soon! You can buy [my apps in the iOS AppStore](https://itunes.com/AaronKreipe) to help!\
 \
 Q: Are you using this in your apps?\
 A: Not yet, I prefer to use storyboards, but I use it in my playgrounds.
