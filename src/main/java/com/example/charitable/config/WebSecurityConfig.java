package com.example.charitable.config;

import com.example.charitable.component.CustomAuthenticationProvider;
import com.example.charitable.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    final CustomAuthenticationProvider customAuthProvider;

    public WebSecurityConfig(CustomAuthenticationProvider customAuthProvider) {
        this.customAuthProvider = customAuthProvider;
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http.authorizeRequests()
                // Донати доступні і для анонімних користувачів: сторінка оплати, callback LiqPay
                // (server_url), повернення з LiqPay (result_url) та сторінка помилки донату
                .antMatchers("/get-transaction-status","/payment","/payment/**","/donation-successful",
                        "/donation-successful/**","/donation-error","/main","/requests","/request/**","/request","/registration",
                        "/css/**", "/js/**", "/img/**","/fonts/**","/icons/**","/uploadingDir/**","/profile/**","/profile/achievements/**",
                        "/request/donations/**","/requests/filter","/main/donation-successful/**").permitAll()
                .anyRequest().authenticated()
                .and()
                    .formLogin()
                    .loginPage("/login")
                    .failureUrl("/login-error")
                    .defaultSuccessUrl("/main", true)
                    .permitAll()
                .and()
                    .logout()
                    .permitAll()
                .and()
                    // CSRF вимкнений глобально (у т.ч. для POST-callback від LiqPay на /get-transaction-status,
                    // який не може передати CSRF-токен). Якщо колись CSRF увімкнуть — залиште
                    // .csrf().ignoringAntMatchers("/get-transaction-status")
                    .csrf().disable();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(customAuthProvider).
                inMemoryAuthentication();
        //passwordEncoder(new BCryptPasswordEncoder());

                /*jdbcAuthentication()
                .dataSource(dataSource)
                .passwordEncoder(NoOpPasswordEncoder.getInstance())
                .usersByUsernameQuery("select username, password, active from user where username=?")
                .authoritiesByUsernameQuery("select u.username, ur.roles from user u inner join user_role ur on u.id =" +
                        "ur.user_id where u.username=?");*/
    }


}