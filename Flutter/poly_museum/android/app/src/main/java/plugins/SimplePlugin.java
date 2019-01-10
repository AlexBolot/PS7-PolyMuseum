/*.........................................................................
 . Copyright (c)
 .
 . The TestClass class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoBooth project
 .
 . Last modified : 1/9/19 4:11 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 ........................................................................*/

package plugins;

import java.util.UUID;

public class SimplePlugin {

    public String getMessage(){
        return UUID.randomUUID().toString().substring(0,7);
    }
}
