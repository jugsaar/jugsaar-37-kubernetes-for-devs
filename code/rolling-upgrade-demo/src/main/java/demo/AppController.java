package demo;

import org.springframework.boot.info.BuildProperties;
import org.springframework.boot.info.GitProperties;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.net.InetAddress;

@Controller
class AppController {

    private final BuildProperties buildProperties;
    private final GitProperties gitProperties;

    public AppController(BuildProperties buildProperties, GitProperties gitProperties) {
        this.buildProperties = buildProperties;
        this.gitProperties = gitProperties;
    }

    @GetMapping("/")
    String index(Model model) throws Exception {

        model.addAttribute("git", gitProperties);
        model.addAttribute("build", buildProperties);
        model.addAttribute("podIp", InetAddress.getLocalHost().getHostAddress());

        return "index";
    }
}
