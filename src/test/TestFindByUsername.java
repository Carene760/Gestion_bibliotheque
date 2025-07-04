package test;

import model.Utilisateur;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import repository.UtilisateurRepository;

public class TestFindByUsername {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:WEB-INF/app-context.xml");
        UtilisateurRepository utilisateurRepository = context.getBean(UtilisateurRepository.class);
        Utilisateur user = utilisateurRepository.findByUsername("test").orElse(null);
        if (user != null) {
            System.out.println("Trouvé : " + user.getUsername() + ", mot de passe : " + user.getPassword());
        } else {
            System.out.println("Non trouvé");
        }
    }
}