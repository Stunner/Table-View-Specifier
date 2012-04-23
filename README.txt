Specified Table View is an iOS table view that has its contents specified
via a plist file. Its purpose is largely demonstrative but is also designed 
to be used in a live product (useful for credits pages). Can be used with
iOS version 4.2 and above.

How it works:

The plist must have its outermost element be an array. This array holds 
dictionaries that may have the following keys:

-Section Header
-Items
-View Title
-View Contents

The "Section Header" key denotes the title of the table view section and 
specifies where table sections exist. The "View Title" key specifies where 
a cell that will present a new table view is to be located.

The value of the "Section Header" key is a string that specifies the name
of the section of the table view. The value of the "View Title" key is a
string that specifies the name of the new table view and the cell that 
leads to it.

The "Items" key must follow the "Section Header" key and maps to an array
of dictionaries that contain kay/value pairs that are strings which depict 
individual cell contents

The "View Contents" key maps to an array which behaves like the outermost
array which allows this recursive fashion to allow for views to be 
specified within themselves.

Please consult the Credits.plist file for an example.

Contact:

Github username: Stunner
email: technetix@gmail.com