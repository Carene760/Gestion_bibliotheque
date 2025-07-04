package org.exemple.repository;

import org.exemple.model.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
    Adherent findByEmail(String email);
}