import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
            if (parts.length == 2) {
                String key = parts[0];
                try {
                    int value = Integer.parseInt(parts[1]);
                    if (value >= -10000 && value <= 10000 && key.length() <= 16 && key.matches("\\S+")) {
                        sumMap.put(key, sumMap.getOrDefault(key, 0) + value);
                        countMap.put(key, countMap.getOrDefault(key, 0) + 1);
                    } else {
                        System.err.println("Invalid key or value: " + line);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid value format: " + line);
                }
            } else {
                System.err.println("Invalid line format: " + line);
            }
        }
                List<Pair<String, Double>> result = new ArrayList<>();
        for (String key : sumMap.keySet()) {
            double average = (double) sumMap.get(key) / countMap.get(key);
            result.add(new Pair<>(key, average));
        }
}
}