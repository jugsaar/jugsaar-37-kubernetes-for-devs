package demo.app;

import com.fasterxml.jackson.annotation.JsonAnySetter;
import lombok.Data;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@FeignClient(name = "demo-api-service") // K8S service name of the demo-api serice
public interface CalcApi {

    @GetMapping("/api/calc")
    CalcResult calc(@RequestParam BigDecimal x, @RequestParam BigDecimal y, @RequestParam(defaultValue = "PLUS") String op);

    @Data
    class CalcResult {

        String result;

        Map<String, Object> properties = new HashMap<>();

        // collect any unknown JSON properties we receive
        @JsonAnySetter
        public void setProperty(String name, Object value) {
            this.properties.put(name, value);
        }
    }
}
