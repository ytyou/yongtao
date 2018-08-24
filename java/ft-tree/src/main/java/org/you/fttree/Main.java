package org.you.fttree;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.mutable.MutableInt;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Stream;

public class Main {

    private final static Logger logger = LoggerFactory.getLogger(Main.class);

    private static Map<String,MutableInt> words = new HashMap<>();
    private static FTTree tree;

    public static void main(String[] args) {

        String file = args[0];

        logger.info("Reading logs from {}", file);

        // Learning
        try {
            try (Stream<String> stream = Files.lines(Paths.get(file))) {
                stream.forEachOrdered(line -> parse(line));
            }
        }
        catch (IOException ioex) {
            logger.error("Failed to read logs", ioex);
        }

        // Build FT-Tree
        tree = new FTTree(words);

        try {
            try (Stream<String> stream = Files.lines(Paths.get(file))) {
                stream.forEachOrdered(line -> buildTree(line));
            }
        }
        catch (IOException ioex) {
            logger.error("Failed to build FT-Tree", ioex);
        }

        // Clustering
        tree.printClusters();

        //printWords();
        //System.out.println(tree.toString());
    }

    private static void parse(String raw) {
        Log log = new Log(raw);
        String[] tokens = log.tokens();

        for (String token: tokens) {

            if (StringUtils.isBlank(token)) {
                continue;
            }

            MutableInt mint = words.get(token);

            if (mint != null) {
                mint.increment();
            }
            else {
                words.put(token, new MutableInt(1));
            }
        }
    }

    private static void buildTree(String raw) {
        Log log = new Log(raw);
        tree.build(log);
    }

    private static void printWords() {

        List<WordFreq> set = new ArrayList<>();

        for (Map.Entry<String,MutableInt> entry: words.entrySet()) {
            WordFreq wf = new WordFreq(entry.getKey(), entry.getValue().intValue());
            set.add(wf);
        }

        Collections.sort(set);

        for (WordFreq wf: set) {
            System.out.println(wf.toString());
        }
    }
}
