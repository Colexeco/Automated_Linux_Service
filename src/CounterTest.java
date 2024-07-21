import junit.framework.TestCase;
import java.io.File;
//followed: http://ieng6.ucsd.edu/~cs15x/labs/lab4_oasdfw/index.html
public class CounterTest extends junit.framework.TestCase {
    public CounterTest(String name) {
        super(name);
    }

    public void testCounterInSystemDir() {
        File counterFile = new File("/lib/systemd/system/counter.class");
        assertTrue(counterFile.exists());
    }

    public void testCounterTempFileExists() {
        File counterFile = new File("/tmp/currentCount.out");
        assertTrue(counterFile.exists());
    }

    public static void main(String[] args) {
        junit.textui.TestRunner.main(new String[] {"CounterTest"});
    }
}