package com.example.charitable.domain;

import com.example.charitable.repos.DonationRepo;
import com.example.charitable.repos.RequestRepo;
import org.springframework.format.annotation.NumberFormat;

import javax.persistence.*;
import javax.validation.constraints.*;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.*;

@Entity
@Table(name = "requests")
public class Request {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Size(min = 8, max = 50, message = "Length must be between {min} and {max} characters.")
    private String title;
    @NotBlank(message = "Please choose the category.")
    private String section;

    @DecimalMin(value = "500.0", message = "Required sum must be at least {value}$.")
    @DecimalMax(value = "100000.0", message = "Required sum is too big")
    private double requiredSum;
    private double collectedSum;

    @Size(min = 20, max = 1000, message = "Length must be between {min} and {max} characters.")
    private String description;

    @ManyToOne
    @JoinColumn(name="user_id", nullable=false)
    private User user;

    @OneToMany(mappedBy = "request")
    private Set<Donation> donations;

    //@NotBlank(message = "Choose the country.")
    private String country;
    //@NotBlank(message = "Choose the state.")
    private String state;
    //@NotBlank(message = "Choose the city.")
    private String city;
    private boolean active;
    private Timestamp timestamp;
    private String images;

    @Transient
    private List<String> imageNames;
    @Transient
    private String createdTimeRequest;
    @Transient
    private List<Donation> recentDonate;
    @Transient
    private Map topDonaters;

    public Request() {}
    public Request(String title, String section, String description, double requiredSum, double collectedSum,
                   User user, String country, String city, boolean active, Timestamp timestamp, String images) {

        this.images = images;
        this.title = title;
        this.section = section;
        this.requiredSum = requiredSum;
        this.collectedSum = collectedSum;
        this.description = description;
        this.user = user;
        this.country = country;
        this.city = city;
        this.active = active;
        this.timestamp = timestamp;
    }

    public String getImages() { return images; }

    public void setImages(String images) { this.images = images; }

    public Set<Donation> getDonations() {
        return donations;
    }

    public void setDonations(Set<Donation> donations) {
        this.donations = donations;
    }

    public List<String> getImageNames() {
        return new ArrayList<String>(Arrays.asList(this.images.split("\\s*,\\s*")));
    }

    public void setImageNames(List<String> imageNames) {
        this.imageNames = imageNames;
    }

    public double getCollectedSum() {
        return collectedSum;
    }

    public void setCollectedSum(DonationRepo donationRepo, int safe_id) { // DonationRepo donationRepo
        List<Donation> donationList = donationRepo.findByRequestId(safe_id);
        double colSum = 0;
        for(int i = 0; i < donationList.size(); i++)
        {
            colSum += donationList.get(i).getDonatedSum();
        }
        this.collectedSum = colSum;
    }

    public void setCollectedSum(double collectedSum) {
        this.collectedSum = collectedSum;
    }

