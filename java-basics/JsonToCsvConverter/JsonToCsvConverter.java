import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.opencsv.CSVWriter;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class JsonToCsvConverter {

    public static void main(String[] args) {
        String jsonFilePath = "input.json"; // Path to your JSON file
        String csvFilePath = "output.csv";  // Path where CSV file will be saved

        try {
            // Read JSON file
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode rootNode = objectMapper.readTree(new File(jsonFilePath));

            // Create CSV writer
            CSVWriter csvWriter = new CSVWriter(new FileWriter(csvFilePath));

            // Write header row
            String[] header = {"Field1", "Field2", "Field3"}; // Adjust fields as needed
            csvWriter.writeNext(header);

            // Convert JSON data to CSV rows
            for (JsonNode jsonNode : rootNode) {
                String field1 = jsonNode.get("field1").asText(); // Replace with your JSON field names
                String field2 = jsonNode.get("field2").asText();
                String field3 = jsonNode.get("field3").asText();
                String[] csvRow = {field1, field2, field3};
                csvWriter.writeNext(csvRow);
            }

            // Close CSV writer
            csvWriter.close();
            
            System.out.println("CSV conversion successful!");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
