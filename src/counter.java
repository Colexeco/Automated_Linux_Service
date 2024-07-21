import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;
import java.lang.System;
import java.util.concurrent.TimeUnit;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

class counter {
    public static void main(String[] args) {
        int count = 0;
        try {
            BufferedWriter myWriter = new BufferedWriter(new FileWriter("/tmp/currentCount.out", true));
            Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                System.out.flush();
                System.out.println("Received SIGTERM. Exiting...");
                try {
                    myWriter.append("Received SIGTERM. Exiting...");
                    myWriter.newLine();
                    myWriter.flush();
                    myWriter.close();
                } catch (IOException e) {
                    System.out.println("An error occurred while writing to the file.");
                    e.printStackTrace();
                }
            }));
            while (true) {
                String username = System.getenv("USERNAME");
                Date date = new Date();
                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");

                String strDate = dateFormat.format(date);
                String strTime = timeFormat.format(date);

                String countString = Integer.toString(count);
                String formattedOutput = username + ": " + strDate + " " + strTime + " #" + countString + "\n";
                myWriter.append(formattedOutput);
                myWriter.newLine();
                myWriter.flush();
                System.out.println(formattedOutput);
                try {
                    TimeUnit.SECONDS.sleep(1);
                    count++;
                } catch (InterruptedException e) {
                    System.out.println("An interrupt error occurred while waiting one second.");
                    e.printStackTrace();
                }
            }
        } catch (IOException e) {
            System.out.println("An error occurred while writing to the file.");
            e.printStackTrace();
        }
    }
}
