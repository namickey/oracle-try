import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        try (BufferedWriter f = new BufferedWriter(new FileWriter("test-data-gen/2.fixed-length-file/aa.txt"))) {
            // Header
            f.write("120250101                    \n");

            // Data
            for (int i = 1; i < 1000000; i++) {
                String line = "2001pen       1" + String.format("%06d", i) + "00000100\n";
                f.write(line);
            }

            // End
            f.write("9end                         \n");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}