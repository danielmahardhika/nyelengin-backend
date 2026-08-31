package com.nyelengin.ledger.repositories;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.nyelengin.ledger.models.Space;

public interface SpaceRepository extends JpaRepository<Space, UUID> {
}
