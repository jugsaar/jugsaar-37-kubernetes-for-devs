package demo.api.tracing;

import org.aopalliance.intercept.MethodInvocation;
import org.apache.commons.logging.Log;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.aop.Advisor;
import org.springframework.aop.aspectj.AspectJExpressionPointcut;
import org.springframework.aop.interceptor.PerformanceMonitorInterceptor;
import org.springframework.aop.support.DefaultPointcutAdvisor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
class PerformanceTraceConfig {

    /**
     * Monitoring pointcut.
     */
    @Pointcut("execution(* demo.api.web.*.*(..))")
    public void monitorTarget() {
    }

    /**
     * Creates instance of performance monitorTarget advisor.
     *
     * @return performance monitorTarget advisor
     */
    @Bean
    public Advisor performanceMonitorAdvisor() {
        AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
        pointcut.setExpression(PerformanceTraceConfig.class.getName() + ".monitorTarget()");
        return new DefaultPointcutAdvisor(pointcut, new PerformanceMonitorInterceptor(true) {
            @Override
            protected Object invokeUnderTrace(MethodInvocation invocation, Log logger) throws Throwable {
                String name = createInvocationTraceName(invocation);
                long startTime = System.nanoTime();
                try {
                    return invocation.proceed();
                } finally {
                    long durationNanos = System.nanoTime() - startTime;
                    writeToLog(logger, String.format("%s: %sns", name, durationNanos));
                }
            }
        });
    }
}


