package cdsexamples;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import javax.script.ScriptContext;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

class ScriptEngineTest {
    static int run() {
        ScriptEngineManager engineManager = new ScriptEngineManager();
        ScriptEngine engine = engineManager.getEngineByName("ECMAScript");
        ScriptContext defaultCtx = engine.getContext();

        File outputFile = new File("target", "jsoutput.txt");
        System.out.println("Script output will be written to "+outputFile.getAbsolutePath());

        FileWriter writer = null;  

        String cities[] = { "Basel", "Geneva", "Lausanne", "Sion", "Zurich" };
        engine.put("cities", cities);
        String script = "for (var index in cities) { print(cities[index]); }";
        int statusCode = 1;
        try {
            writer = new FileWriter(outputFile);
            defaultCtx.setWriter(writer);
            engine.eval(script);
            statusCode = 0;
        }
        catch (/*IO+Script*/Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (writer != null) writer.close();
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }
        return statusCode;
    }
}
