package model;

public class ThongKeTuan {
    private String weekName;
    private String fromDate;
    private String toDate;
    private double value;

    public ThongKeTuan() {
    }

    public ThongKeTuan(String weekName, String fromDate, String toDate, double value) {
        this.weekName = weekName;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.value = value;
    }

    public String getWeekName() {
        return weekName;
    }

    public void setWeekName(String weekName) {
        this.weekName = weekName;
    }

    public String getFromDate() {
        return fromDate;
    }

    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    public String getToDate() {
        return toDate;
    }

    public void setToDate(String toDate) {
        this.toDate = toDate;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }
}