package com.example.charitable.domain;

import org.springframework.security.core.GrantedAuthority;

public enum Role implements GrantedAuthority {
    PHILANTHROPIST, HELP_SEEKER;

    @Override
    public String getAuthority() {
        return name();
    }
}
