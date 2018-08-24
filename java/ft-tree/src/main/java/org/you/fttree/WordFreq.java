package org.you.fttree;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Comparator;

public class WordFreq implements Comparable<WordFreq> {

    public class FreqComparator implements Comparator<WordFreq> {

        @Override
        public int compare(WordFreq left, WordFreq right) {
            if (left == null || right == null) {
                throw new NullPointerException("other is null");
            }

            return left.freq - right.freq;
        }
    }

    private final static Logger logger = LoggerFactory.getLogger(WordFreq.class);

    private int freq;
    private String word;

    public WordFreq(String word, int freq) {
        this.freq = freq;
        this.word = word;
    }

    public String getWord() {
        return this.word;
    }

    @Override
    public int compareTo(WordFreq other) {

        if (other == null) {
            throw new NullPointerException("other is null");
        }

        return this.freq - other.freq;
    }

    @Override
    public String toString() {
        return String.format("\"%s\":%d", this.word, this.freq);
    }
}
