package qkit;

public class KNative {

    public static void init()
    {

    }

    public native static void onSuspend();
    public native static void onResume();
    public native static void onDestroy();
}