    public void setDefaultCollectedSum(double defaultCollectedSum){
        this.collectedSum = defaultCollectedSum;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public double getRequiredSum() {
        return requiredSum;
    }

    public void setRequiredSum(double requiredSum) {
        this.requiredSum = requiredSum;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getCreatedTimeRequest()
    {
        return createdTimeRequest;
    }
    public void setCreatedTimeRequest(RequestRepo requestRepo, int safe_id) {
        String[] month = {"January", "February",
                "March", "April", "May", "June", "July",
                "August", "September", "October", "November",
                "December"};
        Timestamp time = requestRepo.findById(safe_id).getTimestamp();
        String result = month[time.getMonth()] + " " + time.getDate() + ", " +  (time.getYear() + 1900);
        this.createdTimeRequest = result;
    }

    public List<Donation> getRecentDonate() { return recentDonate; }
    public void setRecentDonate(DonationRepo donationRepo, int safe_id)
    {
        List<Donation> donationList = donationRepo.findByRequestId(safe_id);
        Comparator ctime = new ComparatorByTimestampByDonation();
        Collections.sort(donationList, ctime);
        Collections.reverse(donationList);
        this.recentDonate = donationList;
    }

    public Map<User, Double> getTopDonaters() { return topDonaters; }

    public void setTopDonaters(DonationRepo donationRepo, int safe_id)
    {
        List<Donation> donationList = donationRepo.findByRequestId(safe_id);
        Map<User, Double> map = new HashMap<User, Double>();
        Map<User, Donation> map1 = new HashMap<User, Donation>();
        for(int i = 0; i < donationList.size(); i++)
        {
            if (map.containsKey(donationList.get(i).getUser())){
                map.put(donationList.get(i).getUser(), map.get(donationList.get(i).getUser()) + donationList.get(i).getDonatedSum());
            }
            else
                map.put(donationList.get(i).getUser(), donationList.get(i).getDonatedSum());
        }

        ValueComparator bvc = new ValueComparator(map);
        TreeMap<User, Double> sorted_list = new TreeMap<User, Double>(bvc);
        sorted_list.putAll(map);
        this.topDonaters = sorted_list;

    }

    @Override
    public String toString() {
        return "Request{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", section='" + section + '\'' +
                ", requiredSum=" + requiredSum +
                ", collectedSum=" + collectedSum +
                ", description='" + description + '\'' +
                ", user=" + user +
                ", donations=" + donations +
                ", country='" + country + '\'' +
                ", city='" + city + '\'' +
                ", active=" + active +
                ", timestamp=" + timestamp +
                ", imageNames=" + imageNames +
                '}';
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public static class ComparatorByPercentProgress implements Comparator<Request> {
        @Override
        public int compare(Request o1, Request o2) {
            double res = (o2.collectedSum / o2.requiredSum)*100 - (o1.collectedSum / o1.requiredSum)*100;

            if(res == 0){return 0;}
            return res > 0 ? 1: -1;
        }
    }

    public static class ComparatorByTimestamp implements Comparator<Request> {
        @Override
        public int compare(Request o1, Request o2) {
            long time1 = o1.getTimestamp().getTime();
            long time2 = o2.getTimestamp().getTime();
            return Long.compare(time2, time1);
        }
    }

    // test
    public static class ComparatorByTimestampByDonation implements Comparator<Donation> {
        @Override
        public int compare(Donation o1, Donation o2) {
            long time1 = o1.getTimestamp().getTime();
            long time2 = o2.getTimestamp().getTime();
            return Long.compare(time1, time2);
        }
    }

    public static class ValueComparator implements Comparator<User>
    {
        Map<User, Double> base;

        public ValueComparator(Map<User, Double> base) {
            this.base = base;
        }
        public int compare(User a, User b) {
            if (base.get(a) >= base.get(b)) {
                return -1;
            } else {
                return 1;
            }
        }
    }

    public static class ComparatorByLeftToCollect implements Comparator<Request> {
        @Override
        public int compare(Request o1, Request o2) {
            double left1 = o1.getRequiredSum() - o1.getCollectedSum();
            double left2 = o2.getRequiredSum() - o2.getCollectedSum();
            return -Double.compare(left2, left1);
        }
    }

    public static class ComparatorByMostPopular implements Comparator<Request> {
        @Override
        public int compare(Request o1, Request o2) {
            int donations1 = o1.getDonations().size();
            int donations2 = o2.getDonations().size();
            return donations2 - donations1;
        }
    }
    public void addToSum(Donation donation){
        this.collectedSum += donation.getDonatedSum();
    }

    public String getTimestampString(){
        Timestamp time = getTimestamp();
        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        if (currentTime.getYear() - time.getYear() > 0) {
            if (currentTime.getYear() - time.getYear() != 1) {
                return (currentTime.getYear() - time.getYear()) + " years ago";
            } else {
                return "1 year ago";
            }
        } else {
            if (currentTime.getMonth() - time.getMonth() > 0) {
                if (currentTime.getMonth() - time.getMonth() != 1) {
                    return (currentTime.getMonth() - time.getMonth()) + " months ago";
                } else {
                    return "1 month ago";
                }
            } else {
                long noOfDaysBetween = (currentTime.getTime() - time.getTime()) / 86400000;
                if (noOfDaysBetween > 1) {
                    return noOfDaysBetween + " days ago";
                } else if (noOfDaysBetween == 1) {
                    return "1 day ago";
                } else {
                    return "today";
                }
            }
        }
    }
}
