package cdsexamples;

import java.lang.management.ManagementFactory;
import java.lang.management.RuntimeMXBean;
import java.util.List;

class VMOptions {
    static List<String> get() {
        RuntimeMXBean runtimeMxBean = ManagementFactory.getRuntimeMXBean();
        return runtimeMxBean.getInputArguments();
    }
    private static final String sep = System.lineSeparator()+"   ";
    static String asString() {
        return "VM Options:"+sep+String.join(sep, VMOptions.get());
    }
}
