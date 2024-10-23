package sngine.app.webview;

class SngineConfig {

    /* -- CONFIG VARIABLES -- */

    //complete URL of your Sngine website
    static String Sngine_URL = "https://marina.rechain.network/";

    // OneSignal APP Id
    static String Sngine_ONESIGNAL_APP_ID = "";


    /* -- PERMISSION VARIABLES -- */

    // enable JavaScript for webview
    static boolean SngineApp_JSCRIPT = true;

    // upload file from webview
    static boolean SngineApp_FUPLOAD = true;

    // enable upload from camera for photos
    static boolean SngineApp_CAMUPLOAD = true;

    // incase you want only camera files to upload
    static boolean SngineApp_ONLYCAM = false;

    // upload multiple files in webview
    static boolean SngineApp_MULFILE = true;

    // track GPS locations
    static boolean SngineApp_LOCATION = true;

    // show ratings dialog; auto configured
    // edit method get_rating() for customizations
    static boolean SngineApp_RATINGS = true;

    // pull refresh current url
    static boolean SngineApp_PULLFRESH = true;

    // show progress bar in app
    static boolean SngineApp_PBAR = true;

    // zoom control for webpages view
    static boolean SngineApp_ZOOM = false;

    // save form cache and auto-fill information
    static boolean SngineApp_SFORM = false;

    // whether the loading webpages are offline or online
    static boolean SngineApp_OFFLINE = false;

    // open external url with default browser instead of app webview
    static boolean SngineApp_EXTURL = false;


    /* -- SECURITY VARIABLES -- */

    // verify whether HTTPS port needs certificate verification
    static boolean SngineApp_CERT_VERIFICATION = true;

    //to upload any file type using "*/*"; check file type references for more
    static String Sngine_F_TYPE = "*/*";


    /* -- RATING SYSTEM VARIABLES -- */

    static int ASWR_DAYS = 3;    // after how many days of usage would you like to show the dialoge
    static int ASWR_TIMES = 10;  // overall request launch times being ignored
    static int ASWR_INTERVAL = 2;   // reminding users to rate after days interval
}
