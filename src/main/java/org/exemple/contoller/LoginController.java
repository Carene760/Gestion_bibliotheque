package org.exemple.contoller;

import org.exemple.model.Utilisateur;
import org.exemple.service.UtilisateurService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/login")
public class LoginController {
    @Autowired
    private UtilisateurService utilisateurService;

    @GetMapping
    public String showLoginForm() {
        return "login";
    }

    @PostMapping("/verifierConnexion")
    public String login(
        @RequestParam("username") String username,
        @RequestParam("password") String password,
        Model model, HttpSession session) {
        Utilisateur user = utilisateurService.login(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            String role = user.getRole();
            if ("BIBLIOTHECAIRE".equals(role)) {
                // return "redirect:/livres/liste";
                return "login";

            } else {
                // return "redirect:/adherents/home";
                return "login";
            }
        } else {
            model.addAttribute("error", "Identifiants invalides");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
