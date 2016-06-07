package qkit;

import java.lang.String;

import android.os.Environment;
import android.util.Log;

class FileTools
{

    public static String standardPicturePath()
    { 	String ret = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).getAbsolutePath();
    	Log.d("standardPicturePath:", ret);
        return ret;
    }

};

