package com.example.charitable.domain;

public enum Achievement {
    TENDONATION("tendonation","20.jpg"),
    FIVEDONATION("fivedonation","5.jpg"),
    FIRSTDONATION("firstdonation","4.jpg"),
    FIRSTHELP("firsthelp","17.jpg"),
    FIVEHELPS("fivehelps","18.jpg"),
    TENHELPS("tenhelps","19.jpg"),
    TOPDAY("topday","6.jpg"),
    TOPWEEK("topweek","7.jpg"),
    TOPMONTH("topmonth","8.jpg"),
    ONETHOUSAND("onethousand","2.jpg"),
    TENTHOUSAND("tenthousand","3.jpg"),
    ANIMAL("animal","9.jpg"),
    EDUCATION("education","13.jpg"),
    HEALTH("health","14.jpg"),
    ENVIRONMENT("environment","11.jpg"),
    MILITARY("military","21.jpg"),
    HUNGER("hunger","12.jpg"),
    LOCALHERO("localhero","15.jpg"),
    GLOBALHERO("globalhero","16.jpg");

    private final String className;
    private final String src;

    //have ability to sort coolest
    //private final String priority;

    Achievement(String className, String src){
        this.className = className;
        this.src = src;
    }

    public String getClassName() {
        return className;
    }
    public String getSrc(){ return src; }

}
