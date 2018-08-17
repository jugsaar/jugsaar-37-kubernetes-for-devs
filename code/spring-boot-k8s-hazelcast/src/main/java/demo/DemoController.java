package demo;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.net.Inet4Address;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/")
class DemoController {

    private final HttpSession session;

    @GetMapping
    Object getData() {
        return toResponse(loadDataInternal());
    }

    @GetMapping("{key}/{value}")
    Object putData(@PathVariable String key, @PathVariable String value) {

        Map<String, String> data = loadDataInternal();

        data.put(key, value);
        saveDataInternal(data);

        return toResponse(data);
    }

    @GetMapping(path = "{key}", params = "remove")
    Object removeData(@PathVariable String key) {

        Map<String, String> data = loadDataInternal();

        data.remove(key);
        saveDataInternal(data);

        return toResponse(data);
    }

    private Map<String, String> loadDataInternal() {
        Map<String, String> data = (Map<String, String>) session.getAttribute("data");
        if (data == null) {
            data = new HashMap<>();
        }
        return data;
    }

    private void saveDataInternal(Map<String, String> data) {
        // ignore conccurent updates for demo purposes
        session.setAttribute("data", data);
    }

    private Map<String, String> toResponse(Map<String, String> data) {

        if (data != null) {
            try {
                data.put("node", Inet4Address.getLocalHost().getHostAddress());
            } catch (UnknownHostException e) {
                e.printStackTrace();
            }
        }

        return data;
    }
}
