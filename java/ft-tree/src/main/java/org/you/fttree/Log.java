package org.you.fttree;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.mutable.MutableInt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

import com.cloudmon.alert.common.util.Tuple2;

public class Log {

    private final static Logger logger = LoggerFactory.getLogger(Log.class);

    private final static int MAX_LENGTH = 64;
    //private final static String delim = "[\\t\\n\\r \\-\"]";
    private final static String delim = "[\\t\\n\\r \"]";
    private final static List<Tuple2<String,String>> patterns;

    static {
        patterns = new LinkedList<>();

        patterns.add(new Tuple2<>("\\d+/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)/\\d+:\\d+:\\d+:\\d+ [+|-]\\d+", "TS1"));
        patterns.add(new Tuple2<>("\\d+-\\d+-\\d+%20\\d+:\\d+:\\d+(\\.\\d+){0,1}", "TS2"));

        patterns.add(new Tuple2<>("\\d+\\.\\d+\\.\\d+\\.\\d+", "IP"));
    }

    private String raw;

    public Log(String raw) {
        for (Tuple2<String,String> pattern: patterns) {
            raw = raw.replaceAll(pattern.getFirst(), pattern.getSecond());
        }
        this.raw = raw;
    }

    public String[] tokens() {
        return this.raw.split(delim);
    }

    public List<WordFreq> process(Map<String,MutableInt> words) {

        Set<String> tokens = new HashSet<String>();
        List<WordFreq> freqs = new ArrayList<>();

        for (String token: this.tokens()) {
            tokens.add(token);
        }

        for (String token: tokens) {
            if (StringUtils.isBlank(token)) {
                continue;
            }

            MutableInt cnt = words.get(token);

            if (cnt == null) {
                continue;
            }

            WordFreq freq = new WordFreq(token, cnt.intValue());
            freqs.add(freq);
        }

        Collections.sort(freqs, Collections.reverseOrder());
        return freqs;
    }
}
