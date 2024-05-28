package com.example.charitable.domain;

import com.example.charitable.repos.DonationRepo;
import com.example.charitable.repos.RequestRepo;
import com.example.charitable.repos.UserRepo;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import java.sql.Array;
import java.sql.Timestamp;
import java.util.*;


@Entity
@Table(name = "users")
public class User implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Email(message = "Not valid.")
    @NotBlank(message = "Field is required.")
    private String username; //email

    @Pattern(regexp = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$", message = "Not valid.")
    @NotBlank(message = "")
    private String firstName;

    @Pattern(regexp = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$", message = "Not valid.")
    @NotBlank(message = "")
    private String surname;

    /*@Size(
            min = 8,
            max = 20,
            message = "Length must be between {min} and {max}.")
    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,20}$", message = "Not valid.")
    @NotBlank(message = "Empty Field!")*/
    private String password;

    @OneToMany(mappedBy = "user")
    private List<Request> requests;
    @Transient
    private double totalDonations = 0;
    @Transient
    private double todayDonations = 0;
    @Transient
    private double monthDonations = 0;
    @Transient
    private double weekDonations = 0;
    @Transient
    public double[] donationsByMonths = new double[12];

    @ElementCollection(targetClass = Achievement.class, fetch = FetchType.EAGER)
    @CollectionTable(name = "user_achievements", joinColumns = @JoinColumn(name = "user_id"))
    @Enumerated(EnumType.STRING)
    private Set<Achievement> achievements;

    private boolean active;
    private String avatar;
    private String country;
    private String state;
    private String city;
    private Timestamp timestamp;

    @ElementCollection(targetClass = Role.class, fetch = FetchType.EAGER)
    @CollectionTable(name = "user_role", joinColumns = @JoinColumn(name = "user_id"))
    @Enumerated(EnumType.STRING)
    private Set<Role> roles;

    public Set<Achievement> getAchievements() {
        return achievements;
    }

    public void setAchievements(Set<Achievement> achievements) {
        this.achievements = achievements;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return isActive();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return getRoles();
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    @Override
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Set<Role> getRoles() {
        return roles;
    }

    public void setRoles(Set<Role> roles) { this.roles = roles; }

    public List<Request> getRequests() {
        return requests;
    }

    public void setRequests(List<Request> requests) {
        this.requests = requests;
    }

    private void setTotalDonations(DonationRepo donationRepo)
    {
        List<Donation> donationList = donationRepo.findAllByUserId(this.id);
        for(int i = 0; i < donationList.size(); i++)
        {
            this.totalDonations += donationList.get(i).getDonatedSum();
        }

    }


    private void setWeekDonations(DonationRepo donationRepo)
    {
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        timestamp.setDate(timestamp.getDate() - 7);
        List<Donation> donationList = donationRepo.findAllByUserIdAndTimestampAfter(this.id, timestamp);
        for(int i = 0; i < donationList.size(); i++)
        {
            this.weekDonations += donationList.get(i).getDonatedSum();
        }
    }

    private void setTodayDonations(DonationRepo donationRepo)
    {
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        timestamp.setDate(timestamp.getDate() - 1);
        List<Donation> donationList =donationRepo.findAllByUserIdAndTimestampAfter(this.id, timestamp);
        for(int i = 0; i < donationList.size(); i++)
        {
            this.todayDonations += donationList.get(i).getDonatedSum();
        }
    }
    private void setMonthDonations(DonationRepo donationRepo)
    {
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        timestamp.setMonth(timestamp.getMonth() - 1);
        List<Donation> donationList = donationRepo.findAllByUserIdAndTimestampAfter(this.id, timestamp);
        for(int i = 0; i < donationList.size(); i++)
        {
            this.monthDonations += donationList.get(i).getDonatedSum();
        }
    }
    private void setDonationsByMonths(DonationRepo donationRepo) // МАКСИМАЛЬНО ЕБАНУТЫЙ АЛГОРИТМ, НО ИДИТЕ НАХУЙ 3 ЧАСА НОЧИ ЕБАНЫЕ СУНДУКИ
    {
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        Timestamp tmp = new Timestamp(System.currentTimeMillis());
        int currentMonth = timestamp.getMonth();

        for(int i = 0; i < 12; i++)
            this.donationsByMonths[i] = 0;

       for(int i = 0; i < currentMonth; i++)
       {
           timestamp.setMonth(i);
           timestamp.setDate(1);
           timestamp.setHours(0);
           timestamp.setMinutes(0);
           timestamp.setSeconds(0);
           tmp.setTime(timestamp.getTime());
           tmp.setMonth(tmp.getMonth()+1);
           tmp.setSeconds(tmp.getSeconds()-1);

           List<Donation> donationList = donationRepo.findAllByUserIdAndTimestampAfterAndTimestampBefore(this.id, timestamp, tmp);

           int size = donationList.size();

           for(int j = 0; j < size; j++)
               this.donationsByMonths[i] += donationList.get(j).getDonatedSum();
       }
    }

    public void setDonations(DonationRepo donationRepo)
    {
        setMonthDonations(donationRepo);
        setTodayDonations(donationRepo);
        setTotalDonations(donationRepo);
        setWeekDonations(donationRepo);
        setDonationsByMonths(donationRepo);
    }
    public double getMonthDonations() {
        return monthDonations;
    }

    public double getTodayDonations() {
        return todayDonations;
    }

    public double getTotalDonations() {
        return totalDonations;
    }

    public double getWeekDonations() {
        return weekDonations;
    }

    public int getDonationsByMonths(int i)
    {
        return (int)(donationsByMonths[i]);
    }
    public String getRole()
    {
        return roles.toString();
    }


    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public void setRequests(RequestRepo requestRepo)
    {
        this.requests = requestRepo.findAllByUserId(this.id);
        Collections.sort(requests, new Comparator<Request>()
        {
            public int compare(Request o1, Request o2)
            {
                if (o1.getTimestamp() == null || o2.getTimestamp() == null)
                    return 0;
                return o1.getTimestamp().compareTo(o2.getTimestamp());
            }
        });
    }
    public List<Achievement> setNewAchievements(DonationRepo donationRepo, Donation currDon){
        List<Achievement> obtainedAch = new ArrayList<>();

        //donation in your city (local hero)
        if(!this.achievements.contains(Achievement.LOCALHERO)) {
            if (currDon.getRequest().getCity().equals(currDon.getRequest().getUser().getCity())) {
                obtainedAch.add(Achievement.LOCALHERO);
                this.achievements.add(Achievement.LOCALHERO);
            }
        }
        if(!this.achievements.contains(Achievement.ANIMAL)) {
            if (currDon.getRequest().getSection().equals("Animals")) {
                obtainedAch.add(Achievement.ANIMAL);
                this.achievements.add(Achievement.ANIMAL);
            }
        }
        if(!this.achievements.contains(Achievement.DISASTER)) {
            // check
            if (currDon.getRequest().getSection().equals("Military")) {
                obtainedAch.add(Achievement.DISASTER);
                this.achievements.add(Achievement.DISASTER);
            }
        }
        if(!this.achievements.contains(Achievement.HUNGER)) {
            if (currDon.getRequest().getSection().equals("Hunger")) {
                obtainedAch.add(Achievement.HUNGER);
                this.achievements.add(Achievement.HUNGER);
            }
        }
        if(!this.achievements.contains(Achievement.ENVIRONMENT)) {
            if (currDon.getRequest().getSection().equals("Environment")) {
                obtainedAch.add(Achievement.ENVIRONMENT);
                this.achievements.add(Achievement.ENVIRONMENT);
            }
        }
        if(!this.achievements.contains(Achievement.HEALTH)) {
            if (currDon.getRequest().getSection().equals("Health")) {
                obtainedAch.add(Achievement.HEALTH);
                this.achievements.add(Achievement.HEALTH);
            }
        }
        if(!this.achievements.contains(Achievement.EDUCATION)) {
            if (currDon.getRequest().getSection().equals("Education")) {
                obtainedAch.add(Achievement.EDUCATION);
                this.achievements.add(Achievement.EDUCATION);
            }
        }
        //first donation
        if(!this.achievements.contains(Achievement.FIRSTDONATION)) {
            if (donationRepo.findAllByUserId(currDon.getUser().getId()).size() >= 1) {
                obtainedAch.add(Achievement.FIRSTDONATION);
                this.achievements.add(Achievement.FIRSTDONATION);
            }
        }
        if(!this.achievements.contains(Achievement.FIVEDONATION)) {
            if (donationRepo.findAllByUserId(currDon.getUser().getId()).size() >= 5) {
                obtainedAch.add(Achievement.FIVEDONATION);
                this.achievements.add(Achievement.FIVEDONATION);
            }
        }
        if(!this.achievements.contains(Achievement.TENDONATION)) {
            if (donationRepo.findAllByUserId(currDon.getUser().getId()).size() >= 10) {
                obtainedAch.add(Achievement.TENDONATION);
                this.achievements.add(Achievement.TENDONATION);
            }
        }
        //count all donated general sum
        double sum = 0;
        for(Donation donation : donationRepo.findAllByUserId(currDon.getUser().getId())){
            sum += donation.getDonatedSum();
        }
        if(!this.achievements.contains(Achievement.ONETHOUSAND)) {
            if (sum >= 1000) {
                obtainedAch.add(Achievement.ONETHOUSAND);
                this.achievements.add(Achievement.ONETHOUSAND);
            }
        }
        if(!this.achievements.contains(Achievement.TENTHOUSAND)) {
            if (sum >= 10000) {
                obtainedAch.add(Achievement.TENTHOUSAND);
                this.achievements.add(Achievement.TENTHOUSAND);
            }
        }

        return obtainedAch;
    }

    public boolean isVerified(){
        return getRoles().contains(Role.HELP_SEEKER);
    }

}
