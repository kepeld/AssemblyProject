import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Variant3 {
    static class Pair<A, B> {
        public final A key;
        public final B value;

        public Pair(A key, B value) {
            this.key = key;
            this.value = value;
        }
    }
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Map<String, Integer> sumMap = new HashMap<>();
        Map<String, Integer> countMap = new HashMap<>();

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            String[] parts = line.split("\\s+", 2);
}
}
}