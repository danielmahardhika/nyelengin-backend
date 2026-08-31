package com.nyelengin.ledger.services;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.nyelengin.ledger.models.Space;
import com.nyelengin.ledger.repositories.SpaceRepository;

@Service
public class SpaceService {

    private final SpaceRepository spaceRepository;

    public SpaceService(SpaceRepository spaceRepository) {
        this.spaceRepository = spaceRepository;
    }

    @Transactional(readOnly = true)
    public List<Space> findAll() {
        return spaceRepository.findAll();
    }
}
