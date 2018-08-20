package demo.app;

import lombok.RequiredArgsConstructor;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequiredArgsConstructor
class AppController {

    private final CalcApi calcApi;

    private final DiscoveryClient discoveryClient;

    @GetMapping("/services")
    public List<String> services() {
        return this.discoveryClient.getServices();
    }

    @GetMapping("/calc")
    public CalcApi.CalcResult calc(BigDecimal x, BigDecimal y, @RequestParam(defaultValue = "PLUS") String op) {

        // call calcApi from demo-api-service
        CalcApi.CalcResult result = calcApi.calc(x, y, op);

        return result;
    }
}
