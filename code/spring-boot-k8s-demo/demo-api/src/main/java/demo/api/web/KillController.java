package demo.api.web;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

@Slf4j
@RestController
class KillController {

    @GetMapping("/api/kill")
    Object kill() {

        log.info("killing container");
        Executors.newSingleThreadScheduledExecutor().schedule(() -> System.exit(-1), 1, TimeUnit.SECONDS);

        return Collections.singletonMap("status", "killed");
    }
}
